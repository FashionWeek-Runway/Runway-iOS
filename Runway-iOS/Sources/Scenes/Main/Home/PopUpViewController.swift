//
//  PopUpViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/08.
//

import UIKit
import ReactorKit

import Kingfisher

final class PopUpViewController: BaseViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close_white"), for: .normal)
        return button
    }()


    // MARK: - initializer
    
    init(with reactor: PopUpReactor) {
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
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.4)
        view.isOpaque = false
        
        view.addSubviews([imageView, dismissButton])
        imageView.snp.makeConstraints {
            $0.width.equalTo(292)
            $0.height.equalTo(320)
            $0.center.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.trailing.equalTo(imageView).offset(-16)
            $0.top.equalTo(imageView).offset(16)
        }
    }
    
}

extension PopUpViewController: View {
    func bind(reactor: PopUpReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PopUpReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .map { Reactor.Action.dismissButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PopUpReactor) {
        reactor.state.compactMap { $0.imageURL }
            .bind(with: self) { owner, url in
                owner.imageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
    }
}
