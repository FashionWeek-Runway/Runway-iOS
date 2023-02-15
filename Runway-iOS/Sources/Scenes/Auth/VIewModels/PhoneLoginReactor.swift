//
//  PhoneLoginReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class PhoneLoginReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case forgotPasswordButtonDidTap
        case loginButtonDidTap
        case signUpButtonDidTap
    }
    
    enum Mutation {
        
    }
    
    struct State{
        var isLoginEnable: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .forgotPasswordButtonDidTap:
            steps.accept(AppStep.forgotPassword)
        case .loginButtonDidTap:
            break
//            steps.accept(AppStep.l)
        case .signUpButtonDidTap:
            break
        }
        return .empty()
    }
    
}
