//
//  LoginFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import RxFlow

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
    
    
    private var signUpAsPhone: SignUpAsPhone?
    
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
            signUpAsPhone = nil
            return coordinateToMainLoginScreen()
            
        case .phoneNumberLogin:
            return coordinateToPhoneLoginScreen()
            
        case .identityVerificationIsRequired:
            signUpAsPhone = SignUpAsPhone()
            return coordinateToIdentityVerificationScreen()
            
        case .phoneCertificationNumberIsRequired(let gender, let name, let phoneNumber):
            self.signUpAsPhone?.gender = gender
            self.signUpAsPhone?.name = name
            self.signUpAsPhone?.phone = phoneNumber
            return coordinateToPhoneCertificationScreen()
            
        case .passwordInputRequired:
            
            
            
        case .forgotPassword:
            return coordinateToForgotPasswordScreen()
            
        case .userIsLoggedIn:
            // TODO: 로그인 완료 이후...
            return .none
        case .profileSettingIsRequired(let profileImageURL, let socialID):
            return coordinateToProfileSettingScreen(profileImageURL: profileImageURL, socialID: socialID)
            
        case .categorySettingIsRequired(let profileImageURL,
                                        let profileImageData,
                                        let socialID,
                                        let nickname):
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
    
    private func coordinateToIdentityVerificationScreen() -> FlowContributors {
        let reactor = IdentityVerificationReactor(provider: provider)
        let viewController = IdentityVerificationViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPhoneCertificationScreen() -> FlowContributors {
        let reactor = PhoneCertificationReactor(provider: provider, phoneNumber: self.signUpAsPhone?.phone ?? "")
        let viewController = PhoneCertificationNumberInputViewController(with: reactor)
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
        let reactor = CategorySettingReactor(provider: provider, profileImageURL, profileImageData, nickname, socialID)
        let viewController = CategorySettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
