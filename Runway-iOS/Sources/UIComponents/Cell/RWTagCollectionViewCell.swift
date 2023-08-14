//
//  RWTagCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import SkeletonView

final class RWTagCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "# 시티보이"
        view.font = .font(.spoqaHanSansNeoMedium, ofSize: 12)
        view.textColor = .blue600
        view.isSkeletonable = true
        view.skeletonTextLineHeight = .relativeToFont
        return view
    }()
    
    static let identifier = "RWTagCollectionViewCell"
    static let skeletonIdentifier = "RWTagCollectionViewCell-skeleton"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        clipsToBounds = true
        isUserInteractionEnabled = false
        isSkeletonable = true
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setCellLayout(isSkeleton: Bool = false) {
        if isSkeleton {
            showAnimatedSkeleton()
        } else {
            backgroundColor = .blue200.withAlphaComponent(0.5)
            layer.borderWidth = 1
            layer.cornerRadius = 4
            layer.borderColor = UIColor.blue200.cgColor
            hideSkeleton()
            
            label.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
