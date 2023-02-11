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

final class IdentityVerificationViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "인증번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let guideTextLabel2: UILabel = {
        let label = UILabel()
        let text = "인증문자가 으로 발송되었습니다."
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let verificationNumberInputField: RWTextFieldWithButton = {
        let field = RWTextFieldWithButton()
        field.placeholder = "숫자 6자리 입력"
        field.rightButton.setAttributedTitle(NSAttributedString(string: "재요청", attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.primary]), for: .normal)
        field.textField.keyboardType = .phonePad
        return field
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "인증 확인"
        button.type = .primary
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verificationNumberInputField.startTimer(initialSecond: 180)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        
        self.view.addSubviews([guideTextLabel, guideTextLabel2, verificationNumberInputField, confirmButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
        }
        
        guideTextLabel2.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        verificationNumberInputField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel2.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(10)
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

