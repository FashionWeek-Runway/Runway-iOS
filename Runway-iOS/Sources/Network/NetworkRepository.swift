//
//  NetworkRepository.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift
import Alamofire

protocol ServiceProviderType {
    var appSettingService: AppSettingService { get }
    var networkManager: NetworkReachabilityManager? { get }
    var loginService: LoginService { get }
    var signUpService: SignUpService { get }
    var appleLoginService: AppleService { get }
}

final class NetworkRepository: ServiceProviderType {
    static let shared = NetworkRepository()
    
    private init() {
        self.disposeBag = DisposeBag()
    }
    
    var disposeBag: DisposeBag
    
    // MARK: - App Setting Service (UserDefaults Value)
    
    lazy var appSettingService: AppSettingService = AppSettingService.shared
    
    // MARK: - Network Manager
    
    lazy var networkManager: NetworkReachabilityManager? = {
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
    
    lazy var loginService: LoginService = LoginService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var signUpService: SignUpService = SignUpService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var appleLoginService: AppleService = AppleService.shared
}
