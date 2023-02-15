//
//  ForgotPasswordReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ForgotPasswordReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {

    }
    
    enum Mutation {
        
    }
    
    struct State{
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

    }
    
}
