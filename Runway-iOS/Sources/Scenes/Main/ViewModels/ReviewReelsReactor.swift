//
//  ReviewReelsReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ReviewReelsReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case exitButtonDidTap
        case swipeNextReview
        case swipePreviousReview
        case bookmarkButtonDidTap(Int)
        case showRoomButtonDidTap(Int)
        
        case removeButtonDidTap(Int)
        case reportButtonDidTap(Int)
    }
    
    enum Mutation {
        case setReviewData(ReviewDetailResponseResult)
        case appendReviewData(ReviewDetailResponseResult)
        case insertFrontReviewData(ReviewDetailResponseResult)
    }
    
    struct State {
        var previousReviewId: Int? = nil
        var nextReviewId: Int? = nil
        
        var currentShowingReviewId: Int? = nil
        var reviewData: [ReviewDetailResponseResult] = []
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let intialReviewId: Int
    
    // MARK: - initializer
    init(provider: ServiceProviderType, intialReviewId reviewId: Int) {
        self.provider = provider
        self.initialState = State()
        self.intialReviewId = reviewId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return provider.showRoomService.reviewDetail(reviewId: intialReviewId)
                .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                .map { .setReviewData($0.result) }
        case .swipeNextReview:
            guard let nextReviewId = currentState.nextReviewId else {
                steps.accept(AppStep.back(animated: false))
                return .empty()
            }
            
            return provider.showRoomService.reviewDetail(reviewId: nextReviewId)
                .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                .map { .appendReviewData($0.result) }
            
        case .swipePreviousReview:
            guard let previousReviewId = currentState.previousReviewId else {
                steps.accept(AppStep.back(animated: false))
                return .empty()
            }
            
            return provider.showRoomService.reviewDetail(reviewId: previousReviewId)
                .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                .map { .insertFrontReviewData($0.result) }
            
        case .bookmarkButtonDidTap(let reviewId):
            return provider.showRoomService.reviewDetail(reviewId: reviewId)
                .data().decode(type: BaseResponse.self, decoder: JSONDecoder())
                .flatMap { response -> Observable<Mutation> in
                    if response.isSuccess {
                        return .empty()
                    } else {
                        // ...?
                        return .empty()
                    }
                }
            
        case .showRoomButtonDidTap(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .removeButtonDidTap(let reviewId):
            steps.accept(AppStep.back(animated: false))
            return .empty()
            
        case .reportButtonDidTap(let reviewId):
            return .empty()
            
        case .exitButtonDidTap:
            steps.accept(AppStep.back(animated: false))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case.setReviewData(let result):
            state.previousReviewId = result.reviewInquiry?.prevReviewID
            state.nextReviewId = result.reviewInquiry?.nextReviewID
            state.reviewData = [result]
            state.currentShowingReviewId = result.reviewID
            
        case .appendReviewData(let result):
            state.reviewData.append(result)
            state.currentShowingReviewId = result.reviewID
            state.nextReviewId = result.reviewInquiry?.nextReviewID
            
        case .insertFrontReviewData(let result):
            state.reviewData.insert(result, at: 0)
            state.currentShowingReviewId = result.reviewID
            state.previousReviewId = result.reviewInquiry?.prevReviewID
        }
        
        return state
    }
}
