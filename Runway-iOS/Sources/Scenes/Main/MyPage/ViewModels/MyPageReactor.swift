//
//  MyPageReactor.swift
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


final class MyPageReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewWillAppear
        case settingButtonDidTap
        case profileImageButtonDidTap
        case myReviewCollectionViewReachesBottom
    }
    
    enum Mutation {
        case setProfileData(MyPageInformationResponseResult)
        case setMyReviewData(MyReviewResponseResult)
        case appendMyReviewData(MyReviewResponseResult)
    }
    
    struct State {
        var nickname: String? = nil
        var profileImageURL: String? = nil
        var myReviewDatas: [MyReviewResponseResultContent] = []
        
        var myReviewPage: Int = 0
        var myReviewIsLast: Bool = false
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
                
                provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder())
                    .map({ responseData -> Mutation in
                        return .setProfileData(responseData.result)
                    }),
                
                provider.userService.myReview(page: 0, size: 10).data().decode(type: MyReviewResponse.self, decoder: JSONDecoder())
                    .map({ responseData -> Mutation in
                        return .setMyReviewData(responseData.result)
                    })
            ])
            
        case .settingButtonDidTap:
            steps.accept(AppStep.setting)
            return .empty()
            
        case .profileImageButtonDidTap:
            steps.accept(AppStep.editProfile)
            return .empty()
            
        case .myReviewCollectionViewReachesBottom:
            return currentState.myReviewIsLast ? .empty() : provider.userService.myReview(page: currentState.myReviewPage, size: 10).data().decode(type: MyReviewResponse.self, decoder: JSONDecoder())
                .map({ responseData -> Mutation in
                    return .appendMyReviewData(responseData.result)
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setProfileData(let data):
            state.nickname = data.nickname
            state.profileImageURL = data.imageURL
            
        case.setMyReviewData(let data):
            state.myReviewDatas = data.contents
            state.myReviewIsLast = data.isLast
            if !data.isLast {
                state.myReviewPage += 1
            }
            
        case .appendMyReviewData(let data):
            state.myReviewDatas.append(contentsOf: data.contents)
            state.myReviewIsLast = data.isLast
            if !data.isLast {
                state.myReviewPage += 1
            }
        }
        
        return state
    }
}
