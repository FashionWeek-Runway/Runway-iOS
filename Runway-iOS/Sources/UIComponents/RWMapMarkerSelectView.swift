//
//  RWMapMarkerSelectView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import RxSwift
import RxCocoa

final class RWMapMarkerSelectView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.textColor = .runwayBlack
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let tagCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWTagCollectionViewCell.self, forCellWithReuseIdentifier: RWTagCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 59, height: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        view.showsHorizontalScrollIndicator = false
        view.collectionViewLayout = layout
        return view
    }()
    
    let directionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_directions"), for: .normal)
        return button
    }()
    
    let tagRelay = PublishRelay<[String]>()
    
    var storeId: Int? = nil
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView, storeNameLabel, tagCollectionView, directionButton])
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo((UIScreen.getDeviceWidth() - 40))
            $0.height.equalTo((UIScreen.getDeviceWidth() - 40) * 0.65)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        directionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(tagCollectionView)
        }
    }
    
    private func bindCollectionView() {
        tagRelay
            .bind(to: tagCollectionView.rx.items(cellIdentifier: RWTagCollectionViewCell.identifier, cellType: RWTagCollectionViewCell.self)) { indexPath, item, cell in
                cell.setCellLayout(isSkeleton: false)
                cell.label.text = "# " + item
            }
            .disposed(by: disposeBag)
    }
}
