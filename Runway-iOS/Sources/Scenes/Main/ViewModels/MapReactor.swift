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
        case searchButtonDidTap
        case userLocationDidChanged((Double, Double))
        case mapViewCameraPositionDidChanged((Double, Double))
        case selectMapMarker(Int)
        case bottomSheetScrollReachesBottom
    }
    
    enum Mutation {
        case setFilter(String)
        case setMapLocation((Double, Double))
        case setUserLocation((Double, Double))
        case setMapMarkers([MapWithCategorySearchResponseResult])
        case setAroundDatas([AroundMapSearchResponseResultContent], isLast: Bool)
        case setMapMarkerSelectData(MapMarkerSelectResponseResult)
    }
    
    struct State {
        var mapCenterLocation: (Double, Double)?
        var userLocation: (Double, Double)?
        var mapMarkers: [MapWithCategorySearchResponseResult] = []
        var mapMarkerSelectData: MapMarkerSelectResponseResult? = nil
        var aroundDatas: [AroundMapSearchResponseResultContent] = []
        var mapCategoryFilters: [String]
        var mapFilterSelected: [String: Bool]
        
        var mapInfoIsLast: Bool = false
        var mapInfoPage: Int = 0
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let categoryFilterList: [String] = ["bookmark"] + MainMapCategory.allCategoryString.split(separator: ",").map { String($0) }
    
    // 맵에 표시될 마커들을 캐싱
    let markerCache = NSCacheManager<MapMarker>()
    
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
            var filterDict = currentState.mapFilterSelected
            filterDict[filter]?.toggle()
            
            let selectedCategories = Array(filterDict.filter { $0.value == true }.keys)
            let mapDatas = provider.mapService.filterMap(data: CategoryMapFilterData(category: selectedCategories,
                                                                                     latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                                                     longitude: currentState.mapCenterLocation?.1 ?? 0.0)).data().decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder()).map { $0.result }
            
            return Observable.concat([
                mapDatas.flatMap { datas -> Observable<Mutation> in
                    return .just(.setMapMarkers(datas))
                }
                , .just(.setFilter(filter))
            ])
        case .searchButtonDidTap:
            let selectedCategories = Array(currentState.mapFilterSelected.filter({ $0.value == true }).keys)
            let mapFilterData = CategoryMapFilterData(category: selectedCategories,
                                                      latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                      longitude: currentState.mapCenterLocation?.1 ?? 0.0)
            return Observable.concat([
                provider.mapService.filterMap(data: mapFilterData).data()
                    .decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder())
                    .flatMap { [weak self] data -> Observable<Mutation> in
                        var isDatasAllCached = true
                        for markerData in data.result {
                            if self?.markerCache.fetchObject(name: String(markerData.storeID)) == nil {
                                isDatasAllCached = false
                                let marker = MapMarker(storeID: markerData.storeID, storeName: markerData.storeName, bookmark: markerData.bookmark, latitude: markerData.latitude, longitude: markerData.longitude)
                                self?.markerCache.saveObject(object: marker, forKey: String(markerData.storeID))
                            }
                        }
                        
                        // 모든 데이터가 캐싱 -> empty 방출
                        return isDatasAllCached ? .empty() : .just(.setMapMarkers(data.result))
                    },
                provider.mapService.mapInfo(data: mapFilterData, page: 0, size: 10).data()
                    .decode(type: AroundMapSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        if let contents = result.result?.contents, let isLast = result.result?.isLast {
                            return .just(.setAroundDatas(contents, isLast: isLast))
                        } else {
                            return .empty()
                        }
                    }
            ])
        case .bottomSheetScrollReachesBottom:
            if currentState.mapInfoIsLast {
                return .empty()
            } else {
                let selectedCategories = Array(currentState.mapFilterSelected.filter({ $0.value == true }).keys)
                let mapFilterData = CategoryMapFilterData(category: selectedCategories,
                                                          latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                          longitude: currentState.mapCenterLocation?.1 ?? 0.0)
                return provider.mapService.mapInfo(data: mapFilterData, page: currentState.mapInfoPage, size: 10).data()
                    .decode(type: AroundMapSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        if let contents = result.result?.contents, let isLast = result.result?.isLast {
                            return .just(.setAroundDatas(contents, isLast: isLast))
                        } else {
                            return .empty()
                        }
                    }
            }
            
        case .selectMapMarker(let storeId):
            return provider.mapService
                .mapInfoBottomSheet(storeId: storeId).data().decode(type: MapMarkerSelectResponse.self, decoder: JSONDecoder())
                .flatMap { data -> Observable<Mutation> in
                    return .just(.setMapMarkerSelectData(data.result))
                }
        case .userLocationDidChanged(let position):
            return .just(.setUserLocation(position))
        case .mapViewCameraPositionDidChanged(let position):
            // TODO: - 추후 마커단위로 로드할 수 있게 개선
            return .just(.setMapLocation(position))
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
        case .setAroundDatas(let datas, let isLast):
            state.aroundDatas += datas
            state.mapInfoIsLast = isLast
            if !isLast {
                state.mapInfoPage += 1
            }
        case .setMapMarkerSelectData(let data):
            state.mapMarkerSelectData = data
        }
        
        return state
    }
}
