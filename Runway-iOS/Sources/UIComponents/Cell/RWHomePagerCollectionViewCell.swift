//
//  RWHomePagerCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import UIKit

import RxSwift
import RxCocoa

final class RWHomePagerCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let clothesTagView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.7
        view.backgroundColor = .clear
        return view
    }()
    
    private let topCircleHole: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
        return button
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let centerPointLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .point
        return view
    }()
    
    let addressLabel: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.primary, for: .normal)
        button.setImage(UIImage(named: "icon_location_small"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        button.isUserInteractionEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        return button
    }()
    
    let categoryTagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.backgroundColor = .primary
        return stackView
    }()
    
    private let barcodeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "barcode_white"))
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    static let identifier = "RWHomePagerCollectionViewCell"
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.addSubview(clothesTagView)
        clothesTagView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(140)
            $0.trailing.equalToSuperview().offset(-38)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        clothesTagView.addSubviews([topCircleHole, topCircleHole, bookmarkButton, storeNameLabel, centerPointLineView, addressLabel, categoryTagStackView, barcodeImageView])
        topCircleHole.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.trailing.equalToSuperview().offset(-11)
        }
        
        barcodeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        categoryTagStackView.snp.makeConstraints {
            $0.bottom.equalTo(barcodeImageView.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(categoryTagStackView.snp.top)
        }
        
        centerPointLineView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addressLabel.snp.top).offset(-12)
            $0.height.equalTo(2)
            $0.width.equalTo(28)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(centerPointLineView.snp.top).offset(-8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.categoryTagStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
