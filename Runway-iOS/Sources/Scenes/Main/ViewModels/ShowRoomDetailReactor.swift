////
////  ShowRoomDetailReactor.swift
////  Runway-iOS
////
////  Created by 김인환 on 2023/02/27.
////
//
//import Foundation
//
//import ReactorKit
//import RxFlow
//import RxSwift
//import RxCocoa
//
//import Alamofire
//
//
//final class ShowRoomDetailReactor: Reactor, Stepper {
//    // MARK: - Events
//
//    enum Action {
//        case viewWillAppear
//
//    enum Mutation {
//        case setShowRoomImageUrl(String)
//    }
//
//    struct State {
//        var showRoomImageURL: String? = nil
//    }
//
//    // MARK: - Properties
//
//    var steps = PublishRelay<Step>()
//
//    let initialState: State
//    let provider: ServiceProviderType
//
//    private let disposeBag = DisposeBag()
//
//    let storeId: Int
//
//    // MARK: - initializer
//    init(provider: ServiceProviderType, storeId: Int) {
//        self.provider = provider
//        self.initialState = State()
//        self.storeId = storeId
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .viewWillAppear:
//            return Observable.concat([
//                provider.showRoomService.storeDetail(storeId: storeId)
//                    .data().decode(type: <#T##Decodable.Protocol#>, decoder: JSONDecoder())
//            ])
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//
//    }
//}
