//
//  LoginRequestable.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift

protocol LoginRequestable {
    
}

extension LoginRequestable {
    
    func login(password: String, phone: String, success: @escaping (LoginResponse) -> Void, failure: @escaping (Error) -> Void) -> Disposable {
        return NetworkRepository.shared.loginService
            .login(password: password, phone: phone)
            .subscribe(onNext: { (response: HTTPURLResponse, data: Data) in
                do {
                    let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                    success(responseData)
                } catch {
                    failure(error)
                }
            }, onError: { (error: Error) in
                failure(error)
            })
    }
    
    func loginAsKakao(success: @escaping (LoginResponse) -> Void, failure: @escaping (Error) -> Void) -> Disposable {
        return NetworkRepository.shared.loginService
            .loginAsKakao()
            .subscribe(onNext: { (response: HTTPURLResponse, data: Data) in
                do {
                    let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                    success(responseData)
                } catch {
                    failure(error)
                }
            }, onError: { (error: Error) in
                failure(error)
            })
    }
}
