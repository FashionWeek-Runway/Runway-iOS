//
//  SignUpService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import Alamofire
import RxAlamofire

final class SignInService: APIService {
    
    func signUpAsKakao(_ userData: SignUpAsKakaoData) -> Observable<(HTTPURLResponse, Data)> {
        
        var params = Parameters()
        params.updateValue(userData.categoryList, forKey: "categoryList")
        params.updateValue(userData, forKey: "multipartFile")
        params.updateValue(userData.nickname, forKey: "nickname")
        params.updateValue(userData.profileImageURL, forKey: "profileImgUrl")
        params.updateValue(userData.socialID, forKey: "socialId")
        params.updateValue(userData.type, forKey: "type")
        
        return request(.post, "login/signup/kakao", parameters: params)
    }
}
