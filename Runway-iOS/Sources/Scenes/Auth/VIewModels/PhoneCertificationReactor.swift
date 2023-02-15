//
//  PhoneCertificationReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class PhoneCertificationReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case verificationNumberInput(String)
        case resendButtonDidTap
        case confirmButtonDidTap
    }
    
    enum Mutation {
        case setVerificationNumber(String)
//        case initializeTime
    }
    
    struct State{
        let phoneNumber: String
        var verificationNumber: String?
        var isRequestEnabled: Bool = false
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType, phoneNumber: String) {
        self.provider = provider
        self.initialState = State(phoneNumber: phoneNumber)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            sendMessage()
            return .empty()
        case .verificationNumberInput(let string):
            return .just(.setVerificationNumber(string))
        case .resendButtonDidTap:
            steps.accept(AppStep.toast("인증번호를 다시 보냈습니다."))
//            return .just(.initializeTime)
            return .empty()
        case .confirmButtonDidTap:
            checkVerification()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setVerificationNumber(let string):
            state.verificationNumber = limitedLengthString(string, length: 6)
        }
        state.isRequestEnabled = state.verificationNumber?.count == 6
        return state
    }
    
    private func limitedLengthString(_ str: String, length: Int) -> String { // limit
        if str.count > length {
            let index = str.index(str.startIndex, offsetBy: length)
            return String(str[..<index])
        } else {
            return str
        }
    }
    
    private func sendMessage() {
        provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber).subscribe(onNext: { [weak self] (response, data) in
            if 200...299 ~= response.statusCode {
                print("good")
            } else {
                print("error", data)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func checkVerification() {
        guard let verificationNumber = currentState.verificationNumber else { return }
        provider.signUpService.checkVerificationNumber(verificationNumber: verificationNumber,
                                                       phoneNumber: initialState.phoneNumber)
            .subscribe(onNext: { [weak self] (response, data) in
                if 200...299 ~= response.statusCode {
                    self?.steps.accept(AppStep.passwordInputRequired)
                } else {
                    print("error")
                }
            })
            .disposed(by: disposeBag)
    }
}
