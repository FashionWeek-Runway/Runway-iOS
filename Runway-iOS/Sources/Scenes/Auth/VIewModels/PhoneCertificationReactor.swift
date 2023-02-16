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
        case backButtonDidTap
        case verificationNumberInput(String)
        case resendButtonDidTap
        case confirmButtonDidTap
    }
    
    enum Mutation {
        case setVerificationNumber(String)
        case setInvalidCertificationNumber
    }
    
    struct State{
        let phoneNumber: String
        var verificationNumber: String?
        var isRequestEnabled: Bool = false
        
        var invalidCertification = true
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
            provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber)
                .validate(statusCode: 200...299)
            return .empty()
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
            guard let number = currentState.verificationNumber else { return .empty() }
            provider.signUpService.checkVerificationNumber(verificationNumber: number,
                                                           phoneNumber: initialState.phoneNumber).validate(statusCode: 200...299).data()
            .map { [weak self] request in
                self?.steps.accept(AppStep.passwordInputRequired)
            }.catch { error in
                print(error)
                return .empty()
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setVerificationNumber(let string):
            state.verificationNumber = limitedLengthString(string, length: 6)
        case .setInvalidCertificationNumber:
            state.invalidCertification = true
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
}

