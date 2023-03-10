//
//  ProfileEditReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

import Kingfisher

final class ProfileEditReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewWillAppear
        case backButtonDidTap
        case setProfileImage(Data)
        case enterNickname(String)
        case saveButtonDidTap
    }
    
    enum Mutation {
        case setProfileImageData(Data)
        case setProfileImageURL(String)
        case setUserNickname(String?)
        case setUserNicknameIsDuplicate
    }
    
    struct State {
        var profileImageURL: String? = nil
        
        var showActionSheet: Bool = false
        
        var nickname: String?
        var profileImageData: Data?
        var nextButtonEnabled: Bool = false
        
        var isNickNameDuplicate = false
        var isNickNameValidate = true
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType) {
        let state = State()
        self.initialState = state
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return provider.userService.existingProfile().data()
                .decode(type: ExistingProfileResponse.self, decoder: JSONDecoder())
                .flatMap { responseData -> Observable<Mutation> in
                    return Observable.concat([
                        .just(.setProfileImageURL(responseData.result.imageURL)),
                        .just(.setUserNickname(responseData.result.nickname))
                    ])
                }
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .setProfileImage(let data):
            return .just(.setProfileImageData(data))
        case .enterNickname(let nickname):
            return .just(.setUserNickname(nickname))
        case .saveButtonDidTap:
            guard let imageData = currentState.profileImageData,
                  let nickname = currentState.nickname else { return .empty() }
            
            return provider.signUpService.checkNicknameDuplicate(nickname: nickname).response()
                .flatMap { response -> Observable<Mutation> in
                    if 200...299 ~= response.statusCode {
                        return .empty()
                    } else {
                        return .just(.setUserNicknameIsDuplicate)
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNickNameDuplicate = false
        
        switch mutation {
        case .setUserNickname(let nickname): // nickname validation
            state.nickname = limitedLengthNickname(nickname ?? "")
            if let nickname = nickname {
                if nickname == "" {
                    state.nextButtonEnabled = false
                    state.isNickNameValidate = false
                }
                
                do {
                    let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣]{2,10}$")
                    let range = NSRange(location: 0, length: nickname.utf16.count)
                    state.nextButtonEnabled = regex.firstMatch(in: nickname, range: range) != nil
                } catch let error {
                    print("Invalid regex", error)
                }
            } else {
                state.nextButtonEnabled = false
            }
            
            if let nickname = nickname {
                if nickname.count == 0 {
                    state.isNickNameValidate = false
                } else {
                    do {
                        let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣]{2,10}$")
                        let range = NSRange(location: 0, length: nickname.utf16.count)
                        state.isNickNameValidate = regex.firstMatch(in: nickname, range: range) == nil
                    } catch let error {
                        print("Invalid regex", error)
                    }
                }
            } else {
                state.isNickNameValidate = true
            }
        case .setProfileImageURL(let url):
            state.profileImageURL = url
        case .setProfileImageData(let data):
            state.profileImageData = data
            state.showActionSheet = false
        case .setUserNicknameIsDuplicate:
            state.isNickNameDuplicate = true
        }
        
        return state
    }
    
    private func limitedLengthNickname(_ str: String) -> String { // 최대 10글자 까지
        if str.count > 10 {
            let index = str.index(str.startIndex, offsetBy: 10)
            return String(str[..<index])
        } else {
            return str
        }
    }
}
