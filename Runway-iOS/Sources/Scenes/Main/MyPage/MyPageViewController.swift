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

import Kingfisher

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
        view.setBackgroundImage(UIImage(named: "icon_profile_my"), for: .normal)
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
        let button = UIButton()
        button.setImage(UIImage(named: "icon_review"), for: .selected)
        button.setImage(UIImage(named: "icon_review_grey"), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "나의 후기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray300]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "나의 후기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.black]), for: .selected)
        button.setBackgroundColor(.clear, for: .normal)
        button.isSelected = true
        button.alignVertical(spacing: 2.0)
        return button
    }()
    
    private let storedTabButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_bookmark_grey"), for: .normal)
        button.setImage(UIImage(named: "icon_bookmark_black"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "저장", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray300]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "저장", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.black]), for: .selected)
        button.setBackgroundColor(.clear, for: .normal)
        button.alignVertical(spacing: 2.0)
        return button
    }()

    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let myReviewBottomLine: UIView = {
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
    
    private let myReviewEmptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_review"))
        view.isHidden = false
        return view
    }()
    private let myReviewEmptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "내 스타일의 매장에 방문하고\n기록해보세요!"
        label.font = .body1
        label.textAlignment = .center
        label.isHidden = false
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
        view.bounces = false
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["매장", "사용자 후기"])
        view.setTitleTextAttributes([.font: UIFont.body2B], for: .selected)
        view.setTitleTextAttributes([.font: UIFont.body2], for: .normal)
        view.selectedSegmentIndex = 0
        view.isHidden = true
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
        view.isHidden = true
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
        view.isHidden = true
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
        myLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-18)
        }
        
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
                                  myReviewTabButton, storedTabButton, divider2, myReviewBottomLine, storedBottomLine, myReviewEmptyImageView, myReviewEmptyLabel, myReviewCollectionView, segmentedControl, storeCollectionView, myReviewCollectionView, userReviewCollectionView])

        
        profileImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(20)
        }
        
        penImageView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageButton.snp.bottom)
            $0.trailing.equalTo(profileImageButton.snp.trailing).offset(6)
        }
        
        helloLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(21)
            $0.top.equalToSuperview().offset(8)
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
        
        divider2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(myReviewTabButton.snp.bottom)
            $0.height.equalTo(1)
        }
        
        myReviewBottomLine.snp.makeConstraints {
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
        
        myReviewEmptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(divider2).offset(85)
        }
        
        myReviewEmptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(myReviewEmptyImageView.snp.bottom).offset(26)
        }
        
        myReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53)
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
        storedTabButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.myReviewTabButton.isSelected = false
                self?.myReviewEmptyLabel.isHidden = true
                self?.myReviewEmptyImageView.isHidden = true
                self?.myReviewCollectionView.isHidden = true
                self?.myReviewBottomLine.isHidden = true
                
                self?.storedTabButton.isSelected = true
                self?.segmentedControl.isHidden = false
                self?.storedBottomLine.isHidden = false
            }).disposed(by: disposeBag)
    }
}

extension MyPageViewController: View {
    func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MyPageReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .map { Reactor.Action.profileImageButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .map { Reactor.Action.settingButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MyPageReactor) {
        reactor.state.compactMap { $0.nickname }
            .bind(onNext: { [weak self] nickname in
                self?.nicknameLabel.text = nickname + "님"
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.myReviewDatas }
            .do(onNext: { [weak self] datas in
                if datas.isEmpty {
                    self?.myReviewCollectionView.isHidden = true
                    self?.myReviewEmptyImageView.isHidden = false
                    self?.myReviewEmptyLabel.isHidden = false
                } else {
                    self?.myReviewCollectionView.snp.updateConstraints {
                        $0.height.equalTo(((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53 * ceil(Double(datas.count) / 3.0))
                    }
                    self?.myReviewCollectionView.isHidden = false
                    self?.myReviewEmptyImageView.isHidden = true
                    self?.myReviewEmptyLabel.isHidden = true
                }
            })
            .bind(to: myReviewCollectionView.rx.items(cellIdentifier: RWReviewCollectionViewCell.identifier, cellType: RWReviewCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.imageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.addressLabel.text = item.regionInfo
            }.disposed(by: disposeBag)
        
    }
}
