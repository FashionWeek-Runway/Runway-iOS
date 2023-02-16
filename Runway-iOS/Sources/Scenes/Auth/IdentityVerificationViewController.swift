//
//  IdentityVerificationViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import RxFlow
import ReactorKit

final class IdentityVerificationViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "본인 인증이 필요해요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "이 필요해요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let nameCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .caption
        return label
    }()
    
    private let nameField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "이름"
        return field
    }()
    
    private let foreignPicker: RWPicker = {
        let picker = RWPicker()
        picker.pickerData = ["내국인", "외국인"]
        return picker
    }()
    
    private let genderCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = .caption
        return label
    }()
    
    private let genderRadioSelector: RWRadioSelectorView = RWRadioSelectorView("남", "여")
    
    private let birthDayCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = .caption
        return label
    }()
    
    private let birthDayField: RWTextField = {
        let field = RWTextField()
        field.textField.keyboardType = .numberPad
        field.placeholder = "19990101"
        return field
    }()
    
    private let PhoneVerificationCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대폰 인증"
        label.font = .caption
        return label
    }()
    
    private let mobileCarrierPicker: RWPicker = {
        let picker = RWPicker()
        picker.pickerData = ["SKT", "KT", "LG U+", "SKT 알뜰폰", "KT 알뜰폰", "LG U+ 알뜰폰"]
        return picker
    }()
    
    private let phoneNumberField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "휴대폰 번호 입력(‘-’ 제외)"
        field.errorText = "이미 가입된 번호입니다."
        field.textField.keyboardType = .numberPad
        return field
    }()
    
    private let requestButton: RWButton = {
        let button = RWButton()
        button.title = "인증 문자 요청"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: IdentityVerificationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addProgressBar()
        self.progressBar.setProgress(0.166, animated: false)
        
        self.view.addSubviews([requestButton])
        self.keyboardSafeAreaView.addSubviews([guideTextLabel,
                                               nameCaptionLabel, nameField, foreignPicker,
                                               genderCaptionLabel, genderRadioSelector,
                                              birthDayCaptionLabel, birthDayField,
                                              PhoneVerificationCaptionLabel, mobileCarrierPicker, phoneNumberField])
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(154)
//            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(28)
        }
        
        nameCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        nameField.snp.makeConstraints {
            $0.top.equalTo(nameCaptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(186)
        }
        
        foreignPicker.snp.makeConstraints {
            $0.top.equalTo(nameCaptionLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalTo(nameField.snp.trailing).offset(14)
        }
        
        genderCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        genderRadioSelector.snp.makeConstraints {
            $0.top.equalTo(genderCaptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        birthDayCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(genderRadioSelector.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        birthDayField.snp.makeConstraints {
            $0.top.equalTo(birthDayCaptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        PhoneVerificationCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(birthDayField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        mobileCarrierPicker.snp.makeConstraints {
            $0.top.equalTo(PhoneVerificationCaptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        phoneNumberField.snp.makeConstraints {
            $0.top.equalTo(mobileCarrierPicker.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        requestButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.requestButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.requestButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                    } else {
                        $0.leading.equalToSuperview().offset(20)
                        $0.trailing.equalToSuperview().offset(-20)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func setViewFrameWhenKeyboardAppeared() {
        
    }

}

extension IdentityVerificationViewController: View {
    func bind(reactor: IdentityVerificationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: IdentityVerificationReactor) {
        self.rx.viewDidAppear
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameField.textField.rx.value
            .orEmpty
            .compactMap { Reactor.Action.nameInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        genderRadioSelector.selectedOption
            .compactMap  { Reactor.Action.genderInput($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        birthDayField.textField.rx.value
            .orEmpty
            .compactMap  { Reactor.Action.birthDayInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mobileCarrierPicker.textField.rx.value
            .orEmpty
            .compactMap { Reactor.Action.mobileCarrierInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneNumberField.textField.rx.value
            .orEmpty
            .compactMap { Reactor.Action.phoneNumberInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        requestButton.rx.tap
            .map { Reactor.Action.requestButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: IdentityVerificationReactor) {
        reactor.state.map { $0.birthDay }
            .bind(to: birthDayField.textField.rx.value)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMessageRequestEnabled }
            .bind(to: requestButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldShowDuplicateError }
            .bind(to: phoneNumberField.isError)
            .disposed(by: disposeBag)
    }
}
