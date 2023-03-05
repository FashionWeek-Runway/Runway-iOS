//
//  String+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation
import Alamofire

extension String {
    static func limitedLengthString(_ string: String, length: Int) -> String { // limit
        if string.count > length {
            let index = string.index(string.startIndex, offsetBy: length)
            return String(string[..<index])
        } else {
            return string
        }
    }
}

extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
