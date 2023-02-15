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

final class SignUpService: APIService {
    
    func signUpAsKakao(_ userData: SignUpAsKakaoData) -> Observable<UploadRequest> {
        
        var params = Parameters()
        params.updateValue(userData.categoryList, forKey: "categoryList")
        params.updateValue(userData.nickname, forKey: "nickname")
        params.updateValue("", forKey: "profileImgUrl")
        params.updateValue(userData.socialID, forKey: "socialId")
        params.updateValue(userData.type, forKey: "type")
        
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "*/*"]

        return self.session.rx.upload(multipartFormData: { data in
            for (key, value) in params {
                data.append("\(value)".data(using: .utf8)!, withName: key)
            }
            data.append(userData.profileImageData,
                        withName: "multipartFile",
                        fileName: userData.nickname + ".png",
                        mimeType: "image/png")
        }, to: baseURL + "login/signup/kakao", method: .post, headers: headers)
    }
    
    func signUpAsPhone(userData: SignUpAsPhoneData) -> Observable<(UploadRequest)> {
        var params = Parameters()
        params.updateValue(userData.categoryList, forKey: "categoryList")
        params.updateValue(userData.gender, forKey: "gender")
        params.updateValue(userData.name, forKey: "name")
        params.updateValue(userData.nickname, forKey: "nickname")
        params.updateValue(userData.phoneNumber, forKey: "phone")
        params.updateValue(userData.password, forKey: "password")
        
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "*/*"]
        
        return self.session.rx.upload(multipartFormData: { data in
            for (key, value) in params {
                data.append("\(value)".data(using: .utf8)!, withName: key)
            }
            data.append(userData.profileImageData,
                        withName: "multipartFile",
                        fileName: userData.nickname + ".png",
                        mimeType: "image/png")
        }, to: baseURL + "login/signup", method: .post, headers: headers)
    }
    
    func checkVerificationNumber(verificationNumber: String, phoneNumber: String) -> Observable<(HTTPURLResponse, Data)> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "to")
        params.updateValue(verificationNumber, forKey: "confirmNum")
        
        return request(.post, "login/check", useAuthHeader: false, parameters: params)
    }
    
    func checkNicknameDuplicate(nickname: String) -> Observable<(HTTPURLResponse, Data)> {
        var params = Parameters()
        params.updateValue(nickname, forKey: "nickname")
        
        return request(.get, "login/check/nickname", useAuthHeader: false, parameters: params, encoding: URLEncoding.default)
    }
    
    func checkPhoneNumberDuplicate(phoneNumber: String) -> Observable<(HTTPURLResponse, Data)> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "phone")
        
        return request(.get, "login/check/phone", useAuthHeader: false, parameters: params, encoding: URLEncoding.default)
    }
    
    func setUserPassword(phoneNumber: String, password: String) -> Observable<(HTTPURLResponse, Data)> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "phone")
        params.updateValue(password, forKey: "password")
        
        return request(.post, "login/phone", useAuthHeader: false, parameters: params)
    }
    
    func sendVerificationMessage(phoneNumber: String) -> Observable<(HTTPURLResponse, Data)> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "to")
        
        return request(.post, "login/send", useAuthHeader: false, parameters: params)
    }
}
