//
//  UserService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class UserService: APIService {
    
    func setUserLocation(latitude: Float, longitude: Float) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(latitude, forKey: "latitude")
        params.updateValue(longitude, forKey: "longitude")
        return request(.post, "users/location", parameters: params)
    }
    
    func logout() -> Observable<DataRequest> {
        return request(.get, "users/logout")
    }
    
    func refresh() -> Observable<DataRequest> {
        return request(.post, "users/refresh")
    }
    
}
