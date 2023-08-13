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
        view.font = .font(.spoqaHanSansNeoMedium, ofSize: 12)
        view.textColor = .blue600
        view.isSkeletonable = true
        return view
    }()
    
    static let identifier = "RWTagCollectionViewCell"

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
        contentView.isSkeletonable = true
        
        contentView.addSubview(label)
    }
    
    func setCellLayout(isSkeleton: Bool = false) {
        if isSkeleton {
            backgroundColor = .clear
            layer.borderColor = nil
            layer.borderWidth = 0
            layer.cornerRadius = 0
            showAnimatedSkeleton()
            label.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            backgroundColor = .blue200.withAlphaComponent(0.5)
            layer.borderWidth = 1
            layer.cornerRadius = 4
            layer.borderColor = UIColor.blue200.cgColor
            hideSkeleton()
            
            label.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        label.snp.removeConstraints()
    }
}
