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
        case .profileChangeCompleted:
            return coordinateToProfileChangeCompletedScreen()
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
    
    private func coordinateToProfileSettingScreen() -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider)
        let viewController = ProfileSettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToProfileChangeCompletedScreen() -> FlowContributors {
        return .none
    }
}
