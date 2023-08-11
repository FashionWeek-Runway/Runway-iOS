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
    let configuration: URLSessionConfiguration
    let session: Session
    let requestInterceptor = RequestAuthInterceptor()
    let eventLogger = APIEventLogger()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(baseURL: String, isLogging: Bool = false, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.configuration = configuration
        
        self.session = Session(configuration: configuration, interceptor: requestInterceptor, eventMonitors: isLogging ? [self.eventLogger] : [])
    }
    
    func request(_ method: HTTPMethod, _ url: String, useAuthHeader: Bool = true, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String: String]? = nil) -> Observable<DataRequest> {
        
        var httpHeaders = HTTPHeaders()
        httpHeaders.add(name: "Content-Type", value: "application/json")
        httpHeaders.add(name: "accept", value: "*/*")
        if let headers = headers {
            for (key, value) in headers {
                httpHeaders.update(name: key, value: value)
            }
        }
        
        return self.session.rx.request(method, baseURL + url, parameters: parameters, encoding: encoding, headers: httpHeaders)
    }
}
