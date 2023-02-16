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

final class ProfileSettingReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case profileImageButtonDidTap
        case setImage(Data?)
        case enterNickname(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case showActionSheet
        case setProfileImageData(Data?)
        case setNickname(String?)
    }
    
    struct State {
        var profileImageURL: String?
        var kakaoID: String?
        
        var showActionSheet: Bool = false
        
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
            if let urlString = initialState.profileImageURL, // 이미지 URL이 있는 경우
               let url = URL(string: urlString) {
                let imageLoadMutation = URLSession.shared.rx.data(request: URLRequest(url: url))
                    .map { data in
                        return Mutation.setProfileImageData(data)
                    }
                return imageLoadMutation
            } else { // 이미지 URL이 없는 경우(기본이미지)
                do {
                    if let imagePath = Bundle.main.path(forResource: "icon_my_large", ofType: "png") {
                        let imageData = try Data(contentsOf: URL(fileURLWithPath: imagePath))
                        // Use imageData as needed
                        return .just(Mutation.setProfileImageData(imageData))
                    } else {
                        // Image not found in bundle
                        return .empty()
                    }
                } catch {
                    return .empty()
                }
            }
        case .backButtonDidTap:
            steps.accept(AppStep.back)
            return .empty()
        case .profileImageButtonDidTap:
            return .just(.showActionSheet)
        case .setImage(let data):
            return .just(.setProfileImageData(data))
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
        case .showActionSheet:
            state.showActionSheet = true
        case .setProfileImageData(let data):
            state.profileImageData = data
            state.showActionSheet = false
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
