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
    case alert(String, String, [String], (UIAlertAction) -> Void)
    case actionSheet(String, String)
    case dismiss
    case toast(String)
    
    case back
    
    // Login
    case loginRequired
    case userIsLoggedIn
    
    case phoneNumberLogin
    case forgotPassword
    case newPasswordInputRequired
    
    // Sign Up
    case identityVerificationIsRequired
    case phoneCertificationNumberIsRequired(gender: String, name: String, phoneNumber: String)
    case passwordInputRequired
    case policyAgreementIsRequired(password: String)
    case policyDetailNeedToShow
    case profileSettingIsRequired(profileImageURL: String?, kakaoID: String?)
    case categorySettingIsRequired(profileImageURL: String?, profileImageData: Data, socialID: String?, nickname: String)
    case SignUpIsCompleted
    
}
