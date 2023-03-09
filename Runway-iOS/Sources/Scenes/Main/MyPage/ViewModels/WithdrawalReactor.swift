//
//  WithdrawalReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class WithdrawalReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case agreeCheckBoxDidTap
    }
    
    enum Mutation {
        case setNickname(String)
        case toggleAgree
    }
    
    struct State {
        var nickname = ""
        var isAgree = false
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
            return provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder())
                .map { .setNickname($0.result.nickname) }
            return .empty()
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .agreeCheckBoxDidTap:
            return .just(.toggleAgree)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNickname(let nickname):
            state.nickname = nickname
            
        case .toggleAgree:
            state.isAgree.toggle()
        }
        
        return state
    }
}
