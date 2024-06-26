//
//  HomeService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/06.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

enum HomeEndpointType: Int {
    case home = 0
    case all = 1
}

protocol HomeServiceProtocol {
    func home(type: HomeEndpointType) -> Observable<DataRequest>
    func categories() -> Observable<DataRequest>
    func categorySelect(categories: [Int]) -> Observable<DataRequest>
    func review(page: Int, size: Int) -> Observable<DataRequest>
    func reviewDetail(reviewId: Int) -> Observable<DataRequest>
    func instagram(page: Int, size: Int) -> Observable<DataRequest>
}

final class HomeService: APIService, HomeServiceProtocol {
    
    func home(type: HomeEndpointType) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(type.rawValue, forKey: "type")
        
        return request(.get, "home", parameters: params, encoding: URLEncoding.default)
    }
    
    func categories() -> Observable<DataRequest> {
        return request(.get, "home/categories")
    }
    
    func categorySelect(categories: [Int]) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(categories, forKey: "categoryList")
        
        return request(.patch, "home/categories", parameters: params)
    }
    
    func review(page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "home/review", parameters: params, encoding: URLEncoding.default)
    }
    
    func reviewDetail(reviewId: Int) -> Observable<DataRequest> {
        return request(.get, "home/review/detail/\(reviewId)")
    }
    
    func instagram(page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "home/insta", parameters: params, encoding: URLEncoding.default)
    }
    
    func popUp() -> Observable<DataRequest> {
        return request(.get, "home/pop-up", encoding: URLEncoding.default)
    }
}
