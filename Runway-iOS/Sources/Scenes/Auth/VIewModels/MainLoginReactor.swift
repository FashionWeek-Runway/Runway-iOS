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

final class MainLoginReactor: Reactor, Stepper {
    // MARK: - Events
    
    struct State {
    }
    
    enum Action {
        case kakaoLoginButtonDidTap
        case appleLoginButtonDidTap
        case phoneLoginButtonDidTap
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
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe { [weak self] event in
                        guard let self = self else { return }
                        switch event {
                        case .next(let oauthToken):
                            self.provider.appSettingService.kakaoAccessToken = oauthToken.accessToken
                            self.loginKakao()
                        case .error(let error):
                            print(error)
                        case .completed:
                            break
                        }
                    }.disposed(by: disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe { event in
                        switch event {
                        case .next(let oauthToken):
                            self.provider.appSettingService.kakaoAccessToken = oauthToken.accessToken
                            self.loginKakao()
                        case .error(let error):
                            print(error)
                        case .completed:
                            break
                        }
                    }.disposed(by: disposeBag)
            }
            return .just(.setKakaoLogin)
        case .appleLoginButtonDidTap:
            return .just(.setAppleLogin)
        case .phoneLoginButtonDidTap:
            steps.accept(AppStep.phoneNumberLogin)
            return .just(.setPhoneLogin)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
    
    private func loginKakao() {
        self.provider.loginService.loginAsKakao()
            .subscribe { (response, data) in
                if response.statusCode == 404 { // 가입 필요
                    do {
                        let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                        self.steps.accept(AppStep.profileSettingIsRequired(profileImageURL: responseData.result.profileImageURL, kakaoID: responseData.result.kakaoID))
                    } catch {
                        print(error)
                    }
                } else if response.statusCode == 403 { // 카카오 서버 에러
                    print("kakao에러")
                } else { // 로그인 완료
                    print(response ,data)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
