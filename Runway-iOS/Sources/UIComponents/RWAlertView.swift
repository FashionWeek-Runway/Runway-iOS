//
//  RWAlertView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/12.
//

import UIKit


final class RWAlertView: UIView {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body1
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let button: RWButton = {
        let button = RWButton()
        button.type = .primary
        button.title = "확인"
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.addSubviews([textLabel, button])
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}
