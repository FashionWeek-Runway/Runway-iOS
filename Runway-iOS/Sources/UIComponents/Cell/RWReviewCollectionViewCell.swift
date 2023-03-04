//
//  RWReviewCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import UIKit

final class RWReviewCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let bottomGradientView = UIView()
    
    private let locationIcon = UIImageView(image: UIImage(named: "location_small"))
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption
        label.textColor = .gray100
        return label
    }()
    
    
    static let identifier = "RWReviewCollectionViewCell"
    
    // MARK: - intializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomGradientView.setGradientBackground(colorTop: .clear, colorBottom: .black)
    }
    
    private func configureUI() {
        addSubviews([imageView, bottomGradientView])
        
        imageView.addSubviews([locationIcon, addressLabel])
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        locationIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(6.5)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIcon.snp.trailing).offset(3)
            $0.bottom.equalToSuperview().offset(5)
        }
    }
}
