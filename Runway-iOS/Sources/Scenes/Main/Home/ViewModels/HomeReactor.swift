//
//  HomeReactor.swift
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
import RealmSwift


final class HomeReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case categorySelectButtonDidTap
        case showAllContentButtonDidTap
        case pagerBookmarkButtonDidTap(Int)
        case pagerCellDidTap(Int)
        case userReviewCollectionViewReachesEnd
        case userReviewCellDidTap(Int)
        case instagramCollectionViewReachesEnd
        
        case instagramCellDidTap(Int)
    }
    
    enum Mutation {
        case setPagerData([HomeStoreResponseResult])
        case setUserReview(HomeReviewResponseResult)
        case appendUserReview(HomeReviewResponseResult)
        case setUserName(String)
        case setInstagramFeed(InstagramResponseResult)
        case appendInstagramFeed(InstagramResponseResult)
    }
    
    struct State {
        var nickname: String? = nil
        @Pulse var pagerData: [HomeStoreResponseResult] = []
        
        @Pulse var userReview: [HomeReviewResponseResultContent] = []
        var userReviewIsLast: Bool = false
        var userReviewPage: Int = 0
        
        @Pulse var instagramFeed: [InstaFeed] = []
        var instagramFeedIsLast: Bool = false
        var instagramFeedPage: Int = 0
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return provider.homeService.popUp().data().decode(type: PopUpResponse.self, decoder: JSONDecoder())
                .flatMap { [weak self] response -> Observable<Mutation> in
                    let realm = self?.provider.realm
                    let histories = realm?.objects(PopUpHistory.self).sorted(byKeyPath: "date", ascending: false)
                    var historyContainer = [PopUpHistory]()
                    histories?.forEach {
                        historyContainer.append($0)
                    }
                    
                    if historyContainer.first(where: { $0.popUpId == response.result.first?.popUpID && $0.userId == response.result.first?.userID}) == nil {
                        try! realm?.write {
                            let history = PopUpHistory()
                            history.popUpId = response.result.first!.popUpID
                            history.userId = response.result.first!.userID
                            realm?.create(PopUpHistory.self, value: history)
                        }
                        if let imageURL = URL(string: response.result.first!.imageURL) {
                            self?.steps.accept(AppStep.popUp(imageURL: imageURL))
                        }
                    }
                    return .empty()
                }
            
        case .viewWillAppear:
            return Observable.concat([
                provider.homeService.home(type: .home).data().decode(type: HomeStoreResponse.self, decoder: JSONDecoder()).map {
                    Mutation.setPagerData($0.result)
                },
                provider.homeService.review(page: 0, size: 30).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map {
                    Mutation.setUserReview($0.result)
                },
                provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder()).map {
                    Mutation.setUserName($0.result.nickname)
                },
                
                provider.homeService.instagram(page: 0, size: 30).data().decode(type: InstagramResponse.self, decoder: JSONDecoder()).map {
                    Mutation.setInstagramFeed($0.result)
                }
            ])
            
        case .showAllContentButtonDidTap:
            steps.accept(AppStep.showAllStore)
            return .empty()
            
        case .pagerBookmarkButtonDidTap(let storeId):
            return provider.showRoomService.storeBookmark(storeId: storeId)
                .flatMap { response -> Observable<Mutation> in
                    return .empty()
                }
            
        case .pagerCellDidTap(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .categorySelectButtonDidTap:
            guard let nickname = currentState.nickname else { return .empty()}
            steps.accept(AppStep.categorySelect(nickname))
            return .empty()
            
        case .userReviewCollectionViewReachesEnd:
            return currentState.userReviewIsLast
            ? .empty()
            : provider.homeService.review(page: currentState.userReviewPage, size: 10).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map { Mutation.appendUserReview($0.result) }
            
        case .userReviewCellDidTap(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .home))
            return .empty()
            
        case .instagramCollectionViewReachesEnd:
            return currentState.instagramFeedIsLast
            ? .empty()
            : provider.homeService.instagram(page: currentState.instagramFeedPage, size: 10).data().decode(type: InstagramResponse.self, decoder: JSONDecoder()).map { Mutation.appendInstagramFeed($0.result) }
            
        case .instagramCellDidTap(let itemIndex):
            guard let url = URL(string: currentState.instagramFeed[itemIndex].instagramLink) else { return .empty()}
            steps.accept(AppStep.open(url: url))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPagerData(let results):
            state.pagerData = results + [HomeStoreResponseResult(isBookmarked: false,
                                                                 imageURL: "",
                                                                 storeID: 0,
                                                                 storeName: "",
                                                                 regionInfo: "",
                                                                 categoryList: [],
                                                                 bookmarkCount: 0,
                                                                 cellType: .showMoreShop)]
        case .setUserReview(let result):
            state.userReviewPage = 0
            state.userReview = result.contents
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
        case .appendUserReview(let result):
            state.userReview.append(contentsOf: result.contents)
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setUserName(let username):
            state.nickname = username
            
        case .setInstagramFeed(let result):
            state.instagramFeedPage = 0
            state.instagramFeedIsLast = result.isLast
            state.instagramFeed = result.contents
            
        case .appendInstagramFeed(let result):
            state.instagramFeed.append(contentsOf: result.contents)
            state.instagramFeedIsLast = result.isLast
            if !result.isLast {
                state.instagramFeedPage += 1
            }
        }
        
        return state
    }
}
