//
//  InformationChangeRequestViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/22.
//

import UIKit

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
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소가 올바르지 않아요"
        label.font = .body1
        return label
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "영업 시간이 올바르지 않아요"
        label.font = .body1
        return label
    }()
    
    private let phoneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호가 올바르지 않아요"
        label.font = .body1
        return label
    }()
    
    private let instagramButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "인스타그램이 연결되지 않아요"
        label.font = .body1
        return label
    }()
    
    private let homepageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    private let homepageLabel: UILabel = {
        let label = UILabel()
        label.text = "홈페이지가 연결되지 않아요"
        label.font = .body1
        return label
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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIfModalPresent()
    }
    
    override func configureUI() {
        let buttonStackView = UIStackView(arrangedSubviews: [addressButton, timeButton, phoneButton, instagramButton, homepageButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 32
        buttonStackView.alignment = .center
        
        let labelStackView = UIStackView(arrangedSubviews: [addressLabel, timeLabel, phoneLabel, instagramLabel, homepageLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 34
        labelStackView.alignment = .leading
        
        view.addSubviews([titleLabel, buttonStackView, labelStackView, splitter, completeButton])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(buttonStackView.snp.trailing).offset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
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
}
