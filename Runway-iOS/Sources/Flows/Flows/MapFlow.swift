//
//  MapFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MapFlow: Flow {
    
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
        // TODO: later
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .mapTab:
            return coordinateToMapTabScreen()
        case .mapSearch(let location):
            return coordinateToMapSearchScreen(mapLocation: location)
        case .showRoomDetail(let storeId):
            return coordinateToShowRoomDetail(storeId: storeId)
        case .back:
            return back()
        default:
            return .none
        }
    }
    
    private func coordinateToMapTabScreen() -> FlowContributors {
        let reactor = MapReactor(provider: provider)
        let viewController = MapViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToMapSearchScreen(mapLocation: (Double, Double)) -> FlowContributors {
        let reactor = MapSearchReactor(provider: provider, mapLocation: mapLocation)
        let viewController = MapSearchViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToShowRoomDetail(storeId: Int) -> FlowContributors {
        let reactor = ShowRoomDetailReactor(provider: provider, storeId: storeId)
        let viewController = ShowRoomDetailViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func back() -> FlowContributors {
        self.rootViewController.popViewController(animated: false)
        return.none
    }
}
