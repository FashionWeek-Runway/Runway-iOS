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
        case backButtonDidTap
        case enterPhoneNumber(String)
        case enterPassword(String)
        case forgotPasswordButtonDidTap
        case loginButtonDidTap
        case signUpButtonDidTap
    }
    
    enum Mutation {
        case setPhoneNumber(String)
        case setPassword(String)
        case setAccoutNotExist
        
        case setUserLogIn
    }
    
    struct State{
        var isLoginEnable: Bool = false
        
        var password: String? = nil
        var phoneNumber: String? = nil
        
        var shouldAlertAccountNotExist = false
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
        case .backButtonDidTap:
            steps.accept(AppStep.back)
            return .empty()
        case .forgotPasswordButtonDidTap:
            steps.accept(AppStep.forgotPassword)
            return .empty()
        case .loginButtonDidTap:
            guard let password = currentState.password,
                  let phoneNumber = currentState.phoneNumber else { return .empty() }
            
            return provider.loginService.login(password: password, phone: phoneNumber).validate(statusCode: 200...299).data().map { [weak self] data in
                do {
                    let responseData = try JSONDecoder().decode(LoginResponse.self, from: data) as LoginResponse
                    self?.provider.appSettingService.isLoggedIn = true
                    self?.provider.appSettingService.authToken = responseData.result.accessToken
                    self?.provider.appSettingService.refreshToken = responseData.result.refreshToken
                    
                    self?.steps.accept(AppStep.userIsLoggedIn)
                    return .setUserLogIn
                } catch {
                    print(error)
                    return .setUserLogIn
                }
            } .catch { error in
                return .just(.setAccoutNotExist)
            }
        case .signUpButtonDidTap:
            steps.accept(AppStep.identityVerificationIsRequired)
            return .empty()
        case .enterPhoneNumber(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
        case .enterPassword(let password):
            return .just(.setPassword(password))
        }
    }
    

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.shouldAlertAccountNotExist = false
        switch mutation {
        case .setPassword(let password):
            state.password = password
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = String.limitedLengthString(phoneNumber, length: 11)
        case .setAccoutNotExist:
            state.shouldAlertAccountNotExist = true
        default:
            break
        }
        if let phoneNumber = state.phoneNumber, let password = state.password {
            if phoneNumber.count > 8 && password.count > 0 {
                state.isLoginEnable = true
            } else {
                state.isLoginEnable = false
            }
        } else {
            state.isLoginEnable = false
        }
        return state
    }
    
}
