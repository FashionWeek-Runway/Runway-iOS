//
//  AppStep.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import Foundation
import RxFlow

enum AppStep: Step {
    
    // Global
    case alert(String)
    case actionSheet(String, String)
    
    // Login
    case loginRequired
    case userIsLoggedIn
    
    case phoneNumberLogin
    case forgotPassword
    
    // Sign Up
    case identityVerificationIsRequired
    case phoneCertificationNumberIsRequired
    case passwordInputRequired
    case policyAgreementIsRequired
    case policyDetailNeedToShow
    case profileSettingIsRequired(profileImageURL: String?, kakaoID: String?)
    case categorySettingIsRequired(profileImageURL: String?, profileImageData: Data, socialID: String?, nickname: String)
    case SignUpIsCompleted
    
    
    
}
