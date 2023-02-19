//
//  SignUpCompleteViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class SignUpCompleteViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입 완료!"
        label.textColor = .white
        label.font = .headline2
        return label
    }()
    
    private let captionlabel: UILabel = {
        let label = UILabel()
        label.text = "런웨이를 가입한 걸 축하해요!\n이제 내 취향에 맞는 쇼룸을 찾아볼까요?"
        label.font = .body1
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .gray500
        return label
    }()
    
    private let profileCard = RWProfileTagCardView()
    
    private let homeButton: RWButton = {
        let button = RWButton()
        button.title = "홈으로"
        button.type = .blackPoint
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: SignUpCompleteReactor) {
        self.profileCard.nicknameLabel.text = reactor.initialState.nickname
        self.profileCard.styles = reactor.initialState.styles
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .runwayBlack
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCardScaleAnimation()
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.view.addSubviews([guideTextLabel, captionlabel, profileCard, homeButton])
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        captionlabel.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        profileCard.snp.makeConstraints {
            $0.top.equalTo(captionlabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        homeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func profileCardScaleAnimation() {
//        let x = self.profileCard.bounds.midX
//        let y = self.profileCard.bounds.maxY
//        let width = profileCard.frame.width
//        let height = profileCard.frame.height
        
        self.profileCard.layer.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        self.profileCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3) {
//            self.profileCard.layer.anchorPoint = CGPoint(x: x, y: y)
            self.profileCard.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func scaleTransform(for view: UIView, scaledBy scale: CGPoint, aroundAnchorPoint relativeAnchorPoint: CGPoint) -> CGAffineTransform {
        let bounds = view.bounds
        let anchorPoint = CGPoint(x: bounds.width * relativeAnchorPoint.x, y: bounds.height * relativeAnchorPoint.y)
        return CGAffineTransform.identity
            .translatedBy(x: anchorPoint.x, y: anchorPoint.y)
            .scaledBy(x: scale.x, y: scale.y)
            .translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)
    }

}

extension SignUpCompleteViewController: View {
    func bind(reactor: SignUpCompleteReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SignUpCompleteReactor) {
        homeButton.rx.tap
            .map { Reactor.Action.homeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SignUpCompleteReactor) {

    }
}
