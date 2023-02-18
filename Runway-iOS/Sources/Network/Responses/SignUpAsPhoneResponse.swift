//
//  SignUpAsPhoneResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/19.
//

import Foundation

// MARK: - Welcome
struct SignUpAsPhoneResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: SignUpAsPhoneResponseResult
}

// MARK: - Result
struct SignUpAsPhoneResponseResult: Codable {
    let accessToken, categoryList, imgURL, nickname: String
    let refreshToken: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case accessToken, categoryList
        case imgURL = "imgUrl"
        case nickname, refreshToken
        case userID = "userId"
    }
}
