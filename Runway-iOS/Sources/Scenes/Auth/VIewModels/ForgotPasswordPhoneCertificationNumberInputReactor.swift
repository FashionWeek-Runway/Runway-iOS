//
//  ForgotPasswordPhoneCertificationNumberInputReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ForgotPasswordPhoneCertificationNumberInputReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case verificationNumberInput(String)
        case resendButtonDidTap
        case confirmButtonDidTap
        
        
        case setTimer(String)
    }
    
    enum Mutation {
        case setVerificationNumber(String)
        case setInvalidCertificationNumber
        case setTimerText(String)
    }
    
    struct State{
        let phoneNumber: String
        var verificationNumber: String?
        var isRequestEnabled: Bool = false
        
        var invalidCertification = true
        
        var timerText: String? = nil
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private var timeSecond = 0
    private var timerText = ""
    var timer: Timer?
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType, phoneNumber: String) {
        self.provider = provider
        self.initialState = State(phoneNumber: phoneNumber)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            startTimer(initialSecond: 180)
            provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber).responseData()
                .subscribe(onNext: { (response, data) in
                    print(response)
                })
                .disposed(by: disposeBag)
            return .empty()
        case .setTimer(let string):
            return .just(.setTimerText(string))
        case .backButtonDidTap:
            steps.accept(AppStep.back)
            return .empty()
        case .verificationNumberInput(let string):
            return .just(.setVerificationNumber(string))
        case .resendButtonDidTap:
            steps.accept(AppStep.toast("인증번호를 다시 보냈습니다."))
            //            return .just(.initializeTime)
            return .empty()
        case .confirmButtonDidTap:
            guard let verificationNumber = currentState.verificationNumber else { return .empty() }
            provider.signUpService.checkVerificationNumber(verificationNumber: verificationNumber,
                                                           phoneNumber: initialState.phoneNumber)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setVerificationNumber(let string):
            state.verificationNumber = String.limitedLengthString(string, length: 6)
        case .setInvalidCertificationNumber:
            state.invalidCertification = true
        case .setTimerText(let timerText):
            state.timerText = timerText
        }
        state.isRequestEnabled = state.verificationNumber?.count == 6
        return state
    }
    
    private func startTimer(initialSecond: Int) {
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
        }
        timeSecond = initialSecond
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callBackTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func callBackTimer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        guard let timeString = formatter.string(from: TimeInterval(timeSecond)) else { return }
        action.onNext(.setTimer(timeString))
        
        if timeSecond == 0 {
            timer?.invalidate()
            timer = nil
        } else {
            timeSecond -= 1
        }
    }
}

