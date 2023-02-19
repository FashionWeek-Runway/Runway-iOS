//
//  MainFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    var provider: ServiceProviderType
    
    private let rootViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        return tabBarController
    }()
    
    // MARK: - intializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .userIsLoggedIn:
            return coordinateToMainTabScreen()
        default:
            return .none
        }
    }
    
    private func coordinateToMainTabScreen() -> FlowContributors {
        let homeReactor = HomeReactor(provider: provider)
        let homeViewController = HomeViewController(with: homeReactor)
        
        let mapReactor = MapReactor(provider: provider)
        let mapViewController = MapViewController(with: mapReactor)
        
        let myPageReactor = MyPageReactor(provider: provider)
        let myPageViewController = MyPageViewController(with: myPageReactor)
        
        let homeFlow = HomeFlow(with: provider)
        let mapFlow = MapFlow(with: provider)
        let myPageFlow = MyPageFlow(with: provider)
        
        Flows.use(homeFlow, mapFlow, myPageFlow, when: .ready) { flow1Root, flow2Root, flow3Root in
            
            let homeTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_home_off"), selectedImage: UIImage(named: "icon_home_off"))
            flow1Root.tabBarItem = homeTabbarItem
            
            let mapTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_location_off"), selectedImage: UIImage(named: "icon_location_on"))
            flow2Root.tabBarItem = mapTabbarItem
            
            let myPageTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_my_off"), selectedImage: UIImage(named: "icon_my_on"))
            flow3Root.tabBarItem = myPageTabbarItem
            
            self.rootViewController.setViewControllers([flow1Root, flow2Root, flow3Root], animated: false)
        }
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow, withNextStepper: homeReactor),
                                            .contribute(withNextPresentable: mapFlow, withNextStepper: mapReactor),
                                            .contribute(withNextPresentable: myPageFlow, withNextStepper: myPageReactor)])
    }
}
