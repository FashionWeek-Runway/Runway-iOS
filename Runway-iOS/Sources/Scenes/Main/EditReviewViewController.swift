//
//  EditReviewViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class EditReviewViewController: BaseViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray700.cgColor
        button.setBackgroundColor(.gray900, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "등록",
                                                     attributes: [.foregroundColor: UIColor.point, .font: UIFont.body2B]), for: .normal)
        button.setImage(UIImage(named: "icon_right_point"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets.left = 4
        return button
    }()
    
    private let addTextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_add_text"), for: .normal)
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: EditReviewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .runwayBlack
        
        view.addSubviews([imageView, backButton, addTextButton, registerButton])
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(view.getSafeArea().top)
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom - 70)
        }
        
        backButton.setBackgroundImage(UIImage(named: "icon_tab_back_white"), for: .normal)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(navigationBarArea.snp.bottom).offset(-14)
        }
        
        addTextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(navigationBarArea.snp.bottom).offset(-10)
        }
        
        registerButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.height.equalTo(44)
            $0.width.equalTo(78)
        }
        
    }
}

extension EditReviewViewController: View {
    func bind(reactor: EditReviewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: EditReviewReactor) {
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .map { Reactor.Action.registerButtonDidTap(self.imageView.asImage().pngData())}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: EditReviewReactor) {
        reactor.state.map { $0.reviewImageData }
            .bind(onNext: { [weak self] in
                self?.imageView.image = UIImage(data: $0)
            }).disposed(by: disposeBag)
    }
}
