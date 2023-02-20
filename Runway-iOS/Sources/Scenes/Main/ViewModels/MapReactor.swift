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
        case mapViewCameraPositionDidChanged((Double, Double))
    }
    
    enum Mutation {
        case setMapLocation((Double, Double))
    }
    
    struct State {
        var currentLocation: (Double, Double)
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(currentLocation: (0.0, 0.0))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .mapViewCameraPositionDidChanged(let position):
            return .just(.setMapLocation(position))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setMapLocation(let position):
            state.currentLocation = position
        }
        
        return state
    }
}
