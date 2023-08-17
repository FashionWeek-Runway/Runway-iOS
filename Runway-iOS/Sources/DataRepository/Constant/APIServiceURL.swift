//
//  APIServiceURL.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation

class APIServiceURL {
    #if RELEASE
    static let RUNWAY_BASEURL = "https://prod.runwayserver.shop/"
    #else
    static let RUNWAY_BASEURL = "http://runway-dev-env.eba-h3xrns2m.ap-northeast-2.elasticbeanstalk.com/"
    #endif
}
