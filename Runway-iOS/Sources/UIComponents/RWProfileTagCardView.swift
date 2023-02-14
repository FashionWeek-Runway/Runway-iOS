//
//  RWProfileTagCardView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import UIKit

final class RWProfileTagCardView: UIView {
    
    private let topArea: UIView = {
        let view = UIView()
        view.backgroundColor = .point
        return view
    }()
    
    let topBlackHole: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_my_point"))
        view.backgroundColor = .primary
        return view
    }()
    
    private let congratulationLabel: UILabel = {
        let label = UILabel()
        label.text = "CONGRATULATION"
        label.font = UIFont.font(.helvetica93ExtendedBlack, ofSize: 17)
        label.textColor = .primary
        return label
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.font = UIFont.font(.spoqaHanSansNeoLight, ofSize: 16)
        label.textColor = .primary
        return label
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.textColor = .primary
        return label
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let styleLabel: UILabel = {
        let label = UILabel()
        label.text = "STYLE"
        label.font = UIFont.font(.spoqaHanSansNeoLight, ofSize: 16)
        label.textColor = .primary
        return label
    }()
    
    private let divider3: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()
    
    private let bardCodeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "barcode"))
        return view
    }()
    
    // MARK: - Properties

    var styles: [String] = []
    
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        
        self.addSubviews([topArea, congratulationLabel,
                          divider1,
                         nameLabel, nicknameLabel,
                          divider2,
                         styleLabel,
                         divider3,
                         bardCodeImageView])
        self.snp.makeConstraints {
            $0.width.equalTo(256)
            $0.height.equalTo(426)
        }
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        topArea.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(174)
        }
        topArea.addSubviews([imageView, topBlackHole])
        
        topArea.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(174)
        }
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.width.equalTo(174)
        }
        
        topBlackHole.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        congratulationLabel.snp.makeConstraints {
            $0.top.equalTo(topArea.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        divider1.snp.makeConstraints {
            $0.top.equalTo(self.congratulationLabel.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(18)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        divider2.snp.makeConstraints {
            $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        styleLabel.snp.makeConstraints {
            $0.top.equalTo(self.divider2.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(18)
        }
        
        divider3.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-55)
            $0.height.equalTo(1)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
        }
        
        bardCodeImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.centerX.equalToSuperview()
        }
    }
}
