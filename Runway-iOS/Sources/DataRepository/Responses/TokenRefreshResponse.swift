//
//  TokenRefreshResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/11.
//

import Foundation

struct TokenRefreshResponse: Decodable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: TokenRefreshResult
}

struct TokenRefreshResult: Decodable {
    let accessToken: String
}
