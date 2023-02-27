//
//  RWMapSearchView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/25.
//

import UIKit

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
        return field
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let emptyImage = UIImageView(image: UIImage(named: "logo"))
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없습니다"
        label.font = .body1
        label.textColor = .runwayBlack
        return label
    }()
    
    private let latestLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.font = .body2M
        label.textColor = .gray600
        return label
    }()
    
    private let historyClearButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체 삭제", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 12.0), .foregroundColor: UIColor.gray700]), for: .normal)
        return button
    }()
    
    private let historyTableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        
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
        self.addSubviews([navigationBarArea, backButton, searchField, divider,
                          emptyImage, emptyLabel,
                          latestLabel, historyClearButton, historyTableView])
        
        self.navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(54).priority(.required)
        }

    }
}
