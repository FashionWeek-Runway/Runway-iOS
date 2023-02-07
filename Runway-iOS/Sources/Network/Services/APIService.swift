//
//  APIService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

public class APIService {
    
    let baseURL: String
    let useAuthHeader: Bool
    let externalService: Bool
    
    private let session: Session
    
    init(baseURL: String, useAuthHeader: Bool = true, externalService: Bool = false, session: Session = .default) {
        self.baseURL = baseURL
        self.useAuthHeader = useAuthHeader
        self.externalService = externalService
        self.session = session
    }
    
    func request(_ method: HTTPMethod, _ url: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<(HTTPURLResponse, Data)> {
        
        if useAuthHeader {
            AuthHeaderInterceptor.intercept(headers)
        }
        
        return RxAlamofire.requestData(method, url, parameters: parameters, encoding: encoding, headers: <#T##HTTPHeaders?#>)
    }
    
    class Header {
        var headers: [String: String]? = nil
        
        private init() {
            headers = [String: String]()
        }
        
        static func Builder(_ headerParams: [String: String]? = nil) -> Header {
            let header = Header()
            if let hp = headerParams {
                for (key, value) in hp {
                    header.add(name: key, value: value)
                }
            }
            return header
        }
        
        func add(name: String, value: String) {
            headers?[name] = value
        }
        
        
        func build() -> [String:String]? {
            return headers
        }
    }
}
