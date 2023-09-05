//
//  AllStoreViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import Kingfisher

import SkeletonView
import FirebaseAnalytics

final class AllStoreViewController: BaseViewController {
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWAllStoreCollectionViewCell.self, forCellWithReuseIdentifier: RWAllStoreCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 2.0) / 2.0,
                                 height: ((UIScreen.getDeviceWidth() - 2.0) / 2.0 * 1.32))
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        view.collectionViewLayout = layout
        return view
    }()
    
    // MARK: - Skeleton Views
    
    private lazy var skeletonCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWAllStoreCollectionViewCell.self, forCellWithReuseIdentifier: RWAllStoreCollectionViewCell.skeletonIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 2.0) / 2.0,
                                 height: ((UIScreen.getDeviceWidth() - 2.0) / 2.0 * 1.32))
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        view.collectionViewLayout = layout
        view.dataSource = self
        return view
    }()
    
    // MARK: - initializer
    
    init(with reactor: AllStoreReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(Tracking.Event.lookup.rawValue, parameters: [
            "screen_name": Tracking.Screen.home_total.rawValue
        ])
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel("취향을 가득 담은 매장")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        configureSkeletonUI()
    }
    
    private func configureSkeletonUI() {
        view.addSubview(skeletonCollectionView)
        skeletonCollectionView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
    }
}

extension AllStoreViewController: View {
    func bind(reactor: AllStoreReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AllStoreReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HomeStoreResponseResult.self)
            .map { Reactor.Action.selectStoreCell($0.storeID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(reactor: AllStoreReactor) {
        reactor.state.map { $0.storeDatas }
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.skeletonCollectionView.hideSkeleton()
                self?.skeletonCollectionView.isHidden = true
            })
            .bind(to: collectionView.rx.items(cellIdentifier: RWAllStoreCollectionViewCell.identifier, cellType: RWAllStoreCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.imageURL) else { return }
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: url)
                cell.storeNameLabel.text = item.storeName
                cell.locationLabel.setAttributedTitle(NSAttributedString(string: item.regionInfo,
                                                                         attributes: [.foregroundColor: UIColor.gray50, .font: UIFont.caption]), for: .normal)
                
                cell.bookmarkButton.isSelected = item.isBookmarked
                
                let categories = item.categoryList.compactMap { $0 }
                
                if categories.count > 3 {
                    for i in 0...2 {
                        let label = UILabel()
                        label.text = "# " + categories[i]
                        label.font = .caption2
                        label.textColor = .gray50
                        cell.tagStackView.addArrangedSubview(label)
                    }
                    let restCount = categories.count - 3
                    let restLabel = UILabel()
                    restLabel.text = "+\(restCount)"
                    restLabel.font = .caption2
                    restLabel.textColor = .gray50
                    cell.tagStackView.addArrangedSubview(restLabel)
                    
                } else {
                    categories.forEach {
                        let label = UILabel()
                        label.text = "# " + $0
                        label.font = .caption2
                        label.textColor = .gray50
                        cell.tagStackView.addArrangedSubview(label)
                    }
                }
                
                cell.bookmarkButton.rx.tap
                    .asDriver()
                    .drive(onNext: {
                        cell.bookmarkButton.isSelected.toggle()
                        reactor.action.onNext(Reactor.Action.bookmarkButtonDidTap(item.storeID))
                    }).disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
    }
}

extension AllStoreViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return RWAllStoreCollectionViewCell.skeletonIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RWAllStoreCollectionViewCell.skeletonIdentifier, for: indexPath) as? RWAllStoreCollectionViewCell else { return UICollectionViewCell() }
        cell.showAnimatedSkeleton()
        return cell
    }
}
