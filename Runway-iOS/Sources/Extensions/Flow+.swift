//
//  Flow+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/20.
//

import RxFlow
import UIKit

extension Flow {
    func open(url: URL) -> FlowContributors {
        UIApplication.shared.open(url)
        return .none
    }
    
    func showNaverMap(storeName: String, lat: Double, lng: Double) -> FlowContributors {
        guard let encodedURL = "nmap://search?lat=\(lat)&lng=\(lng)&query=\(storeName)&appname=com.fashionweek.Runway-iOS"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else { return .none }
        
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return .none }
        
        if UIApplication.shared.canOpenURL(url) {
            return open(url: url)
        } else {
            return open(url: appStoreURL)
        }
    }
}
