//
//  SettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class SettingReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case privacyManageButtonDidTap
    }
    
    enum Mutation {

    }
    
    struct State {
        let appVersion: String
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .privacyManageButtonDidTap:
            steps.accept(AppStep.privacyInformationControlNeeded)
            return .empty()
        }
    }
}
