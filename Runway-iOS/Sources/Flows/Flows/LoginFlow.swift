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
    
    
//    let categoryList: [String]?
//    let nickname: String?
//    let profileImageURL: String?
//    let socialID: String?
//    let type: String?
    
    // MARK: - initializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .loginRequired:
            return coordinateToMainLoginScreen()
        case .userIsLoggedIn:
            // TODO: 로그인 완료 이후...
            return .none
        case .profileSettingIsRequired(let profileImageURL, let nickname):
            return coordinateToProfileSettingScreen(profileImageURL: profileImageURL, nickname: nickname)
        case .categorySettingIsRequired(let profileImageURL,
                                        let nickname):
            return coordinateToCategorySettingScreen(profileImageURL: profileImageURL,
                                                     nickname: nickname)
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
    
    private func coordinateToProfileSettingScreen(profileImageURL: String?, nickname: String?) -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider, profileImageURL, nickname)
        
        let viewController = ProfileSettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToCategorySettingScreen(profileImageURL: String?, nickname: String?) -> FlowContributors {
        let reactor = CategorySettingReactor(provider: provider, nickname)
        let viewController = CategorySettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
