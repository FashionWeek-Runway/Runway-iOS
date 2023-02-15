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

final class CategorySettingReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case selectCategory(String)
        case backButtonDidTap
        case nextButtonDidTap
    }
    
    enum Mutation {
        case emitIntialCategory
        case selectCategory(String)
        case tryLogin
    }
    
    struct State {
        var profileImageData: Data
        var profileImageURL: String?
        var nickname: String?
        var socialID: String?
        
        var isNextButtonEnabled: Bool = false

        
        var isSelected: [String: Bool]
        var categories: [String]
    }
    
    // MARK: - Properties
    
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    let initialState: State
    
    // MARK: - initializer
    
    let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
    let categoryForRequestId = ["미니멀": "1", "캐주얼": "2", "시티보이": "3", "스트릿": "4", "빈티지": "5", "페미닌": "6"]
    init(provider: ServiceProviderType, _ profileImageUrl: String?, _ profileImageData: Data, _ nickname: String?, _ socialID: String?) {
        self.provider = provider
        self.initialState = State(profileImageData: profileImageData,
                                  profileImageURL: profileImageUrl,
                                  nickname: nickname,
                                  socialID: socialID,
                                  isSelected: Dictionary(uniqueKeysWithValues: categories.map{ ($0, false) }),
                                  categories: categories)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.emitIntialCategory)
        case .selectCategory(let category):
            return .just(.selectCategory(category))
        case .backButtonDidTap:
            steps.accept(AppStep.back)
            return .empty()
        case .nextButtonDidTap:
            // kakao login의 경우
            
//            guard let nickname = currentState.nickname,
//                  let imageUrl = initialState.profileImageURL,
//                  let kakaoID = initialState.socialID else { return .empty() }
//            let selectedCategoryIndex = currentState.categories.filter({ currentState.isSelected[$0] == true }).map { categoryForRequestId[$0]! }
//            
//            let requestDTO = SignUpAsKakaoData(categoryList: selectedCategoryIndex,
//                                               profileImageData: initialState.profileImageData,
//                                               nickname: nickname,
//                                               profileImageURL: imageUrl,
//                                               socialID: kakaoID,
//                                               type: "KAKAO")
            
//            provider.signUpService.signUpAsKakao(requestDTO)
//                .subscribe(onNext: { [weak self] uploadResponse in
//                    print(uploadResponse)
//                    guard let statusCode = uploadResponse.response?.statusCode else {
//                        print(uploadResponse)
//                        return
//                    }
//                    switch statusCode {
//                    case 200...299:
//                        do {
//                            guard let data = uploadResponse.data else { return }
//                            let responseData = try JSONDecoder().decode(SocialSignUpResult.self, from: data)
//                            self?.provider.appSettingService.isKakaoLoggedIn = true
//                            self?.provider.appSettingService.lastLoginType = "kakao"
//                            self?.provider.appSettingService.isLoggedIn = true
//                            self?.provider.appSettingService.authToken = responseData.accessToken
//                            self?.provider.appSettingService.refreshToken = responseData.refreshToken
//                        } catch let error {
//                            print(error)
//                        }
//                    default:
//                        print(uploadResponse.response?.statusCode)
//                        break
//                    }
//                }).disposed(by: disposeBag)
            
            return .just(.tryLogin)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .emitIntialCategory:
            newState.categories = initialState.categories
        case .selectCategory(let category):
            newState.isSelected[category]?.toggle()
            newState.isNextButtonEnabled = newState.isSelected.contains(where: { $0.value == true })
        case .tryLogin:
            break
        }
        
        return newState
    }
    
}
