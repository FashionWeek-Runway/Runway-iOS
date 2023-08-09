//
//  RWMainImageCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/09.
//

import UIKit

final class RWMainStoreImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RWMainStoreImageCollectionViewCell"
    
    let storeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
        addSubview(storeImageView)
        storeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
