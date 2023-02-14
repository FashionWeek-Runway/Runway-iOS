//
//  CategorySettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow
import RxDataSources

typealias FashionStyleCollectionViewSectionModel = SectionModel<Int, FashionStyleCategoryCollectionViewSection>

enum FashionStyleCategoryCollectionViewSection {
    case defaultCell(FashionStyleCollectionViewCellReactor)
}

final class CategorySettingReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case selectCategory(String)
    }
    
    enum Mutation {
        case selectCategory(String)
    }
    
    struct State {
        var profileImageURL: String?
        var profileImageData: Data?
        var nickname: String?
        
        var selectedItems: [String] = []
        var categories: [String]
    }
    
    // MARK: - Properties
    
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    let initialState: State
    
    // MARK: - initializer
    
    let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
    
    init(provider: ServiceProviderType, _ nickname: String?) {
        self.provider = provider
        self.initialState = State(nickname: nickname,
                                  categories: categories)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectCategory(category):
            return .just(.selectCategory(category))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .selectCategory(let category):
            if let itemIndex = state.selectedItems.firstIndex(of: category) {
                newState.selectedItems.remove(at: itemIndex)
            } else {
                newState.selectedItems.append(category)
            }
        }
        
        return newState
    }
    
}
