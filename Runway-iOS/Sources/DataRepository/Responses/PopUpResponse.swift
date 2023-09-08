//
//  PopUpResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/08.
//

struct PopUpResponse: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: [PopUpResult]
}

struct PopUpResult: Decodable {
    let imageURL: String
    let popUpID: Int
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imgUrl"
        case popUpID = "popUpId"
        case userID = "userId"
    }
}
