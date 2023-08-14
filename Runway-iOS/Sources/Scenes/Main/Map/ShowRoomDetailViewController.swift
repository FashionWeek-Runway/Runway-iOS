//
//  ShowRoomDetailViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import ReactorKit

import SkeletonView

import Kingfisher
import SafariServices
import AVFoundation
import Photos

final class ShowRoomDetailViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
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
    
    private let topAreaGradientView: UIView = UIView()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
        return button
    }()
    
//    private let shareButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
//        return button
//    }()
    
    private let mainImageCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWMainStoreImageCollectionViewCell.self, forCellWithReuseIdentifier: RWMainStoreImageCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: UIScreen.getDeviceWidth() * 0.75)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
        return view
    }()
    
    private let mainImageCollectionViewGradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 21))
        return view
    }()
    
    private let showRoomTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .headline2
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.text = "아더 성수 스페이스"
        label.showAnimatedSkeleton()
        label.skeletonTextNumberOfLines = 1
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
    
    private let locationIcon = {
        let imageView = UIImageView(image: UIImage(named: "icon_map_storedetail"))
        imageView.isSkeletonable = true
        imageView.showAnimatedSkeleton()
        return imageView
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body2
        label.numberOfLines = 0
        label.text = "서울특별시 성동구 아차산로 13길 11"
        label.isSkeletonable = true
        label.showAnimatedSkeleton()
        return label
    }()
    private let copyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_copy"), for: .normal)
        button.imageEdgeInsets.right = 2
        button.setAttributedTitle(NSAttributedString(string: "복사", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.blue500]), for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let timeIcon = {
        let imageView = UIImageView(image: UIImage(named: "icon_time_storedetail"))
        imageView.isSkeletonable = true
        imageView.showAnimatedSkeleton()
        return imageView
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "월 - 일 08:00 ~ 21:00"
        label.textColor = .runwayBlack
        label.font = .body2
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.showAnimatedSkeleton()
        return label
    }()
    
    private let phoneIcon = {
        let imageView = UIImageView(image: UIImage(named: "icon_call_storedetail"))
        imageView.isSkeletonable = true
        imageView.showAnimatedSkeleton()
        return imageView
    }()
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "0507-1489-0251"
        label.textColor = .runwayBlack
        label.font = .body2
        label.isSkeletonable = true
        label.showAnimatedSkeleton()
        return label
    }()
    
    private let instagramIcon = {
        let imageView = UIImageView(image: UIImage(named: "icon_instagram_storedetail"))
        imageView.isSkeletonable = true
        imageView.showAnimatedSkeleton()
        return imageView
    }()
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "[인스타그램 아이디]"
        label.textColor = .runwayBlack
        label.font = .body2
        label.isSkeletonable = true
        label.showAnimatedSkeleton()
        return label
    }()
    
    private let webIcon = {
        let imageView = UIImageView(image: UIImage(named: "icon_web_storedetail"))
        imageView.isSkeletonable = true
        imageView.showAnimatedSkeleton()
        return imageView
    }()
    private let webLabel: UILabel = {
        let label = UILabel()
        label.text = "[웹사이트 링크]"
        label.textColor = .runwayBlack
        label.font = .body2
        label.isSkeletonable = true
        label.showAnimatedSkeleton()
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
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        return button
    }()
    
    private let reviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWUserReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWUserReviewCollectionViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 6
        layout.itemSize = CGSize(width: 132, height: 200)
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
        return view
    }()
    
    private let reviewEmptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_review"))
        view.isHidden = true
        return view
    }()
    private let reviewEmptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 등록된 후기가 없습니다."
        label.font = .body1
        label.textColor = .runwayBlack
        label.isHidden = true
        return label
    }()
    private let reviewEmptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "매장에 방문했다면 후기를 남겨보세요 :)"
        label.font = .body2
        label.textColor = .gray500
        label.isHidden = true
        return label
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
    
    private let blogReviewTableView: UITableView = {
        let view = UITableView()
        view.register(RWStoreBlogReviewTableViewCell.self, forCellReuseIdentifier: RWStoreBlogReviewTableViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.rowHeight = 136
        return view
    }()
    
//    private let moreButton: UIButton = {
//        let button = UIButton()
//        button.setAttributedTitle(NSAttributedString(string: "더보기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray900]), for: .normal)
//        button.setImage(UIImage(named: "icon_down_black"), for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft
//        button.imageEdgeInsets.left = 10
//        return button
//    }()
    
    private let cameraPickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
//        picker.delegate = nil
        picker.modalPresentationStyle = .overCurrentContext
        picker.sourceType = .camera
        return picker
    }()
    
    private let albumPickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
//        picker.delegate = nil
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .overCurrentContext
        return picker
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topAreaGradientView.setGradientBackground(colorTop: .runwayBlack.withAlphaComponent(0.3), colorBottom: .clear)
        mainImageCollectionViewGradientView.setGradientBackground(colorTop: .clear, colorBottom: .white)
        containerView.showAnimatedSkeleton()
    }
    
    override func configureUI() {
        super.configureUI()
        backButton.setBackgroundImage(UIImage(named: "icon_tab_back_white"), for: .normal)
        
        view.addSubviews([scrollView, topAreaGradientView, topArea])
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.centerX.top.bottom.equalToSuperview()
        }
        
        containerView.addSubviews([mainImageCollectionView, mainImageCollectionViewGradientView,
                                   showRoomTitleLabel, tagCollectionView,
                                   locationIcon, addressLabel, copyButton,
                                   timeIcon, timeLabel,
                                   phoneIcon, phoneLabel,
                                   instagramIcon, instagramLabel,
                                   webIcon, webLabel, divider,
                                   userReviewLabel, reviewRegisterButton, reviewEmptyImageView, reviewEmptyTitleLabel, reviewEmptyDescriptionLabel,
                                   reviewCollectionView,
                                   divider2, blogReviewLabel, blogReviewTableView,
//                                   moreButton
                                  ])
        
        topArea.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.getSafeArea().top + 51)
        }
        
        topAreaGradientView.snp.makeConstraints {
            $0.edges.equalTo(topArea.snp.edges)
        }
        
        topArea.addSubviews([backButton, bookmarkButton,
//                             shareButton
                            ])
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
//        shareButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.bottom.equalToSuperview().offset(-14)
//        }
        
//        bookmarkButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-60)
//            $0.bottom.equalToSuperview().offset(-14)
//        }
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        mainImageCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.75)
        }
        
        mainImageCollectionViewGradientView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21)
            $0.bottom.equalTo(mainImageCollectionView.snp.bottom)
        }
        
        showRoomTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainImageCollectionView.snp.bottom).offset(16)
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
//            $0.leading.equalToSuperview().offset(46)
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(16)
        }
        
        copyButton.snp.makeConstraints {
//            $0.leading.equalTo(addressLabel.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-20)
            $0.centerY.equalTo(locationIcon.snp.centerY)
        }
        
        timeIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeIcon.snp.trailing).offset(8)
            $0.top.equalTo(timeIcon.snp.top).offset(1)
        }
        
        phoneIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(timeLabel.snp.bottom).offset(11)
        }
        
        phoneLabel.snp.makeConstraints {
            $0.leading.equalTo(phoneIcon.snp.trailing).offset(8)
            $0.top.equalTo(phoneIcon.snp.top).offset(1)
        }
        
        instagramIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(phoneLabel.snp.bottom).offset(11)
        }
        
        instagramLabel.snp.makeConstraints {
            $0.leading.equalTo(instagramIcon.snp.trailing).offset(8)
            $0.top.equalTo(instagramIcon.snp.top).offset(1)
        }
        
        webIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(instagramLabel.snp.bottom).offset(11)
        }
        
        webLabel.snp.makeConstraints {
            $0.leading.equalTo(webIcon.snp.trailing).offset(8)
            $0.top.equalTo(webIcon.snp.top).offset(1)
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
        
        reviewEmptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(divider.snp.bottom).offset(69)
        }
        
        reviewEmptyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(reviewEmptyImageView.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
        }
        
        reviewEmptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(reviewEmptyTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
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
        
        blogReviewTableView.snp.removeConstraints()
        blogReviewTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(blogReviewLabel.snp.bottom).offset(16)
            $0.height.equalTo(136)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
//        moreButton.snp.makeConstraints {
//            $0.top.equalTo(blogReviewTableView.snp.bottom)
//            $0.horizontalEdges.equalToSuperview()
//            $0.height.equalTo(44)
//            $0.bottom.equalToSuperview().offset(-50)
//        }
    }
    
    private func setRx() {
        copyButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                UIPasteboard.general.string = self?.addressLabel.text
                UIWindow.makeToastAnimation(message: "클립보드에 복사되었습니다.", .bottom, 20)
            }).disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] offset in
                guard let self else { return }
                if offset.y >= 280 {
                    self.topArea.backgroundColor = .white
                    self.topAreaGradientView.isHidden = true
                    
                    self.backButton.setBackgroundImage(UIImage(named: "icon_tab_back"), for: .normal)
                    self.bookmarkButton.setBackgroundImage(UIImage(named: "icon_tab_bookmark_black"), for: .normal)
                    self.bookmarkButton.setBackgroundImage(UIImage(named: "icon_tab_bookmark_black_selected"), for: .selected)
//                    self.shareButton.setBackgroundImage(UIImage(named: "icon_share_black"), for: .normal)
                } else {
                    self.topArea.backgroundColor = .clear
                    self.topAreaGradientView.isHidden = false
                    
                    self.backButton.setBackgroundImage(UIImage(named: "icon_tab_back_white"), for: .normal)
                    self.bookmarkButton.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
                    self.bookmarkButton.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
//                    self.shareButton.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
                }
            }).disposed(by: disposeBag)
        
        reviewRegisterButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.presentActionSheet()
            }).disposed(by: disposeBag)
        
        instagramLabel.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let instagramId = self?.reactor?.currentState.instagramID,
                      let url = URL(string: instagramId) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }).disposed(by: disposeBag)
        
        webLabel.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let webLink = self?.reactor?.currentState.webSiteLink,
                      let url = URL(string: webLink) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setUserReviewsIfEmpty() {
        [reviewEmptyImageView, reviewEmptyTitleLabel, reviewEmptyDescriptionLabel].forEach { $0.isHidden = false }
        reviewCollectionView.isHidden = true
    }
    
    private func setUserReviews() {
        [reviewEmptyImageView, reviewEmptyTitleLabel, reviewEmptyDescriptionLabel].forEach { $0.isHidden = true }
        reviewCollectionView.isHidden = false
    }
    
    private func showbookmarkToast() {
        let toastMessage = RWToastView(message: "매장이 저장되었습니다")
        self.view.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom - 20)
        }
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveLinear, animations: {
            toastMessage.alpha = 0
        }, completion: {_ in toastMessage.removeFromSuperview() })
    }
    
    private func presentActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "사진 찍기", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.present(self.cameraPickerController, animated: true)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "사진 앨범", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                print(status)
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self.present(self.albumPickerController, animated: true)
                    }
                default:
                    break
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alertController, animated: true)
    }
}

extension ShowRoomDetailViewController: View {
    func bind(reactor: ShowRoomDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ShowRoomDetailReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .do(onNext: { [weak self] _ in
                self?.bookmarkButton.isSelected.toggle()
                if self?.bookmarkButton.isSelected == true {
                    self?.showbookmarkToast()
                }
            })
                .map { Reactor.Action.bookmarkButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        blogReviewTableView.rx.modelSelected(ShowRoomBlogsResponseResult.self)
            .asDriver()
            .drive(onNext: { [weak self] item in
                guard let url = URL(string: item.webURL) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
        
        reviewCollectionView.rx.didEndDecelerating // infiniteScrolling
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let width = self.reviewCollectionView.frame.width
                let contentWidth = self.reviewCollectionView.contentSize.width
                let reachesBottom = (self.reviewCollectionView.contentOffset.x > contentWidth - width * 5)
                
                if reachesBottom {
                    self.reactor?.action.onNext(.userReviewScrollReachesBottom)
                }
            }).disposed(by: disposeBag)
        
        reviewCollectionView.rx.modelSelected((Int, String).self)
            .asDriver()
            .drive(onNext: { [weak self] data in
                let action = Reactor.Action.reviewCellDidTap(data.0)
                self?.reactor?.action.onNext(action)
            }).disposed(by: disposeBag)
        
        
        Observable.merge([cameraPickerController.rx.didCancel, albumPickerController.rx.didCancel])
            .bind(onNext: { _ in self.dismiss(animated: true) })
            .disposed(by: disposeBag)
        
        // bind action
        Observable.merge([cameraPickerController.rx.didFinishPickingMediaWithInfo, albumPickerController.rx.didFinishPickingMediaWithInfo])
            .subscribe(onNext: { [weak self] info in
                self?.dismiss(animated: false, completion: {
                    guard let image = info[.originalImage] as? UIImage, let imageData = image.fixedOrientation().pngData() else { return }
                    let action = Reactor.Action.pickingReviewImage(imageData)
                    self?.reactor?.action.onNext(action)
                })
            }).disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ShowRoomDetailReactor) {
        reactor.state.map { $0.mainImageUrlList }
            .distinctUntilChanged()
            .bind(to: mainImageCollectionView.rx.items(cellIdentifier: RWMainStoreImageCollectionViewCell.identifier, cellType: RWMainStoreImageCollectionViewCell.self)) { IndexPath, item, cell in
                cell.storeImageView.image = nil
                cell.storeImageView.kf.indicatorType = .activity
                cell.storeImageView.kf.setImage(with: URL(string: item))
            }.disposed(by: disposeBag)
        
        
        reactor.state.map { $0.title }
            .filter { $0 != "" }
            .distinctUntilChanged()
            .do(onNext: { [weak self] event in
                self?.showRoomTitleLabel.hideSkeleton()
            })
            .bind(to: showRoomTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: tagCollectionView.rx.items(cellIdentifier: RWTagCollectionViewCell.identifier, cellType: RWTagCollectionViewCell.self)) { indexPath, item, cell in
//                cell.label.text = "# " + item
                if item == "Dummy" {
                    cell.isSkeletonable = true
                    cell.setCellLayout(isSkeleton: true)
                    cell.showAnimatedSkeleton()
                    cell.label.text = item
                } else {
                    cell.hideSkeleton()
                    cell.setCellLayout(isSkeleton: false)
                    cell.label.text = "# " + item
                }
//                cell.label.text = "# " + item
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.address }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.locationIcon.hideSkeleton()
                self?.addressLabel.hideSkeleton()
            })
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timeInfo }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.timeIcon.hideSkeleton()
                self?.timeLabel.hideSkeleton()
            })
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.phoneNumber }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.phoneIcon.hideSkeleton()
                self?.phoneLabel.hideSkeleton()
            })
            .bind(to: phoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.instagramID }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.instagramIcon.hideSkeleton()
                self?.instagramLabel.hideSkeleton()
            })
            .bind(to: instagramLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.webSiteLink }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.webIcon.hideSkeleton()
                self?.webLabel.hideSkeleton()
            })
            .bind(to: webLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBookmark }
            .distinctUntilChanged()
            .bind(to: bookmarkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userReviewImages.map { ($0.reviewID, $0.imgURL) } }
            .do(onNext: { [weak self] in
                if $0.isEmpty {
                    self?.setUserReviewsIfEmpty()
                } else {
                    self?.setUserReviews()
                }
            })
            .bind(to: reviewCollectionView.rx.items(cellIdentifier: RWUserReviewCollectionViewCell.identifier, cellType: RWUserReviewCollectionViewCell.self)) { indexPath, item, cell in
                if item.0 == 0 && item.1 == "Dummy" {
                    cell.showAnimatedSkeleton()
                } else {
                    guard let url = URL(string: item.1) else { return }
                    cell.hideSkeleton()
                    cell.imageView.kf.indicatorType = .activity
                    cell.imageView.kf.setImage(with: url)
                    cell.reviewId = item.0
                }
                cell.locationIcon.isHidden = true
            }.disposed(by: disposeBag)

        reactor.state.map { $0.blogReviews }
            .do(onNext: {[weak self] items in
                guard !items.isEmpty else { return }
                self?.blogReviewTableView.snp.updateConstraints {
                    $0.height.equalTo(items.count * 136)
                }
            })
            .bind(to: blogReviewTableView.rx.items(cellIdentifier: RWStoreBlogReviewTableViewCell.identifier, cellType: RWStoreBlogReviewTableViewCell.self)) { indexPath, item, cell in
                if item.title == "" {
                    cell.showAnimatedSkeleton()
                } else {
                    guard let url = URL(string: item.imageURL) else { return }
                    cell.hideSkeleton()
                    cell.selectionStyle = .none
                    cell.blogImageView.kf.indicatorType = .activity
                    cell.blogImageView.kf.setImage(with: url)
                    cell.imageCountLabel.setAttributedTitle(NSAttributedString(string: "\(item.imageCount)",
                                                                               attributes: [.font: UIFont.caption, .foregroundColor: UIColor.white]), for: .normal)
                    cell.titleLabel.text = item.title
                    cell.descriptionLabel.text = item.content
                    cell.webURL = item.webURL
                }
            }.disposed(by: disposeBag)
    }
}
