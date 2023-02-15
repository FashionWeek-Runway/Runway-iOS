//
//  IdentityVerificationReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class IdentityVerificationReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
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
        switch action {
        case .viewDidLoad:
            let alertTitle = "만 14세 이상인가요?"
            let description = "RUNWAY는 만 14세 이상 사용 가능합니다.\n해당 데이터는 저장되지 않으며,\n만 14세 이상임을 증명하는데만 사용됩니다."
            let option1 = "네, 만 14세 이상입니다"
            let option2 = "아니요, 만 14세이하입니다"
            steps.accept(AppStep.alert(alertTitle, description, [option1, option2]) { [weak self] action in
                switch action.title {
                case option1:
                    self?.steps.accept(AppStep.dismiss)
                case option2:
                    let title = "만 14세 이상 사용 가능합니다"
                    let desc = "죄송합니다. RUNWAY는 만 14세 이상 사용\n가능합니다. 우리 나중에 다시 만나요:)"
                    let action = "안녕, 또 만나요!"
                    self?.steps.accept(AppStep.alert(title, desc, [action], { _ in
                        self?.steps.accept(AppStep.dismiss)
                        self?.steps.accept(AppStep.loginRequired)
                    }))
                default:
                    break
                }
            })
            return .empty()
        }
    }
    
}
