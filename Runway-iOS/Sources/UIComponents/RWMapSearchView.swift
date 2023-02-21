//
//  RWMapSearchView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/21.
//

import UIKit

final class RWMapSearchView: UIView {

    let searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.gray200.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    let searchField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "지역, 매장명 검색", attributes: [.font: UIFont.body1])
        field.layer.borderWidth = 0
        return field
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        return button
    }()
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
//        setGradientLayer()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.addSubviews([searchView])
        searchView.addSubviews([searchField, searchButton])
        
        searchView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-60)
            $0.height.equalTo(48)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        searchField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.leading)
        }
    }
    
    func setGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.white, UIColor.clear]
//        gradientLayer.locations = [0.932]
        self.layer.addSublayer(gradientLayer)
    }
    
}
