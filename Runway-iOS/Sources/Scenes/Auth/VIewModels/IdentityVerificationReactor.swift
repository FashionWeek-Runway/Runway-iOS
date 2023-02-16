//
//  IdentityVerificationReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class IdentityVerificationReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case nameInput(String)
        case isForeignInput(Bool)
        case genderInput(String)
        case birthDayInput(String)
        case mobileCarrierInput(String)
        case phoneNumberInput(String)
        case requestButtonDidTap
        
        case isDuplicatePhoneNumber
    }
    
    enum Mutation {
        case setName(String)
        case setIsForeign(Bool)
        case setGender(String)
        case setBirthDay(String)
        case setMobileCarrier(String)
        case setPhoneNumber(String)
        case setShouldDuplicateLabel
    }
    
    struct State{
        var name: String? = nil
        var isForeign: Bool = false
        var gender: String? = nil
        var birthDay: String? = nil
        var mobileCarrier: String? = "SKT"
        var phoneNumber: String? = nil
        
        var isMessageRequestEnabled: Bool = false
        
        var shouldShowDuplicateError: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let alertTitle = "만 14세 이상인가요?"
            let description = "RUNWAY는 만 14세 이상 사용 가능합니다.\n해당 데이터는 저장되지 않으며,\n만 14세 이상임을 증명하는데만 사용됩니다."
            let option1 = "네, 만 14세 이상입니다"
            let option2 = "아니요, 만 14세이하입니다"
            steps.accept(AppStep.alert(alertTitle, description, [option1, option2]) { [weak self] action in
                switch action.title {
                case option1:
                    self?.steps.accept(AppStep.dismiss)
                case option2:
                    let title = "만 14세 이상 사용 가능합니다"
                    let desc = "죄송합니다. RUNWAY는 만 14세 이상 사용\n가능합니다. 우리 나중에 다시 만나요:)"
                    let action = "안녕, 또 만나요!"
                    self?.steps.accept(AppStep.alert(title, desc, [action], { _ in
                        self?.steps.accept(AppStep.dismiss)
                        self?.steps.accept(AppStep.loginRequired)
                    }))
                default:
                    break
                }
            })
            return .empty()
        case .backButtonDidTap:
            steps.accept(AppStep.back)
            return .empty()
        case .nameInput(let name):
            return .just(.setName(name))
        case .isForeignInput(let isForeign):
            return .just(.setIsForeign(isForeign))
        case .genderInput(let gender):
            return .just(.setGender(gender))
        case .birthDayInput(let birthDay):
            return .just(.setBirthDay(birthDay))
        case .mobileCarrierInput(let mobileCarrier):
            return .just(.setMobileCarrier(mobileCarrier))
        case .phoneNumberInput(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
        case .isDuplicatePhoneNumber:
            return .just(.setShouldDuplicateLabel)
        case .requestButtonDidTap:
            guard let phoneNumber = currentState.phoneNumber else { return .empty() }
            
            provider.signUpService.checkPhoneNumberDuplicate(phoneNumber: phoneNumber).responseData()
                .subscribe(onNext: { [weak self] response, data in
                    
                    if response.statusCode >= 400 {
                        self?.action.onNext(.isDuplicatePhoneNumber)
                    } else {
                        guard let gender = self?.currentState.gender,
                              let name = self?.currentState.name,
                              let phone = self?.currentState.phoneNumber else { return }
                        self?.steps.accept(AppStep.phoneCertificationNumberIsRequired(gender: gender,
                                                                                      name: name,
                                                                                      phoneNumber: phone))
                    }
            }).disposed(by: disposeBag)
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.shouldShowDuplicateError = false
        switch mutation {
        case .setName(let name):
            state.name = name
        case .setIsForeign(let isForeign):
            state.isForeign = isForeign
        case .setGender(let gender):
            state.gender = state.gender != gender ? gender : nil
        case .setBirthDay(let birthDay):
            state.birthDay = limitedLengthString(birthDay, length: 8)
        case .setMobileCarrier(let mobileCarrier):
            state.mobileCarrier = mobileCarrier
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = limitedLengthString(phoneNumber, length: 11)
        case .setShouldDuplicateLabel:
            state.shouldShowDuplicateError = true
        }
        
        state.isMessageRequestEnabled = canRequest()
        return state
    }
    
    private func canRequest() -> Bool {
        guard let name = currentState.name,
              let gender = currentState.gender,
              let birthDay = currentState.birthDay,
              let mobileCarrier = currentState.mobileCarrier,
              let phoneNumber = currentState.phoneNumber else { return false }
        
        if !name.isEmpty
            && !gender.isEmpty
            && birthDay.count == 8
            && !mobileCarrier.isEmpty
            && 8...12 ~= phoneNumber.count {
            return true
        } else {
            return false
        }
    }
    
    private func limitedLengthString(_ str: String, length: Int) -> String { // limit
        if str.count > length {
            let index = str.index(str.startIndex, offsetBy: length)
            return String(str[..<index])
        } else {
            return str
        }
    }
    
    private func checkNumberIsDuplicate() {
        guard let phoneNumber = currentState.phoneNumber else { return }
        provider.signUpService.checkPhoneNumberDuplicate(phoneNumber: phoneNumber).validate(statusCode: 200...299).catch({ error in
            print("error", error)
            return .empty()
        }).data().subscribe(onNext: { [weak self] data in
           
                guard let gender = self?.currentState.gender,
                      let name = self?.currentState.name,
                      let phone = self?.currentState.phoneNumber else { return }
                self?.steps.accept(AppStep.phoneCertificationNumberIsRequired(gender: gender,
                                                                              name: name,
                                                                              phoneNumber: phone))
        }).disposed(by: disposeBag)
    }
    
}
