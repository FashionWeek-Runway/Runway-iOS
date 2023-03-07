//
//  HomeFLow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class HomeFlow: Flow {
    
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
        case .homeTab:
            return coordinateToHomeTabScreen()
        case .categorySelect(let nickname):
            return coordinateToCategorySelectScreen(nickname: nickname)
            
            
        case .back(let animated):
            return backScreen(animated: animated)
        default:
            break
        }
        return .none
    }
    
    private func coordinateToHomeTabScreen() -> FlowContributors {
        let reactor = HomeReactor(provider: provider)
        let viewController = HomeViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToCategorySelectScreen(nickname: String) -> FlowContributors {
        let reactor = CategorySelectReactor(provider: provider, nickname: nickname)
        let viewController = CategorySelectViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func backScreen(animated: Bool) -> FlowContributors {
        self.rootViewController.popViewController(animated: animated)
        return .none
    }
}
