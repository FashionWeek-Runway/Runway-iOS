//
//  RWColorInputAccessoryView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWColorInputAccessoryView: UIView {
    
    let whiteButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(.white, for: .normal)
        return button
    }()
    
    let blackButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(.runwayBlack, for: .normal)
        return button
    }()
    
    let blueButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(.primary, for: .normal)
        return button
    }()
    
    let greenButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(.point, for: .normal)
        return button
    }()
    
    let yellowButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(UIColor(hex: "#FBFF28"), for: .normal)
        return button
    }()
    
    let redButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(UIColor(hex: "#FC3A56"), for: .normal)
        return button
    }()
    
    let violetButton: RWColorChipButton = {
        let button = RWColorChipButton()
        button.setBackgroundColor(UIColor(hex: "#D700E7"), for: .normal)
        return button
    }()
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        let buttons = [whiteButton, blackButton, blueButton, greenButton, yellowButton, redButton, violetButton]
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
