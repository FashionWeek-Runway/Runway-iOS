//
//  PhoneLoginViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class PhoneLoginViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.headline1
        return label
    }()
    
    private let phoneNumberField: RWTextField = RWTextField()
    private let passwordField: RWTextField = {
        let field = RWTextField()
        field.secureToggleButton.isHidden = false
        return field
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: "비밀번호 찾기", attributes: [.font: UIFont.body2M]), for: .normal)
        return button
    }()
    
    private let loginButton: RWButton = {
        let button = RWButton()
        button.title = "로그인"
        button.type = .primary
        return button
    }()
    
    private let signUpButton: RWButton = {
        let button = RWButton()
        button.title = "회원가입"
        button.type = .secondary
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        
        self.view.addSubviews([loginLabel, phoneNumberField, passwordField, forgotPasswordButton, loginButton, signUpButton])
        
        loginLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(50)
        }
        
        phoneNumberField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberField.snp.bottom).offset(28)
            $0.leading.trailing.equalTo(phoneNumberField)
        }
        
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(21)
            $0.trailing.equalToSuperview().offset(-19)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-23)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-70)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-23)
            $0.centerX.equalToSuperview()
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -70
                self.loginButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.loginButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                    } else {
                        $0.leading.equalToSuperview().offset(17)
                        $0.trailing.equalToSuperview().offset(-23)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
}
