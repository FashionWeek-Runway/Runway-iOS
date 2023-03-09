//
//  WithdrawalViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import Kingfisher

final class WithdrawalViewController: BaseViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline4
        label.text = "님..정말 탈퇴하시겠어요..?"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "너무 아쉽지만..\n떠나기 전 아래 내용을 확인해주세요.."
        label.numberOfLines = 2
        label.font = .body1
        return label
    }()
    
    private let guideBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let guideTitle1: UILabel = {
        let label = UILabel()
        label.text = "😢 15일 이후 처음부터 다시 가입해야해요"
        label.font = .body2B
        return label
    }()
    
    private let guideCaption1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "탈퇴 회원의 정보는 15일간 임시 보관 후 완벽히 삭제됩니다. 탈퇴하시면 회원가입부터 다시 해야해요."
        label.font = .body2
        label.textColor = .gray800
        return label
    }()
    
    private let guideTitle2: UILabel = {
        let label = UILabel()
        label.text = "🗑 작성한 후기가 사라져요"
        label.font = .body2B
        return label
    }()
    
    private let guideCaption2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "회원님이 작성한 후기들이 영구적으로 삭제됩니다.\n삭제된 정보는 다시 복구할 수 없어요."
        label.font = .body2
        label.textColor = .gray800
        return label
    }()
    
    private let agreeCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "위의 내용을 모두 확인하였으며, 탈퇴하겠습니다."
        label.font = .body2
        label.textColor = .gray900
        return label
    }()
    
    private let withdrawalButton: RWButton = {
        let button = RWButton()
        button.type = .secondary
        button.title = "탈퇴하기"
        button.isEnabled = false
        return button
    }()
    

    // MARK: - initializer
    
    init(with reactor: WithdrawalReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel("회원 탈퇴")
        
        view.addSubviews([titleLabel, descriptionLabel, guideBackgroundView, agreeCheckBox, agreeLabel, withdrawalButton])
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        guideBackgroundView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        agreeCheckBox.snp.makeConstraints {
            $0.top.equalTo(guideBackgroundView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        agreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(agreeCheckBox.snp.centerY)
            $0.leading.equalTo(agreeCheckBox.snp.trailing).offset(4)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom - 10)
            $0.height.equalTo(50)
        }
        
        guideBackgroundView.addSubviews([guideTitle1, guideCaption1, guideTitle2, guideCaption2])
        guideTitle1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(14)
        }
        
        guideCaption1.snp.makeConstraints {
            $0.top.equalTo(guideTitle1.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        }
        
        guideTitle2.snp.makeConstraints {
            $0.top.equalTo(guideCaption1.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(14)
        }
        
        guideCaption2.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.top.equalTo(guideTitle2.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-18)
        }
    
    }
    
    private func setRx() {

    }
}

extension WithdrawalViewController: View {
    func bind(reactor: WithdrawalReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: WithdrawalReactor) {

    }
    
    private func bindState(reactor: WithdrawalReactor) {

        
    }
}
