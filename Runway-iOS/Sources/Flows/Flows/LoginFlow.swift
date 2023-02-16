//
//  LoginFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import RxFlow
import UIKit

final class LoginFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var provider: ServiceProviderType
    
    private let rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }()
    
    
    // MARK: - DTO
    private var signUpASKakaoData = SignUpAsKakaoData()
    private var signUpAsPhoneData = SignUpAsPhoneData()
    
    // MARK: - initializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .toast(let message):
            return makeToastMessage(message)
        case .back:
            return backScreen()
        case .dismiss:
            return dismissScreen()
        case .alert(let title, let message, let actions, let handler):
            return showAlertSheet(title: title, message: message, actions: actions, handler: handler)
            
        case .loginRequired:
            return coordinateToMainLoginScreen()
            
        case .phoneNumberLogin:
            return coordinateToPhoneLoginScreen()
            
        case .forgotPassword:
            return coordinateToForgotPasswordScreen()
            
        case .forgotPasswordCertificationIsRequired(let phoneNumber):
            return coordinateToForgotPasswordPhoneCertificationScreen(phoneNumber: phoneNumber)
            
        case .identityVerificationIsRequired:
            signUpAsPhoneData = SignUpAsPhoneData()
            return coordinateToIdentityVerificationScreen()
            
        case .newPasswordInputRequired(let phoneNumber):
            return coordinateToNewPasswordInputScreen(phoneNumber: phoneNumber)
            
        case .phoneCertificationNumberIsRequired(let gender, let name, let phoneNumber):
            self.signUpAsPhoneData.gender = gender
            self.signUpAsPhoneData.name = name
            self.signUpAsPhoneData.phone = phoneNumber
            return coordinateToPhoneCertificationScreen()
            
        case .passwordInputRequired:
            return coordinateToPasswordInputScreen()
            
        case .policyAgreementIsRequired(let password):
            self.signUpAsPhoneData.password = password
            return coordinateToPolicyAgreeScreen()
            
        case .userIsLoggedIn:
            // TODO: 로그인 완료 이후...
            return .none
        case .profileSettingIsRequired(let profileImageURL, let socialID):
            if let socialID = socialID {
                self.signUpASKakaoData = SignUpAsKakaoData()
                signUpASKakaoData.socialID = socialID
                signUpASKakaoData.profileImageURL = profileImageURL
            }
            return coordinateToProfileSettingScreen(profileImageURL: profileImageURL, socialID: socialID)
            
        case .categorySettingIsRequired(let profileImageURL,
                                        let profileImageData,
                                        let socialID,
                                        let nickname):
            self.signUpASKakaoData.profileImageURL = profileImageURL
            self.signUpASKakaoData.profileImageData = profileImageData
            self.signUpASKakaoData.nickname = nickname
            self.signUpASKakaoData.socialID = socialID
            self.signUpAsPhoneData.profileImageData = profileImageData
            self.signUpAsPhoneData.nickname = nickname
            return coordinateToCategorySettingScreen(profileImageURL: profileImageURL, profileImageData, nickname, socialID: socialID)
        default:
            return .none
        }
    }
    
    private func makeToastMessage(_ message: String) -> FlowContributors {
        UIWindow.makeToastAnimation(message: message)
        return .none
    }
    
    private func backScreen() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func dismissScreen() -> FlowContributors {
        self.rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func showAlertSheet(title: String, message: String, actions: [String], handler: @escaping ((UIAlertAction) -> Void)) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action, style: .default, handler: handler))
        }

        self.rootViewController.present(alert, animated: true)
        return .none
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        let reactor = MainLoginReactor(provider: provider)
        let viewController = MainLoginViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPhoneLoginScreen() -> FlowContributors {
        let reactor = PhoneLoginReactor(provider: provider)
        let viewController = PhoneLoginViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToForgotPasswordScreen() -> FlowContributors {
        let reactor = ForgotPasswordReactor(provider: provider)
        let viewController = ForgotPasswordViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToForgotPasswordPhoneCertificationScreen(phoneNumber: String?) -> FlowContributors {
        guard let phoneNumber = phoneNumber else { return .none }
        let reactor = ForgotPasswordPhoneCertificationNumberInputReactor(provider: provider, phoneNumber: phoneNumber)
        let viewController = ForgotPasswordPhoneCertificationNumberInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToNewPasswordInputScreen(phoneNumber: String?) -> FlowContributors {
        guard let phoneNumber = phoneNumber else { return .none }
        let reactor = NewPasswordInputReactor(provider: provider, phoneNumber: phoneNumber)
        let viewController = NewPasswordInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToIdentityVerificationScreen() -> FlowContributors {
        let reactor = IdentityVerificationReactor(provider: provider)
        let viewController = IdentityVerificationViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPhoneCertificationScreen() -> FlowContributors {
        let reactor = PhoneCertificationReactor(provider: provider, phoneNumber: self.signUpAsPhoneData.phone ?? "")
        let viewController = PhoneCertificationNumberInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPasswordInputScreen() -> FlowContributors {
        let reactor = PasswordInputReactor(provider: provider)
        let viewController = PasswordInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPolicyAgreeScreen() -> FlowContributors {
        let reactor = PolicyAgreementReactor(provider: provider)
        let viewController = PolicyAgreementViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToProfileSettingScreen(profileImageURL: String?, socialID: String?) -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider, profileImageURL, socialID)
        
        let viewController = ProfileSettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToCategorySettingScreen(profileImageURL: String?, _ profileImageData: Data, _ nickname: String, socialID: String?) -> FlowContributors {
        var reactor: CategorySettingReactor
        if socialID != nil { // 카카오의 경우
            reactor = CategorySettingReactor(provider: provider, signUpAsKakaoData: signUpASKakaoData)
        } else { // phone 로그인
            reactor = CategorySettingReactor(provider: provider, signUpAsPhoneData: self.signUpAsPhoneData)
        }
        let viewController = CategorySettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
