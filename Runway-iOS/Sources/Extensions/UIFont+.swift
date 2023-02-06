//
//  UIFont+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/06.
//

import UIKit

enum FontName: String {
    case spoqaHanSansNeoBold = "SpoqaHanSansNeo-Bold"
    case spoqaHanSansNeoLight = "SpoqaHanSansNeo-Light"
    case spoqaHanSansNeoMedium = "SpoqaHanSansNeo-Medium"
    case spoqaHanSansNeoRegular = "SpoqaHanSansNeo-Regular"
    case spoqaHanSansNeoThin = "SpoqaHanSansNeo-Thin"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
