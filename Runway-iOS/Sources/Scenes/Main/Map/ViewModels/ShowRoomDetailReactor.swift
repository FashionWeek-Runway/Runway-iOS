//
//  ShowRoomDetailReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ShowRoomDetailReactor: Reactor, Stepper {
    // MARK: - Events

    enum Action {
        case viewWillAppear
        case backButtonDidTap
        case bookmarkButtonDidTap
        case directionButtonDidTap
        case informationChangeRequestButtonDidTap
        case userReviewScrollReachesBottom
        case reviewCellDidTap(Int)
        case pickingReviewImage(Data?)
        case moreButtonDidTap
    }

    enum Mutation {
        case setStoreDetailInfo(ShowRoomDetailResponseResult)
        case setStoreReview(UserReviewResponseResult)
        case setStoreReviewAppend(UserReviewResponseResult)
        case setIsBookMark(Bool)
        case setBlogReviews([ShowRoomBlogsResponseResult])
        case setAllBlogReviews
    }

    struct State {
        var mainImageUrlList: [String] = []
        var title: String = ""
        var categories: [String] = []
        var address: String = ""
        var timeInfo: String = ""
        var phoneNumber: String = ""
        var instagramID: String = ""
        var webSiteLink: String = ""
        var isBookmark: Bool = false
        var latitude: Double? = nil
        var longitude: Double? = nil
        
        var userReviewImages: [UserReviewResponseResultContent] = []
        fileprivate var blogReviews: [ShowRoomBlogsResponseResult] = []
        var blogReviewsToShow: [ShowRoomBlogsResponseResult] = []
        var isMoreButtonHidden: Bool {
            blogReviews.count == blogReviewsToShow.count
        }
        
        var userReviewPage: Int = 0
        var userReviewIsLast: Bool = false
    }

    // MARK: - Properties

    var steps = PublishRelay<Step>()

    let initialState: State
    let provider: ServiceProviderType

    private let disposeBag = DisposeBag()

    let storeId: Int

    // MARK: - initializer
    init(provider: ServiceProviderType, storeId: Int) {
        self.provider = provider
        self.initialState = State()
        self.storeId = storeId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewWillAppear:
            return Observable.concat([
                provider.showRoomService.storeDetail(storeId: storeId)
                    .data().decode(type: ShowRoomDetailResponse.self, decoder: JSONDecoder())
                    .flatMap { [weak self] data -> Observable<Mutation> in
                        guard let self else { return .empty() }
                        
                        return self.provider.showRoomService.storeBlogs(storeId: self.storeId, storeName: data.result.storeName)
                            .data().decode(type: ShowRoomBlogsResponse.self, decoder: JSONDecoder())
                            .flatMap { blogData -> Observable<Mutation> in
                                Observable.concat([
                                    .just(.setStoreDetailInfo(data.result)),
                                    .just(.setBlogReviews(blogData.result))
                                ])
                            }
                    },
                provider.showRoomService.storeReview(storeId: storeId, page: 0, size: 5)
                    .data().decode(type: UserReviewResponse.self, decoder: JSONDecoder())
                    .map { Mutation.setStoreReview($0.result)},
            ])
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .directionButtonDidTap:
            guard let lat = currentState.latitude, let lng = currentState.longitude else { return .empty() }
            steps.accept(AppStep.openNaverMap(title: currentState.title, lat: lat, lng: lng))
            return .empty()
            
        case .informationChangeRequestButtonDidTap:
            steps.accept(AppStep.showRoomInformationChangeRequest(storeId))
            return .empty()
            
        case .bookmarkButtonDidTap:
            provider.showRoomService.storeBookmark(storeId: storeId)
                .subscribe().disposed(by: disposeBag)
            return .just(.setIsBookMark(!currentState.isBookmark))
            
        case .userReviewScrollReachesBottom:
            if currentState.userReviewIsLast {
                return .empty()
            } else {
                return provider.showRoomService.storeReview(storeId: storeId, page: currentState.userReviewPage, size: 5)
                    .data().decode(type: UserReviewResponse.self, decoder: JSONDecoder())
                    .map { Mutation.setStoreReviewAppend($0.result)}
            }
            
        case .reviewCellDidTap(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .store))
            return .empty()
            
        case .pickingReviewImage(let imageData):
            guard let imageData else { return .empty() }
            steps.accept(AppStep.editReviewImage(storeId, imageData))
            return .empty()
            
        case .moreButtonDidTap:
            return .just(.setAllBlogReviews)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setStoreDetailInfo(let result):
            state.mainImageUrlList = result.imageURLList
            state.title = result.storeName
            state.categories = result.category
            state.address = result.address
            state.timeInfo = result.storeTime
            state.phoneNumber = result.storePhone
            state.instagramID = result.instagram
            state.webSiteLink = result.webSite
            state.isBookmark = result.bookmark
            state.latitude = result.latitude
            state.longitude = result.longitude
            
        case .setIsBookMark(let isSelected):
            state.isBookmark = isSelected
            
        case .setStoreReview(let result):
            state.userReviewPage = 0
            state.userReviewImages = result.contents
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setStoreReviewAppend(let result):
            state.userReviewImages.append(contentsOf: result.contents)
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setBlogReviews(let results):
            state.blogReviews = results
            state.blogReviewsToShow = Array(results.prefix(5))
            
        case .setAllBlogReviews:
            state.blogReviewsToShow = state.blogReviews
        }
        
        return state
    }
}
