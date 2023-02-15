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
}
