//
//  InformationChangeRequestViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/02.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire

final class InformationChangeRequestReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case reasonButtonDidTap(Int)
        case requestButtonDidTap
    }
    
    enum Mutation {
        case setReportingReason(Int)
        case needDismiss
    }
    
    struct State {
        var reasons: [Int: Bool] = Dictionary(grouping: 1...5, by: { $0 }).mapValues { _ in false }
        var needDismiss: Bool = false
        
        var requestEnabled: Bool {
            return reasons.values.contains(true)
        }
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    let storeId: Int
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType, storeId: Int) {
        self.provider = provider
        self.storeId = storeId
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reasonButtonDidTap(let reasonNumber):
            return .just(.setReportingReason(reasonNumber))
        case .requestButtonDidTap:
            let reportReason = [Int](currentState.reasons.filter { $0.value }.keys)
            
            provider.showRoomService.storeReport(storeId: storeId, reportReason: reportReason)
                .subscribe(with: self, onNext: {(owner, _) in
                    UIWindow.makeToastAnimation(message: "어플 개선에 도움을 주셔서 감사합니다.\n검토 후 필요한 조치를 취하겠습니다 :)", .bottom, 20.0)
                })
                .disposed(by: disposeBag)
            return .just(.needDismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setReportingReason(let reason):
            state.reasons[reason] = !state.reasons[reason]!
        case .needDismiss:
            state.needDismiss = true
        }
        
        return state
    }
}

