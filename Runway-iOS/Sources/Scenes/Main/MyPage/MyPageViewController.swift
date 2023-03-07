//
//  MyPageViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class MyPageViewController: BaseViewController {
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.text = "MY"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let containerView = UIView()
    
    private let profileImageButton: UIButton = {
        let view = UIButton()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    private let penImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_pencil"))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        label.font = .headline4M
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let myReviewTabButton: UIButton = {
        let view = UIButton()
        view.setBackgroundColor(.clear, for: .normal)
        return view
    }()
    
    private let myReviewImageView = UIImageView(image: UIImage(named: "icon_review"))
    private let myReviewTabLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 후기"
        label.textColor = .runwayBlack
        label.font = .body2
        return label
    }()
    
    private let storedTabButton: UIButton = {
        let view = UIButton()
        view.setBackgroundColor(.clear, for: .normal)
        return view
    }()
    
    private let storedImageView = UIImageView(image: UIImage(named: "icon_bookmark_grey"))
    private let storedTabLabel: UILabel = {
        let label = UILabel()
        label.text = "저장"
        label.textColor = .gray300
        label.font = .body2
        return label
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let reviewBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        return view
    }()
    
    private let storedBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        view.isHidden = true
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "AppIcon"))
        view.isHidden = true
        return view
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "내 스타일의 매장에 방문하고\n기록해보세요!"
        label.font = .body1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let myReviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWReviewCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 6.0) / 3.0,
                                 height: ((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        view.collectionViewLayout = layout
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["매장", "사용자 후기"])
        view.setTitleTextAttributes([.font: UIFont.body2B], for: .selected)
        view.setTitleTextAttributes([.font: UIFont.body2], for: .normal)
        return view
    }()
    
    private let storeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        view.showsVerticalScrollIndicator = false
        view.collectionViewLayout = layout
        view.bounces = false
        view.register(RWAroundCollectionViewCell.self, forCellWithReuseIdentifier: RWAroundCollectionViewCell.identifier)
        return view
    }()
    
    private let userReviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWReviewCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 6.0) / 3.0,
                                 height: ((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        view.collectionViewLayout = layout
        return view
    }()
    
    
    // MARK: - initializer
    
    init(with reactor: MyPageReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        navigationBarArea.addSubviews([myLabel, settingButton])
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(navigationBarArea.snp.bottom)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.centerX.verticalEdges.equalToSuperview()
        }
        
        containerView.addSubviews([profileImageButton, penImageView, helloLabel, nicknameLabel, divider,
                                  myReviewTabButton, storedTabButton, divider2, reviewBottomLine, storedBottomLine, emptyImageView, emptyLabel, myReviewCollectionView, segmentedControl, storeCollectionView, myReviewCollectionView, userReviewCollectionView])
        myReviewTabButton.addSubviews([myReviewImageView, myReviewTabLabel])
        storedTabButton.addSubviews([storedImageView, storedTabLabel])
        
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(view.getSafeArea().top).offset(53)
            $0.leading.equalToSuperview().offset(20)
        }
        
        penImageView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageButton.snp.bottom)
            $0.trailing.equalTo(profileImageButton.snp.trailing).offset(6)
        }
        
        helloLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(21)
            $0.top.equalTo(view.getSafeArea().top).offset(59)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(1)
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(21)
        }
        
        divider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(29)
        }
        
        myReviewTabButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(65)
        }
        
        storedTabButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(65)
        }
        
        myReviewImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        myReviewTabLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(myReviewImageView.snp.bottom).offset(2)
        }
        
        storedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        storedTabLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(myReviewImageView.snp.bottom).offset(2)
        }
        
        divider2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(myReviewTabButton.snp.bottom)
            $0.height.equalTo(1)
        }
        
        reviewBottomLine.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalToSuperview().dividedBy(2)
            $0.bottom.equalTo(divider2.snp.top)
        }
        
        storedBottomLine.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalToSuperview().dividedBy(2)
            $0.bottom.equalTo(divider2.snp.top)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(divider2).offset(85)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(26)
        }
        
        myReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(67)
            $0.trailing.equalToSuperview().offset(-73)
            $0.top.equalTo(divider2.snp.bottom).offset(10)
            $0.height.equalTo(36)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        userReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    
    }
    
    private func setRx() {
        
    }
}

extension MyPageViewController: View {
    func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MyPageReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .map { Reactor.Action.profileImageButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MyPageReactor) {
        
    }
}
