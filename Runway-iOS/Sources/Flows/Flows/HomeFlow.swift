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
    
    private let rootViewController: NavigationController = {
        let navigationController = NavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        return navigationController
    }()
    
    // MARK: - initializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .dismiss:
            rootViewController.presentedViewController?.dismiss(animated: true)
            return .none
        case .homeTab:
            return coordinateToHomeTabScreen()
        case .categorySelect(let nickname):
            return coordinateToCategorySelectScreen(nickname: nickname)
        case .showAllStore:
            return coordinateToAllStoreScreen()
        case .showRoomDetail(let storeId):
            return coordinateToShowRoomDetailScreen(storeId: storeId)
        case .showRoomInformationChangeRequest(let storeId):
            return coordinateToShowRoomInformationChangeRequestScreen(storeId: storeId)
        case .editReviewImage(let storeId, let imageData):
            return coordinateToEditReviewImageScreen(storeId: storeId, imageData: imageData)
        case .userReviewReels(let reviewId, let mode):
            return coordinateToReviewReelsScreen(reviewId: reviewId, mode: mode)
        case .reportReview(let reviewId):
            return coordinateToReviewReportingScreen(reviewId: reviewId)
        case .back(let animated):
            return backScreen(animated: animated)
        case .open(let url):
            return open(url: url)
        case .openNaverMap(let title, let latitude, let longitude):
            return showNaverMap(storeName: title, lat: latitude, lng: longitude)
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
    
    private func coordinateToAllStoreScreen() -> FlowContributors {
        let reactor = AllStoreReactor(provider: provider)
        let viewController = AllStoreViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToShowRoomDetailScreen(storeId: Int) -> FlowContributors {
        let reactor = ShowRoomDetailReactor(provider: provider, storeId: storeId)
        let viewController = ShowRoomDetailViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToShowRoomInformationChangeRequestScreen(storeId: Int) -> FlowContributors {
        let reactor = InformationChangeRequestReactor(provider: provider, storeId: storeId)
        let viewController = InformationChangeRequestViewController(with: reactor)
        self.rootViewController.present(viewController, animated: true)
        return .none
    }
    
    private func coordinateToEditReviewImageScreen(storeId: Int, imageData: Data) -> FlowContributors {
        let reactor = EditReviewReactor(provider: provider, storeId: storeId ,reviewImageData: imageData)
        let viewController = EditReviewViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToReviewReelsScreen(reviewId: Int, mode: AppStep.ReviewReelsMode) -> FlowContributors {
        var reactor: ReviewReelsReactor
        switch mode {
        case .home:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .home)
        case .store:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .store)
        case .myReview:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .myReview)
        case .bookmarkedReview:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .bookmarkedReview)
        }
        let viewController = ReviewReelsViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToReviewReportingScreen(reviewId: Int) -> FlowContributors {
        let reactor = ReviewReportingReactor(provider: provider)
        let viewController = ReviewReportingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func backScreen(animated: Bool) -> FlowContributors {
        self.rootViewController.popViewController(animated: animated)
        return .none
    }
}
