//
//  ShowRoomService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class ShowRoomService: APIService, AuthTokenHost {
    
    private let authHeaderInterceptor =  AuthHeaderInterceptor()
    
    func stores() -> Observable<DataRequest> {
        return request(.get, "stores")
    }
    
    func storeBookmark(storeId: Int) -> Observable<DataRequest> {
        return request(.post, "stores/\(storeId)")
    }
    
    func storeBlogs(storeId: Int, storeName: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(storeName, forKey: "storeName")
        return request(.get, "stores/blog/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeBoards(storeId: Int, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "stores/board/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeDetail(storeId: Int) -> Observable<DataRequest> {
        return request(.get, "stores/detail/\(storeId)")
    }
    
    func storeReview(storeId: Int, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "stores/review/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeReview(storeId: Int, imageData: Data) -> Observable<DataRequest> {
        let imageDataString = String(decoding: imageData, as: UTF8.self)
        
        return request(.post, "stores/review/\(storeId)", parameters: [:] , encoding: BodyStringEncoding(body: imageDataString))
    }
}
