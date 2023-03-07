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


final class HomeReactor: Reactor, Stepper {
    // MARK: - Events

    
    enum Action {
        case viewWillAppear
        case categorySelectButtonDidTap
        case userReviewCollectionViewReachesEnd
    }
    
    enum Mutation {
        case setPagerData([HomePagerResponseResult])
        case setUserReview(HomeReviewResponseResult)
        case appendUserReview(HomeReviewResponseResult)
        case setUserName(String)
    }
    
    struct State {
        var nickname: String? = nil
        var pagerData: [HomePagerResponseResult] = []
        
        var userReview: [HomeReviewResponseResultContent] = []
        var userReviewIsLast: Bool = false
        var userReviewPage: Int = 0
        
        
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
        case .viewWillAppear:
            return Observable.concat([
                provider.homeService.home(type: .home).data().decode(type: HomePagerResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setPagerData($0.result)
                },
                
                provider.homeService.review(page: 0, size: 10).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setUserReview($0.result)
                },
                
                provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setUserName($0.result.nickname)
                }
                
            ])
            
        case .categorySelectButtonDidTap:
            guard let nickname = currentState.nickname else { return .empty()}
            steps.accept(AppStep.categorySelect(nickname))
            return .empty()
            
        case .userReviewCollectionViewReachesEnd:
            return currentState.userReviewIsLast ? .empty() : provider.homeService.review(page: currentState.userReviewPage, size: 10).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map {
                return Mutation.appendUserReview($0.result)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPagerData(let results):
            state.pagerData = results
        case .setUserReview(let result):
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
        }
        
        return state
    }
}
