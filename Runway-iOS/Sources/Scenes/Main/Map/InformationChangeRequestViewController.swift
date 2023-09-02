//
//  InformationChangeRequestViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/22.
//

import UIKit
import ReactorKit

final class InformationChangeRequestViewController: BaseViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.textColor = .runwayBlack
        label.text = "어떤 정보가 올바르지 않나요?"
        return label
    }()
    
    private let addressButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setImage(UIImage(named: "checkbox_on"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "주소가 올바르지 않아요", attributes: [.font: UIFont.body1]), for: .normal)
        button.setInsets(forContentPadding: .zero, imageTitlePadding: 12)
        return button
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setImage(UIImage(named: "checkbox_on"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "영업 시간이 올바르지 않아요", attributes: [.font: UIFont.body1]), for: .normal)
        button.setInsets(forContentPadding: .zero, imageTitlePadding: 12)
        return button
    }()
    
    private let phoneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setImage(UIImage(named: "checkbox_on"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "전화번호가 올바르지 않아요", attributes: [.font: UIFont.body1]), for: .normal)
        button.setInsets(forContentPadding: .zero, imageTitlePadding: 12)
        return button
    }()
    
    private let instagramButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setImage(UIImage(named: "checkbox_on"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "인스타그램이 연결되지 않아요", attributes: [.font: UIFont.body1]), for: .normal)
        button.setInsets(forContentPadding: .zero, imageTitlePadding: 12)
        return button
    }()
    
    private let homepageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setImage(UIImage(named: "checkbox_on"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "홈페이지가 연결되지 않아요", attributes: [.font: UIFont.body1]), for: .normal)
        button.setInsets(forContentPadding: .zero, imageTitlePadding: 12)
        return button
    }()
    
    private let splitter: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let completeButton: RWButton = {
        let button = RWButton()
        button.type = .primary
        button.title = "완료"
        button.imageView?.isUserInteractionEnabled = true
        return button
    }()
    
    
    lazy var buttonStackView = UIStackView(arrangedSubviews: [addressButton, timeButton, phoneButton, instagramButton, homepageButton])
    
    // MARK: - initializer
    
    init(with reactor: InformationChangeRequestReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIfModalPresent()
        setRx()
    }
    
    override func configureUI() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 32
        buttonStackView.alignment = .leading
        
        view.addSubviews([titleLabel, buttonStackView, splitter, completeButton])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        splitter.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setupIfModalPresent() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
    }
    
    private func setRx() {
        addressButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.addressButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        timeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.timeButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        phoneButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.phoneButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        instagramButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.instagramButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        homepageButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.homepageButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
    }
}

extension InformationChangeRequestViewController: View {
    func bind(reactor: InformationChangeRequestReactor) {
        [addressButton, timeButton, phoneButton, instagramButton, homepageButton].enumerated()
            .forEach { (index, button) in
                button.rx.tap
                    .map { Reactor.Action.reasonButtonDidTap(index + 1) }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            }
        
        completeButton.rx.tap
            .map { Reactor.Action.requestButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.needDismiss }
            .filter { $0 }
            .bind(with: self, onNext: {(owner, _) in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
