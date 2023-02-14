//
//  ProfileSettingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

final class ProfileSettingViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "프로필을 설정해주세요."
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.subheadline1])
        attributedString.addAttribute(.font, value: UIFont.headline3, range: (text as NSString).range(of: "프로필"))
        label.attributedText = attributedString
        return label
    }()
    
    private let profileSettingView: RWProfileSettingButton = RWProfileSettingButton()
    
    private let nickNameField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "닉네임 입력"
        return field
    }()
    
    private let nextButton: RWButton = {
        let button = RWButton()
        button.title = "다음"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    // MARK: - initializer
    
    init(with reactor: ProfileSettingReactor) {
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
        self.progressBar.setProgress(0.83, animated: false)
        
        self.view.addSubviews([guideTextLabel, profileSettingView, nickNameField, nextButton])
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        profileSettingView.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        nickNameField.snp.makeConstraints {
            $0.top.equalTo(profileSettingView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.nextButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                        self.profileSettingView.toSmallScale()
                    } else {
                        self.profileSettingView.toLargeScale()
                        $0.leading.equalToSuperview().offset(20)
                        $0.trailing.equalToSuperview().offset(-20)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileSettingViewController: View {
    func bind(reactor: ProfileSettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileSettingReactor) {
        profileSettingView.rx.tap
            .map { Reactor.Action.profileImageButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nickNameField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.enterNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileSettingReactor) {
        reactor.state.map { $0.profileImageData }
            .compactMap { $0 }
            .map { UIImage(data: $0) }
            .bind(to: profileSettingView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nextButtonEnabled }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
