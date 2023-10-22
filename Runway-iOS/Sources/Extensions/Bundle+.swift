//
//  Bundle+.swift
//  Runway-iOS
//
//  Created by 김인환 on 10/23/23.
//

import Foundation

extension Bundle {
    var nmfClientId: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: file),
                let clientId = dict["NMFClientId"] as? String else {
                return nil
            }

        return clientId
    }

    var kakaoAPIKey: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: file),
                let key = dict["KakaoAPIKey"] as? String else {
                return nil
            }

        return key
    }
}
