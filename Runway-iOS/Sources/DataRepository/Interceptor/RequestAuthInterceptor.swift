//
//  RequestAuthInterceptor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/11.
//

import Foundation
import Alamofire
import RxFlow

final class RequestAuthInterceptor: RequestInterceptor {
    /// API 호출 시 가로채서 urlRequest에 accessToken을 추가한 urlRequest로 다시 반환
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIServiceURL.RUNWAY_BASEURL) == true,
              AppSettingService.shared.authToken != "" else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(AppSettingService.shared.authToken, forHTTPHeaderField: "X-AUTH-TOKEN")
        completion(.success(urlRequest))
    }
    
    /// accessToken을 가지고 요청했을 때 401에러 발생 시, 토큰 리프레시
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, 400...499 ~= response.statusCode else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        DataRepository.shared.userService.refresh().data().decode(type: TokenRefreshResult.self, decoder: JSONDecoder()).subscribe(onNext: { result in
            AppSettingService.shared.authToken = result.accessToken
            completion(.retry)
        }, onError: { error in
            completion(.doNotRetryWithError(error))
        }).disposed(by: DataRepository.shared.disposeBag)
    }
}
