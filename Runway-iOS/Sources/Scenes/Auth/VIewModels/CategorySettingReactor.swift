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
        case tryLogin
    }
    
    struct State {
//        var profileImageData: Data
//        var profileImageURL: String?
        var nickname: String? = nil
//        var socialID: String?
        
        var isNextButtonEnabled: Bool = false

        
        var isSelected: [String: Bool]
        var categories: [String]
    }
    
    // MARK: - Properties
    
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    let initialState: State
    
    let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
    let categoryForRequestId = ["미니멀": "1", "캐주얼": "2", "시티보이": "3", "스트릿": "4", "빈티지": "5", "페미닌": "6"]
    
    var signUpAsKakaoData: SignUpAsKakaoData?
    var signUpAsPhoneData: SignUpAsPhoneData?
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType,
         signUpAsKakaoData: SignUpAsKakaoData) {
        self.provider = provider
        self.initialState = State(nickname: signUpAsKakaoData.nickname,
                                  isSelected: Dictionary(uniqueKeysWithValues: categories.map{ ($0, false) }),
                                  categories: categories)
        self.signUpAsKakaoData = signUpAsKakaoData
        self.signUpAsPhoneData = nil
    }
    
    init(provider: ServiceProviderType,
         signUpAsPhoneData: SignUpAsPhoneData) {
        self.provider = provider
        self.initialState = State(nickname: signUpAsPhoneData.nickname,
                                  isSelected: Dictionary(uniqueKeysWithValues: categories.map{ ($0, false) }),
                                  categories: categories)
        self.signUpAsKakaoData = nil
        self.signUpAsPhoneData = signUpAsPhoneData
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
            if let signUpAsKakaoData = signUpAsKakaoData {
                
            }
            else if let signUpAsPhoneData = signUpAsPhoneData { // 폰으로 로그인
//                provider.signUpService.signUpAsPhone(userData: signUpAsPhoneData)
//                    .subscribe(onNext: { request in
//                        print(request.response)
//                    })
                
                var request = URLRequest(url: URL(string: "https://dev.runwayserver.shop/login/signup")!)
                request.httpMethod = "POST"

                // Header
                request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
                request.setValue("*/*", forHTTPHeaderField: "Accept")

                var parameters = Parameters()
                var params = Parameters()
                params.updateValue(signUpAsPhoneData.categoryList!, forKey: "categoryList")
                params.updateValue(signUpAsPhoneData.gender!, forKey: "gender")
                params.updateValue(signUpAsPhoneData.name!, forKey: "name")
                params.updateValue(signUpAsPhoneData.nickname!, forKey: "nickname")
                params.updateValue(signUpAsPhoneData.phone!, forKey: "phone")
                params.updateValue(signUpAsPhoneData.password!, forKey: "password")

                // Body
                request.httpBody = createBody(parameters: params, boundary: "bounds", data: signUpAsPhoneData.profileImageData!)
                dump(request)
//                URLSession.shared.upload
                URLSession.shared.dataTask(with: request) { data, response, error in
                    print(error)
                    print(data)
                    print(response)
                    
                    guard let object = try? JSONSerialization.jsonObject(with: data!, options: []),
                          let datas = try? JSONSerialization.data(
                            withJSONObject: object, options: [.prettyPrinted]
                          ),
                          let prettyPrintedString = NSString(data: datas, encoding: String.Encoding.utf8.rawValue) else { return }
                    print(prettyPrintedString as String)
                }.resume()
            }
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
        
        if signUpAsPhoneData != nil {
            signUpAsPhoneData?.categoryList = newState.categories.joined(separator: ",")
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
