//
//  MapReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation


import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class MapReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case selectFilter(String)
        case userLocationDidChanged((Double, Double))
        case mapViewCameraPositionDidChanged((Double, Double))
    }
    
    enum Mutation {
        case setFilter(String)
        case setMapLocation((Double, Double))
        case setUserLocation((Double, Double))
        case setMapMarkers([MapWithCategorySearchResponseResult])
    }
    
    struct State {
        var mapCenterLocation: (Double, Double)?
        var userLocation: (Double, Double)?
        var mapMarkers: [MapWithCategorySearchResponseResult] = []
        var mapCategoryFilters: [String]
        var mapFilterSelected: [String: Bool]
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let categoryFilterList: [String] = ["bookmark"] + MainMapCategory.allCategoryString.split(separator: ",").map { String($0) }
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(mapCategoryFilters: categoryFilterList,
                                  mapFilterSelected: Dictionary(uniqueKeysWithValues: categoryFilterList.map { (String($0), false) }))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case .selectFilter(let filter):
            return .just(.setFilter(filter))
        case .userLocationDidChanged(let position):
            return .just(.setUserLocation(position))
        case .mapViewCameraPositionDidChanged(let position):
            let selectedCategories = Array(currentState.mapFilterSelected.filter({ $0.value == true }).keys)
            return Observable.concat([
                provider.mapService.filterMap(data: CategoryMapFilterData(category: selectedCategories,
                                                                          latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                                          longitude: currentState.mapCenterLocation?.1 ?? 0.0)).data().decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder()).flatMap { data -> Observable<Mutation> in
                                                                              return .just(.setMapMarkers(data.result))
                                                                          }
                ,.just(.setMapLocation(position))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setMapLocation(let position):
            state.mapCenterLocation = position
        case .setUserLocation(let position):
            state.userLocation = position
        case .setFilter(let filter):
            state.mapFilterSelected[filter]?.toggle()
        case .setMapMarkers(let markers):
            state.mapMarkers = markers
        }
        
        return state
    }
}
