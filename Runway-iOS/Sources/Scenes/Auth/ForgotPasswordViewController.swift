//
//  ForgotPasswordViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

final class ForgotPasswordViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body1
        label.text = "비밀번호 찾기"
        return label
    }()
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "휴대폰 번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let mobileCarrierPicker: RWPicker = RWPicker()
    
    private let phoneNumberTextField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "휴대폰 번호 입력('-'제외)"
        field.textField.keyboardType = .phonePad
        return field
    }()
    
    private let verificationMessageRequestButton: RWButton = {
        let button = RWButton()
        button.title = "인증 문자 요청"
        button.type = .primary
        return button
    }()
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        
        self.navigationBarArea.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        self.view.addSubviews([guideTextLabel, mobileCarrierPicker, phoneNumberTextField, verificationMessageRequestButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mobileCarrierPicker.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(mobileCarrierPicker.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(mobileCarrierPicker)
        }
        
        verificationMessageRequestButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.verificationMessageRequestButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.verificationMessageRequestButton.snp.updateConstraints {
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

}

