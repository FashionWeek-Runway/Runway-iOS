//
//  RWTagCollectionSkeletonViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/12.
//

import UIKit

final class RWTagCollectionSkeletonViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.font = .font(.spoqaHanSansNeoMedium, ofSize: 12)
        view.textColor = .blue600
        view.isSkeletonable = true
        return view
    }()
    
    static let identifier = "RWTagCollectionSkeletonViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
}
