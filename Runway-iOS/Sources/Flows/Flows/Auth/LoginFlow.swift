//
//  LoginFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import RxFlow

//class LoginFlow: Flow {
//    
//    var root: Presentable {
//        return self.rootViewController
//    }
//    
//    private let rootViewController: UINavigationController = {
//        let navigationController = UINavigationController()
//        navigationController.setNavigationBarHidden(true, animated: false)
//        return navigationController
//    }()
//    
//    init() {
//        
//    }
//    
//    func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? AppStep else { return .none }
//        
//        switch step {
//        case .alert(let string):
//            <#code#>
//        case .loginRequired:
//            return navigateToMainLoginScreen()
//        case .userIsLoggedIn:
//            return .end(forwardToParentFlowWithStep: AppStep.user)
//        case .phoneNumberLogin:
//            <#code#>
//        case .forgotPassword:
//            <#code#>
//        case .identityVerificationIsRequired:
//            <#code#>
//        case .phoneCertificationNumberIsRequired:
//            <#code#>
//        case .passwordInputRequired:
//            <#code#>
//        case .policyAgreementIsRequired:
//            <#code#>
//        case .policyDetailNeedToShow:
//            <#code#>
//        case .profileSettingIsRequired:
//            <#code#>
//        case .categorySettingIsRequired:
//            <#code#>
//        case .SignUpIsCompleted:
//            <#code#>
//        }
//    }
//    
//    private func navigateToMainLoginScreen() -> FlowContributors {
//        let reactor = MainLoginReactor()
//        let viewController = MainLoginViewController(with: reactor)
//        
//        self.rootViewController.setViewControllers([viewController], animated: false)
//        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
//    }
//}
