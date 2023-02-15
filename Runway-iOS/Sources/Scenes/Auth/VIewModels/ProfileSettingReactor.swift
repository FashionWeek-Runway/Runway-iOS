//
//  ProfileSettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit
import Kingfisher

final class ProfileSettingReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case profileImageButtonDidTap
        case enterNickname(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setProfileImageData(Data?)
        case setNickname(String?)
    }
    
    struct State {
        var profileImageURL: String?
        var kakaoID: String?
        
        var nickname: String?
        var profileImageData: Data?
        var nextButtonEnabled: Bool = false
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()

    // MARK: - initializer
    
    init(provider: ServiceProviderType, _ profileImageURL: String?, _ kakaoID: String?) {
        let state = State(profileImageURL: profileImageURL,
                          kakaoID: kakaoID)
        self.initialState = state
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            guard let urlString = initialState.profileImageURL, let url = URL(string: urlString) else { return .empty() }
            let imageLoadMutation = URLSession.shared.rx.data(request: URLRequest(url: url))
                .map { data in
                return Mutation.setProfileImageData(data)
            }
            
            return imageLoadMutation
        case .profileImageButtonDidTap:
            steps.accept(AppStep.actionSheet("사진 촬영", "사진 가져오기"))
            return .empty()
        case .enterNickname(let nickname):
            return .just(.setNickname(nickname))
        case .nextButtonDidTap:
            guard let imageData = currentState.profileImageData,
                  let nickname = currentState.nickname else { return .empty() }
            
            steps.accept(AppStep.categorySettingIsRequired(profileImageURL: currentState.profileImageURL,
                                                           profileImageData: imageData,
                                                           socialID: currentState.kakaoID,
                                                           nickname: nickname))

            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNickname(let nickname): // nickname validation
            state.nickname = limitedLengthNickname(nickname ?? "")
            if let nickname = nickname {
                if nickname == "" {
                    state.nextButtonEnabled = false
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
        case .setProfileImageData(let data):
            state.profileImageData = data
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
