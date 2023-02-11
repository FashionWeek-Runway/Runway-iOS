//
//  PasswordInputViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

final class PasswordInputViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "새로운 비밀번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let newPasswordField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "새로운 비밀번호 입력"
        field.secureToggleButton.isHidden = false
        field.textField.isSecureTextEntry = true
        field.textField.keyboardType = .asciiCapable
        field.secureToggleButton.isSelected = true
        return field
    }()
    
    private let newPasswordConfirmField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "새로운 비밀번호 확인"
        field.secureToggleButton.isHidden = false
        field.textField.keyboardType = .asciiCapable
        field.textField.isSecureTextEntry = true
        field.secureToggleButton.isSelected = true
        return field
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "비밀번호 변경"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel()
        navigationTitleLabel.text = "비밀번호 찾기"
        
        self.view.addSubviews([guideTextLabel, newPasswordField, newPasswordConfirmField, confirmButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
        }
        
        newPasswordField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newPasswordConfirmField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(newPasswordField.snp.bottom).offset(58)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.confirmButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.confirmButton.snp.updateConstraints {
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


