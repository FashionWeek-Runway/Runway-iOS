//
//  ShowRoomDetailViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ShowRoomDetailViewController: BaseViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    private let topArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
        return button
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let showRoomTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .headline2
        label.numberOfLines = 0
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

    private let locationIcon = UIImageView(image: UIImage(named: "icon_map_storedetail"))
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        label.numberOfLines = 0
        return label
    }()
    private let copyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_copy"), for: .normal)
        button.imageEdgeInsets.right = 2
        button.setAttributedTitle(NSAttributedString(string: "복사", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.blue500]), for: .normal)
        return button
    }()

    private let timeIcon = UIImageView(image: UIImage(named: "icon_time_storedetail"))
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        label.numberOfLines = 0
        return label
    }()

    private let phoneIcon = UIImageView(image: UIImage(named: "icon_call_storedetail"))
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        return label
    }()

    private let instagramIcon = UIImageView(image: UIImage(named: "icon_instagram_storedetail"))
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        return label
    }()

    private let webIcon = UIImageView(image: UIImage(named: "icon_web_storedetail"))
    private let webLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        return view
    }()

    private let userReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 후기"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()

    private let reviewRegisterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: "후기 작성", attributes: [.font: UIFont.body1M,
                                                                                   .foregroundColor: UIColor.primary]), for: .normal)
        button.setImage(UIImage(named: "icon_camera"), for: .normal)
        button.imageEdgeInsets.right = 2
    }()

    private let reviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWUserReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWUserReviewCollectionViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 6
        layout.itemSize = CGSize(width: 132, height: 200)
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
        return view
    }()

    private let divider2: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray50.cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = .gray100
        return view
    }()

    private let blogReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "블로그 후기"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()

    private let blogReviewTableView: RWContentSizedTableView = {
        let view = RWContentSizedTableView()
        view.register(RWStoreBlogReviewTableViewCell.self, forCellReuseIdentifier: RWStoreBlogReviewTableViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.rowHeight = 136
        return view
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "더보기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray900]), for: .normal)
        button.setImage(UIImage(named: "icon_down_black"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets.left = 10
        return button
    }()

    // MARK: - initializer

    init(with reactor: ShowRoomDetailReactor) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func configureUI() {
        super.configureUI()
        backButton.setBackgroundImage(UIImage(named: "icon_tab_back_white"), for: .normal)

        view.addSubviews([scrollView, topArea])
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.high)
        }

        containerView.addSubviews([imageView,
                                   showRoomTitleLabel, tagCollectionView,
                                  locationIcon, addressLabel, copyButton,
                                  timeIcon, timeLabel,
                                  phoneIcon, phoneLabel,
                                  instagramIcon, instagramLabel,
                                  webIcon, webLabel, divider,
                                  userReviewLabel, reviewRegisterButton, reviewCollectionView,
                                  divider2, blogReviewLabel, blogReviewTableView, moreButton
                                  ])

        topArea.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 51)
        }

        topArea.addSubviews([backButton, bookmarkButton, shareButton])
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }

        shareButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-14)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalTo(shareButton.snp.leading).offset(-14)
            $0.bottom.equalToSuperview().offset(-14)
        }

        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.75)
        }

        showRoomTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(showRoomTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(24)
        }

        locationIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(17)
        }

        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIcon.snp.trailing).offset(8)
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(16)
        }

        copyButton.snp.makeConstraints {
            $0.leading.equalTo(addressLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(locationIcon.snp.centerY)
        }

        timeIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeIcon.snp.trailing).offset(8)
            $0.top.equalTo(timeIcon.snp.top)
        }

        phoneIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(timeLabel.snp.bottom).offset(11)
        }

        phoneLabel.snp.makeConstraints {
            $0.leading.equalTo(phoneIcon.snp.trailing).offset(8)
            $0.top.equalTo(phoneIcon.snp.bottom).offset(1)
        }

        instagramIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(phoneIcon.snp.bottom).offset(12)
        }

        instagramLabel.snp.makeConstraints {
            $0.leading.equalTo(instagramIcon.snp.trailing).offset(8)
            $0.top.equalTo(phoneLabel.snp.bottom).offset(10)
        }

        webIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(instagramIcon.snp.bottom).offset(12)
        }

        webLabel.snp.makeConstraints {
            $0.leading.equalTo(webIcon.snp.trailing).offset(8)
            $0.top.equalTo(instagramLabel.snp.bottom).offset(10)
        }

        divider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(webLabel.snp.bottom).offset(16)
            $0.height.equalTo(2)
        }

        userReviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(divider.snp.bottom).offset(16)
        }

        reviewRegisterButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(divider.snp.bottom).offset(17)
        }

        reviewCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(userReviewLabel.snp.bottom).offset(23)
            $0.height.equalTo(200)
        }

        divider2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(reviewCollectionView.snp.bottom).offset(20)
            $0.height.equalTo(8)
        }

        blogReviewLabel.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        blogReviewTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(blogReviewLabel.snp.bottom).offset(16)
        }

        moreButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(blogReviewTableView.snp.bottom)
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.getSafeArea().bottom).offset(-50)
        }
    }

    private func setRx() {
        copyButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                UIPasteboard.general.string = self?.addressLabel.text
            }).disposed(by: disposeBag)
    }
}

extension ShowRoomDetailViewController: View {
    func bind(reactor: ShowRoomDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: ShowRoomDetailReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap.map { Reactor.Action.bookmarkButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: ShowRoomDetailReactor) {
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: showRoomTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: tagCollectionView.rx.items(cellIdentifier: RWTagCollectionViewCell.identifier, cellType: RWTagCollectionViewCell.self)) { indexPath, item, cell in
                cell.label.text = "# " + item
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.address }
            .distinctUntilChanged()
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timeInfo }
            .distinctUntilChanged()
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.phoneNumber }
            .distinctUntilChanged()
            .bind(to: phoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.instagramID }
            .distinctUntilChanged()
            .bind(to: instagramLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.webSiteLink }
            .distinctUntilChanged()
            .bind(to: webLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userReviewImages }
            .bind(to: reviewCollectionView.rx.items(cellIdentifier: RWUserReviewCollectionViewCell.identifier, cellType: RWUserReviewCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.1) else { return }
                cell.imageView.kf.setImage(with: url)
                cell.reviewId = item.0
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.blogReviews }
            .bind(to: blogReviewTableView.rx.items(cellIdentifier: RWStoreBlogReviewTableViewCell.identifier, cellType: RWStoreBlogReviewTableViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.imageURL) else { return }
                cell.blogImageView.kf.setImage(with: url)
                cell.imageCountLabel.setAttributedTitle(NSAttributedString(string: "\(item.imageCount)",
                                                                           attributes: [.font: UIFont.caption, .foregroundColor: UIColor.white]), for: .normal)
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.content
                cell.webURL = item.webURL
            }.disposed(by: disposeBag)
    }
}
