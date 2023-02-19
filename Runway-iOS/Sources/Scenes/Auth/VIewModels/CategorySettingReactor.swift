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

import Alamofire

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
    }
    
    struct State {
        var nickname: String? = nil
        var isNextButtonEnabled: Bool = false

        
        var isSelected: [String: Bool]
        var categories: [String]
    }
    
    enum SignUpAs {
        case kakao
        case apple
        case phone
    }
    
    // MARK: - Properties
    
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    let initialState: State
    let signUpAs: SignUpAs
    
    let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
    let categoryForRequestId = ["미니멀": 1, "캐주얼": 2, "시티보이": 3, "스트릿": 4, "빈티지": 5, "페미닌": 6]
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        
        if let nickname = provider.signUpService.signUpAsKakaoData?.nickname { // kakao
            self.initialState = State(nickname: nickname,
                                      isSelected: Dictionary(uniqueKeysWithValues: categories.map { ($0, false) }),
                                      categories: categories)
            self.signUpAs = .kakao
        } else if let nickname = provider.signUpService.signUpAsPhoneData?.nickname { // phone
            self.initialState = State(nickname: nickname,
                                      isSelected: Dictionary(uniqueKeysWithValues: categories.map { ($0, false) }),
                                      categories: categories)
            self.signUpAs = .phone
        } else if let nickname = provider.signUpService.signUpAsAppleData?.nickname { // apple
            self.initialState = State(nickname: nickname,
                                      isSelected: Dictionary(uniqueKeysWithValues: categories.map { ($0, false) }),
                                      categories: categories)
            self.signUpAs = .apple
        } else { // 오류케이스
            self.signUpAs = .phone
            self.initialState = State(isSelected: [:], categories: categories)
            
        }
    }
    
    // MARK: - Reactor
    
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
            let selectedCategoryIndex = currentState.categories.filter({ currentState.isSelected[$0] == true })
                .map { categoryForRequestId[$0] }.compactMap { $0 }
            
            switch signUpAs {
            case .kakao:
                provider.signUpService.signUpAsKakaoData?.categoryList = selectedCategoryIndex
                provider.signUpService.signUpAsKakao().subscribe(onNext: { [weak self] request in
                    do {
                        guard let requestData = request.data else { return }
                        let data = try JSONDecoder().decode(SocialSignUpResponse.self, from: requestData)
                        self?.provider.appSettingService.refreshToken = data.result.refreshToken
                        self?.provider.appSettingService.authToken = data.result.accessToken
                        self?.provider.appSettingService.lastLoginType = .kakao
                        self?.provider.appSettingService.isLoggedIn = true
                    } catch {
                        print(error)
                    }
                }).disposed(by: disposeBag)
            case .apple:
                provider.signUpService.signUpAsAppleData?.categoryList = selectedCategoryIndex
                provider.signUpService.signUpAsApple().subscribe(onNext: { [weak self] request in
                    do {
                        guard let requestData = request.data else { return }
                        let data = try JSONDecoder().decode(SocialSignUpResponse.self, from: requestData)
                        self?.provider.appSettingService.refreshToken = data.result.refreshToken
                        self?.provider.appSettingService.authToken = data.result.accessToken
                        self?.provider.appSettingService.lastLoginType = .apple
                        self?.provider.appSettingService.isLoggedIn = true
                    } catch {
                        print(error)
                    }
                }).disposed(by: disposeBag)
            case .phone:
                provider.signUpService.signUpAsPhoneData?.categoryList = selectedCategoryIndex
                provider.signUpService.signUpAsPhone().subscribe(onNext: { [weak self] request in
                    do {
                        guard let requestData = request.data else { return }
                        let data = try JSONDecoder().decode(SignUpAsPhoneResponse.self, from: requestData)
                        self?.provider.appSettingService.refreshToken = data.result.refreshToken
                        self?.provider.appSettingService.authToken = data.result.accessToken
                        self?.provider.appSettingService.lastLoginType = .phone
                        self?.provider.appSettingService.isLoggedIn = true
                    } catch {
                        print(error)
                    }
                }).disposed(by: disposeBag)
            }
            steps.accept(AppStep.signUpIsCompleted)
            return .empty()
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
        }
        
        return newState
    }
    
    func createBody(parameters: [String: Any], boundary: String, data: Data) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
          body.append(boundaryPrefix.data(using: .utf8)!)
          body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }


        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"multipartFile\"; filename=\"test\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)

        body.append(boundaryPrefix.data(using: .utf8)!)

        return body
    }
    
}
