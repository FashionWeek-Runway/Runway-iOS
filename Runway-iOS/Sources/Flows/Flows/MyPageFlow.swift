//
//  MyPageFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MyPageFlow: Flow {
    
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
        case .myPageTab:
            return coordinateToMyPageScreen()
        case .editProfile:
            return coordinateToProfileSettingScreen()
        case .setting:
            return coordinateToSettingScreen()
        case .privacyInformationControlNeeded:
            return coordinateToPrivacyManagementScreen()
        case .profileChangeCompleted:
            return coordinateToProfileChangeCompletedScreen()
            
        case .userIsLoggedOut:
            return coordinateToMainLoginScreen()
        default:
            return .none
        }
    }
    
    private func coordinateToMyPageScreen() -> FlowContributors {
        let reactor = MyPageReactor(provider: provider)
        let viewController = MyPageViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToSettingScreen() -> FlowContributors {
        let reactor = SettingReactor(provider: provider)
        let viewController = SettingViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPrivacyManagementScreen() -> FlowContributors {
        return .none
    }
    
    private func coordinateToProfileSettingScreen() -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider)
        let viewController = ProfileSettingViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToProfileChangeCompletedScreen() -> FlowContributors {
        return .none
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: AppStep.userIsLoggedOut)
    }
}
