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
    
    private let eventLogger = APIEventLogger()
    private let authInterceptor =  AuthHeaderInterceptor()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(baseURL: String, isLogging: Bool = false, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.configuration = configuration
        
        self.session = Session(configuration: configuration, eventMonitors: isLogging ? [self.eventLogger] : [])
    }
    
    func request(_ method: HTTPMethod, _ url: String, useAuthHeader: Bool = true, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<(HTTPURLResponse, Data)> {
        
        var httpHeaders = HTTPHeaders()
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        if useAuthHeader {
            authInterceptor.intercept(headers: &httpHeaders)
        }
        
        return self.session.rx.responseData(method, url, parameters: parameters, encoding: encoding, headers: httpHeaders)
    }
}
