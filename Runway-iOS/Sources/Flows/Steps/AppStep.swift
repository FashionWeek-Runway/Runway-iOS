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
    case dismiss
    case toast(String)
    
    case back
    
    // Login
    case loginRequired
    case userIsLoggedIn
    
    case phoneNumberLogin
    case forgotPassword
    case forgotPasswordCertificationIsRequired(String)
    case newPasswordInputRequired(String)
    case userChangedPassword
    
    // Sign Up
    case identityVerificationIsRequired
    case phoneCertificationNumberIsRequired
    case passwordInputRequired
    case policyAgreementIsRequired
    
    case usagePolicyDetailNeedToShow
    case privacyPolicyDetailNeedToShow
    case locationPolicyDetailNeedToShow
    case marketingPolicyDetailNeedToShow
    
    case profileSettingIsRequired
    case categorySettingIsRequired
    case signUpIsCompleted
    
    // Main
    case homeTab
    case mapTab
    case myPageTab
}
