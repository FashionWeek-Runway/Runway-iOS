//
//  NetworkRepository.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkRepository {
    static let shared = NetworkRepository()
    
    private init() {
        self.disposeBag = DisposeBag()
    }
    
    var disposeBag: DisposeBag
    
    // MARK: - Network Manager
    
    let networkManager: NetworkReachabilityManager? = {
        let manager = NetworkReachabilityManager(host: "https://www.google.com/")
        manager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .reachable(_):
                // TODO:
                break
            default:
                break
            }
        })
        return manager
    }()
    
    // MARK: - API Services
    
    lazy var loginService: LoginService = LoginService(baseURL: APIServiceURL.RUNWAY_BASEURL)
    
    lazy var appleLoginService: AppleService = AppleService.shared
}