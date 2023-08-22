//
//  RWHomeInstagramCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import UIKit
import RxSwift
import RxRelay

final class RWHomeInstagramCollectionViewCell: UICollectionViewCell {
    
    let imageCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWInstagramImageCell.self, forCellWithReuseIdentifier: RWInstagramImageCell.identifier)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth() - 40, height: UIScreen.getDeviceWidth() - 40)
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1B
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .gray500
        return label
    }()
    
    private let imageCountLabel: UIButton = {
        let label = UIButton()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.setInsets(forContentPadding: UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6), imageTitlePadding: .zero)
        return label
    }()
    
    static let identifier = "RWHomeInstagramCollectionViewCell"
    
    var imageURLRelay = PublishRelay<[String]>()
    var disposeBag = DisposeBag()
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubviews([imageCollectionView, imageCountLabel, titleLabel, descriptionLabel])
        imageCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() - 40)
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(14)
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.bottom.equalToSuperview()
        }
    }
    
    private func setRx() {
        imageURLRelay
            .bind(to: imageCollectionView.rx.items(cellIdentifier: RWInstagramImageCell.identifier, cellType: RWInstagramImageCell.self)) { _, item, cell in
                cell.imageView.kf.setImage(with: URL(string: item))
            }
            .disposed(by: disposeBag)
    }
}
