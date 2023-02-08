//
//  AppleLoginRequestable.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import Foundation
import AuthenticationServices

protocol AppleLoginRequestable {
}

extension AppleLoginRequestable {
    func loginApple(success: ((String) -> Void)? = nil, failed: ((Error?) -> Void)? = nil, cancelled: (() -> Void)? = nil) {
        
        NetworkRepository.shared.appleLoginService.login(with: [.fullName, .email]) { (result, error) in
            guard let appleLoginResult = result,
                  let tokenData = appleLoginResult.identityToken,
                  let authorizationCode = appleLoginResult.authorizationCode else {
                
                return
            }
            
            let tokenString = String(data: tokenData, encoding: .utf8)
            let authCodeString = String(data: authorizationCode, encoding: .utf8)
            
            success?(tokenString ?? "")
        }
    }
}
