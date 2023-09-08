//
//  PopUpReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/08.
//

import Foundation

import RxFlow
import RxRelay
import ReactorKit
import Alamofire


final class PopUpReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case dismissButtonDidTap
    }
    
    enum Mutation {
        case setImageURL(URL)
    }
    
    struct State {
        var imageURL: URL? = nil
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    private let imageURL: URL
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType, imageURL: URL) {
        self.provider = provider
        self.initialState = State()
        self.imageURL = imageURL
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setImageURL(imageURL))
        case .dismissButtonDidTap:
            steps.accept(AppStep.dismiss)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setImageURL(let imageURL):
            state.imageURL = imageURL
        }
        
        return state
    }
}
