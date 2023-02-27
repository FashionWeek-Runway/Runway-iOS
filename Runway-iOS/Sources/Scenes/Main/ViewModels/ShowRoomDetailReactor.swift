//
//  ShowRoomDetailReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ShowRoomDetailReactor: Reactor, Stepper {
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
