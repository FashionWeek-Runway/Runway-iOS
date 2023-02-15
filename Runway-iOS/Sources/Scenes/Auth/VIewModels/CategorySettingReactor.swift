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
        case nextButtonDidTap
    }
    
    enum Mutation {
        case selectCategory(String)
        case tryLogin
    }
    
    struct State {
        var profileImageData: Data
        var profileImageURL: String?
        var nickname: String?
        var socialID: String?
        
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
    
    init(provider: ServiceProviderType, _ profileImageUrl: String?, _ profileImageData: Data, _ nickname: String?, _ socialID: String?) {
        self.provider = provider
        self.initialState = State(profileImageData: profileImageData,
                                  profileImageURL: profileImageUrl,
                                  nickname: nickname,
                                  socialID: socialID,
                                  categories: categories)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCategory(let category):
            return .just(.selectCategory(category))
        case .nextButtonDidTap:
            guard let nickname = currentState.nickname,
                  let imageUrl = initialState.profileImageURL,
                  let kakaoID = initialState.socialID else { return .empty() }
            // kakao login의 경우
            let requestDTO = SignUpAsKakaoData(categoryList: currentState.selectedItems, profileImageData: initialState.profileImageData, nickname: nickname, profileImageURL: imageUrl, socialID: kakaoID, type: "KAKAO")
            
            provider.signUpService.signUpAsKakao(requestDTO)
                .subscribe(onNext: { [weak self] (response, data) in
                    switch response.statusCode {
                    case 200...299:
                        do {
                            let responseData = try JSONDecoder().decode(SocialSignUpResult.self, from: data)
                            self?.provider.appSettingService.isKakaoLoggedIn = true
                            self?.provider.appSettingService.lastLoginType = "kakao"
                            self?.provider.appSettingService.isLoggedIn = true
                            self?.provider.appSettingService.authToken = responseData.accessToken
                            self?.provider.appSettingService.refreshToken = responseData.refreshToken
                        } catch let error {
                            print(error)
                        }
                    default:
                        print(response.statusCode)
                        break
                    }
                }).disposed(by: disposeBag)
            
            return .just(.tryLogin)
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
        case .tryLogin:
            break
        }
        
        return newState
    }
    
}
