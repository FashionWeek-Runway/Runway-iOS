//
//  HomePagerResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import Foundation

// MARK: - Welcome
struct HomePagerResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [HomePagerResponseResult]
}

// MARK: - Result
struct HomePagerResponseResult: Codable {
    let bookmark: Bool
    let imageURL: String
    let storeID: Int
    let storeName, regionInfo: String
    let categoryList: [String?]
    let bookmarkCount: Int

    enum CodingKeys: String, CodingKey {
        case bookmark
        case imageURL = "imgUrl"
        case storeID = "storeId"
        case storeName, regionInfo, categoryList
        case bookmarkCount = "bookmarkCnt"
    }
}
