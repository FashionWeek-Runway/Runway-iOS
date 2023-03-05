//
//  ReviewReportingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/06.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ReviewReportingReactor: Reactor, Stepper {
    // MARK: - Events
    
    struct State {
    }
    
    enum Action {

    }
    
    enum Mutation {

    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {

    }
}

