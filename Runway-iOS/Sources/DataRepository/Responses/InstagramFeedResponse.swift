//
//  InstagramFeedResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/20.
//

import Foundation

struct InstagramResponse: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: InstagramResponseResult
}

struct InstagramResponseResult: Decodable {
    let contents: [InstaFeed]
    let isLast: Bool
}

struct InstaFeed: Decodable {
    let feedId: Int
    let imgList: [String]
    let instagramLink: String
    let storeName: String
    
    enum CodingKeys: String, CodingKey {
        case feedId
        case imgList
        case instagramLink = "instaLink"
        case storeName
    }
}
