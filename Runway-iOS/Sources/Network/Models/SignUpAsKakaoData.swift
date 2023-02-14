//
//  SignUpAsKakao.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation
import Alamofire

struct SignUpAsKakaoData: Encodable {
    let categoryList: [String]
    let nickname: String
    let profileImageURL: String
    let socialID: String
    let type: String
}
