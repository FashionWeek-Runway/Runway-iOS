//
//  LoginService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class LoginService: APIService {
    
    func login(password: String, phone: String) -> Observable<(HTTPURLResponse, Data)>{
        
        var params = Parameters()
        params.updateValue(password, forKey: "password")
        params.updateValue(phone, forKey: "phone")
        
        return request(.get, "login", useAuthHeader:  false,parameters: params)
    }
    
    func loginAsKakao() -> Observable<(HTTPURLResponse, Data)> {
        
        var params = Parameters()
        params.updateValue(AppSettingService.shared.kakaoAccessToken, forKey: "accessToken")
        return request(.post, "login/kakao", useAuthHeader: false, parameters: params)
    }
}
