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

import RxRelay

final class SignUpService: APIService {
    
    var signUpAsKakaoData: SignUpAsKakaoData? = SignUpAsKakaoData()
    var signUpAsPhoneData: SignUpAsPhoneData? = SignUpAsPhoneData()
    
    func removeAllSignUpDatas() {
        signUpAsPhoneData = nil
        signUpAsPhoneData = SignUpAsPhoneData()
        
        signUpAsKakaoData = nil
        signUpAsKakaoData = SignUpAsKakaoData()
        
        // TODO: - apple
    }
    
    func signUpAsKakao() -> Observable<UploadRequest> {
        
        guard let categoryList = signUpAsKakaoData?.categoryList,
              let nickname = signUpAsKakaoData?.nickname,
              let socialID = signUpAsKakaoData?.socialID,
              let type = signUpAsKakaoData?.type,
              let imageData = signUpAsKakaoData?.profileImageData else { return .error(RequestError.requestFieldIsNil) }

        var params = Parameters()
        params.updateValue(categoryList.map { String($0) }.joined(separator: ","), forKey: "categoryList")
        params.updateValue(nickname, forKey: "nickname")
        params.updateValue("", forKey: "profileImgUrl")
        params.updateValue(socialID, forKey: "socialId")
        params.updateValue(type, forKey: "type")

        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "*/*"]

        return self.session.rx.upload(multipartFormData: { data in
            for (key, value) in params {
                data.append("\(value)".data(using: .utf8)!, withName: key)
            }
            data.append(imageData,
                        withName: "multipartFile",
                        fileName: nickname + ".png",
                        mimeType: "image/png")
        }, to: baseURL + "login/signup/kakao", method: .post, headers: headers)
    }

    func signUpAsPhone() -> Observable<UploadRequest> {
        
        guard let categoryList = signUpAsPhoneData?.categoryList,
              let gender = signUpAsPhoneData?.gender,
              let name = signUpAsPhoneData?.name,
              let nickname = signUpAsPhoneData?.nickname,
              let phoneNumber = signUpAsPhoneData?.phone,
              let password = signUpAsPhoneData?.password,
              let imageData = signUpAsPhoneData?.profileImageData
                
        else { return .error(RequestError.requestFieldIsNil) }

        var params = Parameters()
        let categori = categoryList.map { String($0) }.joined(separator: ",")
        params.updateValue(categori, forKey: "categoryList")
        params.updateValue(gender, forKey: "gender")
        params.updateValue(name, forKey: "name")
        params.updateValue(nickname, forKey: "nickname")
        params.updateValue(phoneNumber, forKey: "phone")
        params.updateValue(password, forKey: "password")

        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "*/*"]

        return self.session.rx.upload(multipartFormData: { data in
            for (key, value) in params {
                data.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            data.append(UIImage(data: imageData)!.jpegData(compressionQuality: 0.5)!,
                        withName: "multipartFile",
                        fileName: nickname + ".jpg",
                        mimeType: "image/jpg")
        }, to: baseURL + "login/signup", method: .post, headers: headers)
    }
    
    func checkVerificationNumber(verificationNumber: String, phoneNumber: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "to")
        params.updateValue(verificationNumber, forKey: "confirmNum")
        
        return request(.post, "login/check", useAuthHeader: false, parameters: params)
    }
    
    func checkNicknameDuplicate(nickname: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(nickname, forKey: "nickname")
        
        return request(.get, "login/check/nickname", useAuthHeader: false, parameters: params, encoding: URLEncoding.default)
    }
    
    func checkPhoneNumberDuplicate(phoneNumber: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "phone")
        
        return request(.get, "login/check/phone", useAuthHeader: false, parameters: params, encoding: URLEncoding.default)
    }
    
    func setUserPassword(phoneNumber: String, password: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "phone")
        params.updateValue(password, forKey: "password")
        
        return request(.post, "login/phone", useAuthHeader: false, parameters: params)
    }
    
    func sendVerificationMessage(phoneNumber: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(phoneNumber, forKey: "to")
        
        return request(.post, "login/send", useAuthHeader: false, parameters: params)
    }
}
