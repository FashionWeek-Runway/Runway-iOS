//
//  RWMapSearchView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/25.
//

import UIKit

import RxSwift
import RxCocoa

final class RWMapSearchView: UIView {
    
    let navigationBarArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        return button
    }()
    
    let searchField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.attributedPlaceholder = NSAttributedString(string: "지역, 매장명 검색", attributes: [.font: UIFont.body1, .foregroundColor: UIColor.gray300])
        return field
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let emptyImageView = UIImageView(image: UIImage(named: "icon_search_map"))
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "지역이나 매장을 검색하여\n원하는 매장을 찾으세요."
        label.numberOfLines = 0
        label.font = .body1
        label.textColor = .runwayBlack
        label.textAlignment = .center
        return label
    }()
    
    private let latestLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.font = .body2M
        label.textColor = .gray600
        label.isHidden = true
        return label
    }()
    
    private let historyClearButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체 삭제", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 12.0), .foregroundColor: UIColor.gray700]), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let historyTableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.register(RWMapSearchHistoryTableViewCell.self, forCellReuseIdentifier: RWMapSearchHistoryTableViewCell.identifier)
        view.isHidden = true
        return view
    }()
    
    private let searchTableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.register(RWMapSearchTableViewCell.self, forCellReuseIdentifier: RWMapSearchTableViewCell.identifier)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([navigationBarArea,
                          emptyImageView, emptyLabel,
                          latestLabel, historyClearButton, historyTableView, searchTableView])
        self.backgroundColor = .white
        
        self.navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(getSafeArea().top)
            $0.height.equalTo(51)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.navigationBarArea.addSubviews([backButton, searchField, divider])
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.width.equalTo(24)
        }
        
        searchField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        latestLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(divider.snp.bottom).offset(30)
        }
        
        historyClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(latestLabel.snp.centerY)
        }
        
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(latestLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
    }
}
