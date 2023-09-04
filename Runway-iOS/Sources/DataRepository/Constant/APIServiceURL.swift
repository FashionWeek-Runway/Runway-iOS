//
//  APIServiceURL.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation

class APIServiceURL {
    #if RELEASE
    static let RUNWAY_BASEURL = "https://prod.runway-api.link/"
    #else
    static let RUNWAY_BASEURL = "https://dev.runway-api.link/"
    #endif
}
