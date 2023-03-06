////
////  RWReviewReelsCollectionViewCellReactor.swift
////  Runway-iOS
////
////  Created by 김인환 on 2023/03/06.
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
//final class RWReviewReelsCollectionViewCellReactor: Reactor, Stepper {
//    // MARK: - Events
//    
//    struct State {
//        let isBookmarked: Bool
//        let bookmarkCount: Int
//        let imageURL: String
//        let isMine: Bool
//        let profileImageURL: String?
//        let nickname, regionInfo: String
//        let reviewID: Int
//        let storeID: Int
//        let storeName: String
//    }
//    
//    enum Action {
//
//    }
//    
//    enum Mutation {
//
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
//    let reviewId: Int
//    
//    // MARK: - initializer
//    init(provider: ServiceProviderType, data: ReviewDetailResponseResult) {
//        self.provider = provider
//        self.initialState = State(isBookmarked: data.isBookmarked,
//                                  bookmarkCount: data.bookmarkCount,
//                                  imageURL: data.imageURL,
//                                  isMine: data.isMine,
//                                  profileImageURL: data.profileImageURL,
//                                  nickname: data.nickname,
//                                  regionInfo: data.regionInfo,
//                                  reviewID: data.reviewID,
//                                  storeID: data.storeID,
//                                  storeName: data.storeName)
//        
//        self.reviewId = data.reviewID
//        
//    }
//    
//    func mutate(action: Action) -> Observable<Mutation> {
//        
//    }
//    
//    func reduce(state: State, mutation: Mutation) -> State {
//
//    }
//}
//
