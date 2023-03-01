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

import RealmSwift
import Alamofire


final class MapReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case selectFilter(String)
        case searchButtonDidTap
        case searchFieldDidTap
        case searchFieldInput(String)
        case userLocationDidChanged((Double, Double))
        case mapViewCameraPositionDidChanged((Double, Double))
        case selectMapMarkerData(Int)
        case bottomSheetScrollReachesBottom
        case regionSearchBottomSheetScrollReachesBottom
        case historyAllClearButtonDidTap
        case selectSearchItem(Int)
    }
    
    enum Mutation {
        case setFilter(String)
        case setMapLocation((Double, Double))
        case setUserLocation((Double, Double))
        case setMapMarkers([MapWithCategorySearchResponseResult])
        case setAroundDatas([AroundMapSearchResponseResultContent], isLast: Bool)
        case setAroundDatasAppend([AroundMapSearchResponseResultContent], isLast: Bool)
        
        case setStoreSearchMarkerData(MapMarker?)
        case setStoreSearchInfoData(StoreInfo?)
        case setRegionSearchDatas([RegionSearchResponseResult], Int) // regionId를 함께 저장
        case setRegionAroundDatas([RegionAroundMapSearchResponseResultContent], isLast: Bool)
        case setRegionAroundDatasAppend([RegionAroundMapSearchResponseResultContent], isLast: Bool)
        
        case setMapMarkerSelectData(MapMarkerSelectResponseResult)
        case setMapHistories([MapSearchHistory])
        case setMapKeywordSearchData([KeywordSearchItem])
        
        case setSearchInfo
    }
    
    struct State {
        var mapCenterLocation: (Double, Double)?
        var userLocation: (Double, Double)?
        var mapMarkers: [MapWithCategorySearchResponseResult] = []
        var mapMarkerSelectData: MapMarkerSelectResponseResult? = nil
        var aroundDatas: [AroundMapSearchResponseResultContent] = []
        
        var mapCategoryFilters: [String]
        var mapFilterSelected: [String: Bool]
        
        // search
        var storeSearchMarker: MapMarker? = nil
        var storeSearchInfo: StoreInfo? = nil
        var regionSearchMarkerDatas: ([RegionSearchResponseResult], Int)? = nil
        var mapKeywordSearchData: [KeywordSearchItem] = []
        var mapSearchHistories: [MapSearchHistory]? = nil
        
        var regionSearchAroundDatas: [RegionAroundMapSearchResponseResultContent] = []
        var searchRegionId: Int? = nil
        var regionInfoIsLast: Bool = false
        var regionInfoPage: Int = 0
        
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
    let markerCache = NSCacheManager<MapMarkerData>()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(mapCategoryFilters: categoryFilterList,
                                  mapFilterSelected: Dictionary(uniqueKeysWithValues: categoryFilterList.map { (String($0), false) }))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let histories = provider.realm?.objects(MapSearchHistory.self).sorted(byKeyPath: "date", ascending: false)
            var historyContainer = [MapSearchHistory]()
            histories?.forEach {
                historyContainer.append($0)
            }
            return .just(.setMapHistories(historyContainer))
        case .selectFilter(let filter):
            var filterDict = currentState.mapFilterSelected
            filterDict[filter]?.toggle()
            
            let selectedCategories = Array(filterDict.filter { $0.value == true }.keys)
            let mapDatas = provider.mapService.filterMap(data: CategoryMapFilterData(category: selectedCategories,
                                                                                     latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                                                     longitude: currentState.mapCenterLocation?.1 ?? 0.0))
                .data().decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder())
                .map { $0.result }
            
            return Observable.concat([
                mapDatas.flatMap { datas -> Observable<Mutation> in
                    return .just(.setMapMarkers(datas))
                }
                , .just(.setFilter(filter))
            ])
            
        case .searchFieldDidTap:
            let histories = provider.realm?.objects(MapSearchHistory.self).sorted(byKeyPath: "date", ascending: false)
            var historyContainer = [MapSearchHistory]()
            histories?.forEach {
                historyContainer.append($0)
            }
            return .just(.setMapHistories(historyContainer))
            
        case .searchFieldInput(let text):
            if text.isEmpty {
                return .just(.setMapKeywordSearchData([]))
            } else {
                return provider.mapService.mapSearch(data: MapSearchData(content: text,
                                                                         latitude: currentState.mapCenterLocation?.0 ?? 0.0,
                                                                         longitude: currentState.mapCenterLocation?.1 ?? 0.0)).data().decode(type: MapKeywordSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        let datas = (result.result.regionSearchList + result.result.storeSearchList)
                        return datas.isEmpty ? .just(.setMapKeywordSearchData([])) : .just(.setMapKeywordSearchData(datas))
                    }
            }
            
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
                                let marker = MapMarkerData(storeID: markerData.storeID, storeName: markerData.storeName, bookmark: markerData.bookmark, latitude: markerData.latitude, longitude: markerData.longitude)
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
            
        case .historyAllClearButtonDidTap:
            do {
                try provider.realm?.write {
                    guard let histories = provider.realm?.objects(MapSearchHistory.self) else { return }
                    provider.realm?.delete(histories)
                }
            } catch {
                print(error)
            }
            
            return Observable.concat([
                .just(.setMapKeywordSearchData([])),
                .just(.setMapHistories([]))
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
                            return .just(.setAroundDatasAppend(contents, isLast: isLast))
                        } else {
                            return .empty()
                        }
                    }
            }
        case .selectSearchItem(let index):
            let searchItem = currentState.mapKeywordSearchData[index]
            // 매장
            if let storeName = searchItem.storeName {
                let history = provider.realm?.objects(MapSearchHistory.self).where {
                    $0.name == storeName
                }.first
                if history == nil { // create
                    let newHistory = MapSearchHistory()
                    newHistory.name = storeName
                    newHistory.storeId = searchItem.storeID
                    newHistory.isStore = true
                    do {
                        try provider.realm?.write {
                            provider.realm?.create(MapSearchHistory.self, value: newHistory)
                        }
                    } catch {
                        print(error)
                    }
                } else { // update
                    do {
                        try provider.realm?.write {
                            history?.date = Date()
                        }
                    } catch {
                        print(error)
                    }
                }
            // 지역
            } else if let regionName = searchItem.region {
                let history = provider.realm?.objects(MapSearchHistory.self).where {
                    $0.name == regionName
                }.first
                if history == nil {
                    let newHistory = MapSearchHistory()
                    newHistory.name = regionName
                    newHistory.regionId = searchItem.regionID
                    newHistory.isStore = false
                    do {
                        try provider.realm?.write {
                            provider.realm?.create(MapSearchHistory.self, value: newHistory)
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    do {
                        try provider.realm?.write {
                            history?.date = Date()
                        }
                    } catch {
                        print(error)
                    }
                }
            } else { // error
                return .empty()
            }
            
            if let storeId = searchItem.storeID { // 매장검색
                return provider.mapService.searchStore(storeId: storeId)
                    .data().decode(type: StoreSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        return Observable.concat([
                            .just(.setStoreSearchInfoData(result.result.storeInfo)),
                            .just(.setStoreSearchMarkerData(result.result.mapMarker)),
                        ])
                    }
            } else if let regionId = searchItem.regionID { // 지역검색
                
                return Observable.concat([
                    provider.mapService.searchMapRegion(regionId: regionId)
                        .data().decode(type: RegionSearchResponse.self, decoder: JSONDecoder())
                        .flatMap { result -> Observable<Mutation> in
                            return .just(.setRegionSearchDatas(result.result, regionId))
                        },
                    
                    provider.mapService.searchMapInfoRegion(regionId: regionId, page: 0, size: 10)
                        .data().decode(type: RegionAroundMapSearchResponse.self, decoder: JSONDecoder())
                        .flatMap { result -> Observable<Mutation> in
                            return .just(.setRegionAroundDatas(result.result.contents, isLast: result.result.isLast))
                        }
                ])
                
            } else {
                return .empty()
            }
            
        case .regionSearchBottomSheetScrollReachesBottom:
            if currentState.regionInfoIsLast {
                return .empty()
            }
            return provider.mapService.searchMapInfoRegion(regionId: currentState.searchRegionId ?? 0, page: currentState.regionInfoPage, size: 10).data().decode(type: RegionAroundMapSearchResponse.self, decoder: JSONDecoder())
                .flatMap { result -> Observable<Mutation> in
                    return .just(.setRegionAroundDatasAppend(result.result.contents, isLast: result.result.isLast))
                }

        case .selectMapMarkerData(let storeId):
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
        case .setMapHistories(let histories):
            state.mapSearchHistories = histories
        case .setFilter(let filter):
            state.mapFilterSelected[filter]?.toggle()
        case .setMapKeywordSearchData(let data):
            state.mapKeywordSearchData = data
        case .setMapMarkers(let markers):
            state.mapMarkers = markers
        case .setAroundDatasAppend(let datas, let isLast):
            state.aroundDatas += datas
            state.mapInfoIsLast = isLast
            if !isLast {
                state.mapInfoPage += 1
            }
        case .setRegionSearchDatas(let datas, let regionId):
            state.regionSearchMarkerDatas = (datas, regionId)
            
        case .setStoreSearchInfoData(let data):
            state.storeSearchInfo = data
        case .setStoreSearchMarkerData(let markerData):
            state.storeSearchMarker = markerData
            
        case .setAroundDatas(let datas, let isLast):
            state.aroundDatas = datas
            state.mapInfoIsLast = isLast
            state.mapInfoPage = 0
            if !isLast {
                state.mapInfoPage += 1
            }
        case .setRegionAroundDatas(let datas, let isLast):
            state.regionSearchAroundDatas = datas
            state.regionInfoPage = 0
            state.regionInfoIsLast = isLast
            if !isLast {
                state.regionInfoPage += 1
            }
            
        case .setRegionAroundDatasAppend(let datas, let isLast):
            state.regionSearchAroundDatas += datas
            state.regionInfoIsLast = isLast
            if !isLast {
                state.regionInfoPage += 1
            }
            
        case .setSearchInfo:
            break
        case .setMapMarkerSelectData(let data):
            state.mapMarkerSelectData = data
        }
        
        return state
    }
}
