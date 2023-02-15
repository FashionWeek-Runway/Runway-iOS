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
    
    // MARK: - initializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .loginRequired:
            return coordinateToMainLoginScreen()
        case .phoneNumberLogin:
            return coordinateToPhoneLoginScreen()
        case .forgotPassword:
            return coordinateToForgotPasswordScreen()
        case .userIsLoggedIn:
            // TODO: 로그인 완료 이후...
            return .none
        case .profileSettingIsRequired(let profileImageURL, let nickname):
            return coordinateToProfileSettingScreen(profileImageURL: profileImageURL, nickname: nickname)
        case .categorySettingIsRequired(let profileImageURL,
                                        let profileImageData,
                                        let socialID,
                                        let nickname):
            return coordinateToCategorySettingScreen(profileImageURL: profileImageURL, profileImageData, nickname, socialID: socialID)
        default:
            return .none
        }
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        let reactor = MainLoginReactor(provider: provider)
        let viewController = MainLoginViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: false)
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
    
    private func coordinateToProfileSettingScreen(profileImageURL: String?, nickname: String?) -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider, profileImageURL, nickname)
        
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
