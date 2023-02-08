//
//  KakaoLoginRequestable.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import Foundation
import RxSwift
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

protocol KakaoLoginRequestable {
}

extension KakaoLoginRequestable {
    func loginKakao() -> Observable<OAuthToken> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return UserApi.shared.rx.loginWithKakaoTalk()
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
        }
    }
    
//    func fetchKakaoUserInfo() -> Single<User> {
//        return UserApi.shared.rx.me()
//    }
//    
//    func logoutKakao() -> Completable {
//        return UserApi.shared.rx.logout()
//    }
//    
//    func unlink() -> Completable {
//        return UserApi.shared.rx.unlink()
//    }
}
