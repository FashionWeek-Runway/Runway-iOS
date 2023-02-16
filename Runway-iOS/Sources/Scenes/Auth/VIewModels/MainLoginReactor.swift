//
//  MainLoginReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import Foundation

import ReactorKit
import RxFlow
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import Alamofire

enum LoginError: Error {
    case notRegistered
    case serverError
}

final class MainLoginReactor: Reactor, Stepper {
    // MARK: - Events
    
    struct State {
    }
    
    enum Action {
        case kakaoLoginButtonDidTap
        case appleLoginButtonDidTap
        case phoneLoginButtonDidTap
        
        case requestkakaoLogin
        case requestAppleLogin
    }
    
    enum Mutation {
        case setKakaoLogin
        case setAppleLogin
        case setPhoneLogin
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
        case .kakaoLoginButtonDidTap:
            if UserApi.isKakaoTalkLoginAvailable() {
                return UserApi.shared.rx.loginWithKakaoTalk()
                    .flatMap { [weak self] token -> Observable<Mutation> in
                        self?.provider.appSettingService.kakaoAccessToken = token.accessToken
                        self?.loginKakao()
                        return .empty()
                    }
            }
            else {
                return UserApi.shared.rx.loginWithKakaoAccount()
                    .flatMap { [weak self] token -> Observable<Mutation> in
                        self?.provider.appSettingService.kakaoAccessToken = token.accessToken
                        self?.loginKakao()
                        return .empty()
                    }
            }
        case .appleLoginButtonDidTap:
            return .just(.setAppleLogin)
        case .phoneLoginButtonDidTap:
            steps.accept(AppStep.phoneNumberLogin)
            return .just(.setPhoneLogin)
        case .requestkakaoLogin:
            return .empty()
        case .requestAppleLogin:
            // TODO: -
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
    
    private func loginKakao() {
        return provider.loginService.loginAsKakao()
            .responseData()
            .subscribe(onNext: { (response, data) in
                if response.statusCode == 400 {
                    do {
                        let responseData = try JSONDecoder().decode(LoginAsKakaoResponse.self, from: data)
                        self.steps.accept(AppStep.profileSettingIsRequired(profileImageURL: responseData.result.profileImageURL,
                                                                           kakaoID: responseData.result.kakaoID))
                    } catch {
                        print(error)
                    }
                } else {
                    print(data)
                }
            }).disposed(by: disposeBag)
    }
}
