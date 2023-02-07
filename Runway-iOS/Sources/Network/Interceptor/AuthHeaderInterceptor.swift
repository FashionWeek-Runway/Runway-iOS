//
//  AuthInterceptor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Alamofire

class AuthHeaderInterceptor: HeaderInterceptor, AuthTokenHost {
    func intercept(header: APIService.Header) {
        if authToken != "" {
            header.add(name: "Authorization", value: authToken)
        }
    }
}
