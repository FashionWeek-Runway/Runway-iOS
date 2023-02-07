//
//  AppSettingService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Foundation

final class AppSettingService {
    
    static let shared = AppSettingService()
    
    private init() { }
    
    @UserDefault(key: "authToken", defaultValue: "")
    var authToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    var refreshToken: String
    
    @UserDefault(key: "isLoggedIn", defaultValue: false)
    var isLoggedIn: Bool
    
    @UserDefault(key: "isAppleLoggedIn", defaultValue: false)
    var isAppleLoggedIn: Bool
    
    @UserDefault(key: "isKakaoLoggedIn", defaultValue: false)
    var isKakaoLoggedIn: Bool
    
    @UserDefault(key: "kakaoAccessToken", defaultValue: "")
    var kakaoAccessToken: String
    
    @UserDefault(key: "lastLoginType", defaultValue: "")
    var lastLoginType: String
    
    var isFirstAppLaunch: Bool {
        get {
            let isFirstLaunch = UserDefaults.standard.bool(forKey: "hasBeenLaunchedAppBefore")
            if !isFirstLaunch {
                UserDefaults.standard.set(true, forKey: "hasBeenLaunchedAppBefore")
            }
            return isFirstLaunch
        }
    }
    
    func removeSettings() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
