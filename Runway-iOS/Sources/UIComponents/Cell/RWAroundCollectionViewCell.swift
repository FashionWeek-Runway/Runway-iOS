//
//  RWAroundCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/24.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

final class RWAroundCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isSkeletonable = true
        return view
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "무신사 스탠다드 - 성수"
        label.font = .headline4
        label.textColor = .runwayBlack
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .relativeToFont
        return label
    }()
    
    let tagCollectionView: UICollectionView = {
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
    
    lazy var skeletonTagCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWTagCollectionViewCell.self, forCellWithReuseIdentifier: RWTagCollectionViewCell.skeletonIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 59, height: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        view.showsHorizontalScrollIndicator = false
        view.collectionViewLayout = layout
        view.dataSource = self
        return view
    }()
    
    var numberOfSkeletonTagViews: Int = 4
    
    static let identifier = "RWAroundCollectionViewCell"
    
    let tagRelay = PublishRelay<[String]>()
    
    private var disposeBag = DisposeBag()
    
    var storeId: Int? = nil
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        isSkeletonable = true
        contentView.addSubviews([imageView, storeNameLabel, tagCollectionView, skeletonTagCollectionView])
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth() - 40)
            $0.height.equalTo((UIScreen.getDeviceWidth() - 40) * 0.75)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24) // TODO: - 추후 2줄 변경 가능성
            $0.bottom.equalToSuperview()
        }
        
        skeletonTagCollectionView.snp.makeConstraints {
            $0.edges.equalTo(tagCollectionView)
        }
    }
    
    private func bindCollectionView() {
        tagRelay
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.skeletonTagCollectionView.hideSkeleton()
                self?.skeletonTagCollectionView.isHidden = true
            })
            .bind(to: tagCollectionView.rx.items(cellIdentifier: RWTagCollectionViewCell.identifier, cellType: RWTagCollectionViewCell.self)) { indexPath, item, cell in
                cell.label.text = "# " + item
            }
            .disposed(by: disposeBag)
    }
}

extension RWAroundCollectionViewCell: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return RWTagCollectionViewCell.skeletonIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSkeletonTagViews
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWTagCollectionViewCell.skeletonIdentifier, for: indexPath) as? RWTagCollectionViewCell else { return UICollectionViewCell() }
        cell.setCellLayout(isSkeleton: true)
        return cell
    }
}
