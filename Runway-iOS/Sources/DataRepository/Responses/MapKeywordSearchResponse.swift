//
//  MapKeywordSearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/28.
//

import Foundation


// MARK: - MapKeywordSearchResponse
struct MapKeywordSearchResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: MapKeywordSearchResponseResult
}

// MARK: - Result
struct MapKeywordSearchResponseResult: Codable {
    let regionSearchList: [KeywordSearchItem]
    let storeSearchList: [KeywordSearchItem]
}

struct KeywordSearchItem: Codable {
    let address: String
    let region, storeName: String?
    let regionID, storeID: Int?
    let distance: Double?
    
    enum CodingKeys: String, CodingKey {
        case address, region, storeName, distance
        case regionID = "regionId"
        case storeID = "storeId"
    }
}

extension KeywordSearchItem: Equatable {
    static func == (lhs: KeywordSearchItem, rhs: KeywordSearchItem) -> Bool {
        return lhs.address == rhs.address &&
        lhs.region == rhs.region &&
        lhs.storeName == rhs.storeName &&
        lhs.regionID == rhs.regionID &&
        lhs.storeID == rhs.storeID &&
        lhs.distance == rhs.distance
    }
}

//// MARK: - RegionSearchList
//struct RegionSearchList: Codable {
//    let address, region: String
//    let regionID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case address, region
//        case regionID = "regionId"
//    }
//}
//
//// MARK: - StoreSearchList
//struct StoreSearchList: Codable {
//    let address: String
//    let distance, storeID: Int
//    let storeName: String
//
//    enum CodingKeys: String, CodingKey {
//        case address, distance
//        case storeID = "storeId"
//        case storeName
//    }
//}
