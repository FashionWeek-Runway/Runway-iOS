//
//  SignUpAsPhoneData.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

struct SignUpAsPhoneData: Encodable {
    let categoryList: [String]
    let gender: [String]
    let profileImageData: Data
    let nickname: String
    let name: String
    let password: String
    let phoneNumber: String
}
