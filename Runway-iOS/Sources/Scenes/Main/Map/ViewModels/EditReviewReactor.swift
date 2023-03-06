//
//  EditReviewReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class EditReviewReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case registerButtonDidTap(Data?)
    }
    
    enum Mutation {
    }
    
    struct State {
        var reviewImageData: Data
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let storeId: Int
    
    // MARK: - initializer
    init(provider: ServiceProviderType, storeId: Int, reviewImageData: Data) {
        self.provider = provider
        self.initialState = State(reviewImageData: reviewImageData)
        self.storeId = storeId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .registerButtonDidTap(let imageData):
            guard let imageData = imageData else { return .empty() }
            return provider.showRoomService.storeReview(storeId: storeId, imageData: imageData).flatMap { request -> Observable<Mutation> in
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {

    }
}

