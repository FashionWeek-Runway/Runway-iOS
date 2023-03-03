////
////  ShowRoomDetailViewController.swift
////  Runway-iOS
////
////  Created by 김인환 on 2023/02/27.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import ReactorKit
//
//final class ShowRoomDetailViewController: BaseViewController {
//
//    private let scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.showsVerticalScrollIndicator = false
//        view.showsHorizontalScrollIndicator = false
//        return view
//    }()
//
//    private let containerView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    private let topArea: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    private let bookmarkButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
//        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
//        return button
//    }()
//
//    private let shareButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
//        return button
//    }()
//
//    private let imageView: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        return view
//    }()
//
//    private let showRoomTitleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .headline2
//        return label
//    }()
//
//    private let tagCollectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
//        view.register(RWTagCollectionViewCell.self, forCellWithReuseIdentifier: RWTagCollectionViewCell.identifier)
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: 59, height: 24)
//        layout.minimumInteritemSpacing = 8
//        layout.minimumLineSpacing = 8
//        layout.scrollDirection = .horizontal
//        view.showsHorizontalScrollIndicator = false
//        view.collectionViewLayout = layout
//        return view
//    }()
//
//    private let locationIcon = UIImageView(image: UIImage(named: "icon_map_storedetail"))
//    private let locationLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .body2
//        label.numberOfLines = 0
//        return label
//    }()
//    private let copyButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon_copy"), for: .normal)
//        button.imageEdgeInsets.right = 2
//        button.setAttributedTitle(NSAttributedString(string: "복사", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.blue500]), for: .normal)
//        return button
//    }()
//
//    private let timeIcon = UIImageView(image: UIImage(named: "icon_time_storedetail"))
//    private let timeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .body2
//        return label
//    }()
//
//    private let phoneIcon = UIImageView(image: UIImage(named: "icon_call_storedetail"))
//    private let phoneLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .body2
//        return label
//    }()
//
//    private let instagramIcon = UIImageView(image: UIImage(named: "icon_instagram_storedetail"))
//    private let instagramLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .body2
//        return label
//    }()
//
//    private let webIcon = UIImageView(image: UIImage(named: "icon_web_storedetail"))
//    private let webLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .runwayBlack
//        label.font = .body2
//        return label
//    }()
//
//    private let divider: UIView = {
//        let view = UIView()
//        view.backgroundColor = .runwayBlack
//        return view
//    }()
//
//    // MARK: - initializer
//
//    init(with reactor: ShowRoomDetailReactor) {
//        super.init(nibName: nil, bundle: nil)
//        self.reactor = reactor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Life cycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func configureUI() {
//        super.configureUI()
//        backButton.setBackgroundImage(UIImage(named: "icon_tab_back_white"), for: .normal)
//
//        view.addSubviews([scrollView, topArea])
//        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        scrollView.addSubview(containerView)
//        containerView.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalToSuperview()
//            $0.width.equalToSuperview()
//            $0.height.equalToSuperview().priority(.high)
//        }
//
//        containerView.addSubviews([imageView,
//                                   showRoomTitleLabel, tagCollectionView,
//                                  locationIcon, locationLabel, copyButton,
//                                  timeIcon, timeLabel,
//                                  phoneIcon, phoneLabel,
//                                  instagramIcon, instagramLabel,
//                                  webIcon, webLabel, divider])
//
//        topArea.snp.makeConstraints {
//            $0.top.horizontalEdges.equalToSuperview()
//            $0.height.equalTo(view.getSafeArea().top + 51)
//        }
//
//        topArea.addSubviews([backButton, bookmarkButton, shareButton])
//        backButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.bottom.equalToSuperview().offset(-15)
//        }
//
//        shareButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.bottom.equalToSuperview().offset(-14)
//        }
//
//        bookmarkButton.snp.makeConstraints {
//            $0.trailing.equalTo(shareButton.snp.leading).offset(-14)
//            $0.bottom.equalToSuperview().offset(-14)
//        }
//
//        imageView.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview()
//            $0.top.equalToSuperview()
//            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.75)
//        }
//
//        showRoomTitleLabel.snp.makeConstraints {
//            $0.top.equalTo(imageView.snp.bottom).offset(16)
//            $0.leading.equalToSuperview().offset(20)
//        }
//
//        tagCollectionView.snp.makeConstraints {
//            $0.top.equalTo(showRoomTitleLabel.snp.bottom).offset(8)
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.height.equalTo(24)
//        }
//
//        locationIcon.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.equalTo(tagCollectionView.snp.bottom).offset(17)
//        }
//
//        locationLabel.snp.makeConstraints {
//            $0.leading.equalTo(locationIcon.snp.trailing).offset(8)
//            $0.top.equalTo(tagCollectionView.snp.bottom).offset(16)
//        }
//
//        copyButton.snp.makeConstraints {
//            $0.leading.equalTo(locationLabel.snp.trailing).offset(8)
//            $0.centerY.equalTo(locationIcon.snp.centerY)
//        }
//
//        timeIcon.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.equalTo(locationIcon.snp.bottom).offset(12)
//        }
//
//        timeLabel.snp.makeConstraints {
//            $0.leading.equalTo(timeIcon.snp.trailing).offset(8)
//            $0.top.equalTo(locationLabel.snp.bottom).offset(10)
//        }
//
//        phoneIcon.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.equalTo(timeIcon.snp.bottom).offset(12)
//        }
//
//        phoneLabel.snp.makeConstraints {
//            $0.leading.equalTo(phoneIcon.snp.trailing).offset(8)
//            $0.top.equalTo(timeLabel.snp.bottom).offset(10)
//        }
//
//        instagramIcon.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.equalTo(phoneIcon.snp.bottom).offset(12)
//        }
//
//        instagramLabel.snp.makeConstraints {
//            $0.leading.equalTo(instagramIcon.snp.trailing).offset(8)
//            $0.top.equalTo(phoneLabel.snp.bottom).offset(10)
//        }
//
//        webIcon.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.equalTo(instagramIcon.snp.bottom).offset(12)
//        }
//
//        webLabel.snp.makeConstraints {
//            $0.leading.equalTo(webIcon.snp.trailing).offset(8)
//            $0.top.equalTo(instagramLabel.snp.bottom).offset(10)
//        }
//
//        divider.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview()
//            $0.top.equalTo(webLabel.snp.bottom).offset(16)
//            $0.height.equalTo(2)
//        }
//    }
//}
//
//extension ShowRoomDetailViewController: View {
//    func bind(reactor: ShowRoomDetailReactor) {
//        bindAction(reactor: reactor)
//        bindState(reactor: reactor)
//    }
//
//    private func bindAction(reactor: ShowRoomDetailReactor) {
//        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//    }
//
//    private func bindState(reactor: ShowRoomDetailReactor) {
//
//    }
//}
