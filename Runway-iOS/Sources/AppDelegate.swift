//
//  AppDelegate.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKCommon
import NMapsMap

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let kakaoAPIKey = Bundle.main.kakaoAPIKey {
            KakaoSDK.initSDK(appKey: kakaoAPIKey)
        }
        FirebaseApp.configure()
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        if AppSettingService.shared.isFirstAppLaunch {
            AppSettingService.shared.removeSettings()
        }

        if let nmfClientId = Bundle.main.nmfClientId {
            NMFAuthManager.shared().clientId = nmfClientId
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

