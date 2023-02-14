//
//  MainLoginViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit
import ReactorKit
import RxFlow

final class MainLoginViewController: BaseViewController {
    
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        return view
    }()
    
    private let logoTextImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo_text"))
        return view
    }()
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 가입하기"
        label.font = .body1
        label.textColor = .white
        return label
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "kakao_button"), for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "apple_button"), for: .normal)
        return button
    }()
    
    private let phoneLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "phone_button"), for: .normal)
        return button
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    // MARK: - initializer
    
    init(with reactor: MainLoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.backgroundColor = .runwayBlack
        
        self.view.addSubviews([logoImageView, logoTextImageView, guideTextLabel])
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(-4)
        }
        
        logoTextImageView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        guideTextLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-173)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [kakaoLoginButton, appleLoginButton, phoneLoginButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        self.view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(20)
        }
    }
}

extension MainLoginViewController: View {
    func bind(reactor: MainLoginReactor) {
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneLoginButton.rx.tap
            .map { Reactor.Action.phoneLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
