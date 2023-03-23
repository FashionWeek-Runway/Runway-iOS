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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let textEditView: RWReviewTextEditView = {
        let view = RWReviewTextEditView()
        view.alpha = 0.0
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
    
    
    
    private var selectedTextView: RWReviewTextView? = nil
    private var selectedTextViewOrigin: CGPoint? = nil
    
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
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .runwayBlack
        
        view.addSubviews([imageView, textEditView, backButton,
                          addTextButton,
                          registerButton])
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(view.getSafeArea().top)
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom - 70)
        }
        
        textEditView.snp.makeConstraints {
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
    
    private func setRx() {
        addTextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.setTextEditMode()
            }).disposed(by: disposeBag)
        
        textEditView.editCancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.cancelTextEditMode()
            }).disposed(by: disposeBag)
        
        textEditView.alignmentButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self, let selectedTextView = self.selectedTextView else { return }
                let currentPosition = selectedTextView.endOfDocument
                switch selectedTextView.textAlignment {
                case .left:
                    selectedTextView.textAlignment = .center
                    self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_center"), for: .normal)
                case .center:
                    selectedTextView.textAlignment = .right
                    self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_right"), for: .normal)
                case .right:
                    selectedTextView.textAlignment = .left
                    self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_left"), for: .normal)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        textEditView.editCompleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.completeTextEditMode()
            }).disposed(by: disposeBag)
    }
    
    private func setTextEditMode() {
        textEditView.fadeIn(duration: 0.3)
        [backButton, addTextButton, registerButton].forEach { $0.isHidden = true }
        
        if let selectedTextView = self.selectedTextView { // 기존 text 편집
            self.textEditView.editCancelButton.isHidden = true
            UIView.animate(withDuration: 0.3) {
                selectedTextView.frame = CGRect(x: 20, y: self.navigationBarArea.frame.maxY + 44, width: UIScreen.getDeviceWidth() - 40, height: 303)
            }
            switch selectedTextView.textAlignment {
            case .left:
                self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_left"), for: .normal)
            case .right:
                self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_right"), for: .normal)
            case .center:
                self.textEditView.alignmentButton.setBackgroundImage(UIImage(named: "icon_align_center"), for: .normal)
            default:
                break
            }
        } else { // 새로 생성
            let textView = RWReviewTextView(frame: CGRect(x: 20, y: self.navigationBarArea.frame.maxY + 44, width: UIScreen.getDeviceWidth() - 40, height: 303))
            self.textEditView.editCancelButton.isHidden = false
            
            textView.rx.didBeginEditing
                .asDriver()
                .drive(onNext: { [weak self] in
                    self?.selectedTextView = textView
                    self?.selectedTextViewOrigin = textView.frame.origin
                    self?.setTextEditMode()
                })
                .disposed(by: disposeBag)
            
            textView.rx.panGesture()
                .observe(on:MainScheduler.asyncInstance)
                .asDriver(onErrorJustReturn: .init())
                .drive(onNext: { [weak self] panGesture in
                    switch panGesture.state {
                    case .began:
                        self?.cancelTextEditMode()
                    case .changed:
                        let delta = panGesture.translation(in: textView.superview)
                        var position = textView.center
                        position.x += delta.x
                        position.y += delta.y
                        textView.center = position
                        panGesture.setTranslation(CGPoint.zero, in: textView.superview)
                    default:
                        break
                    }
                })
                .disposed(by: disposeBag)
            
            self.view.addSubview(textView)
            self.selectedTextView = textView
        }
        
        self.selectedTextView?.becomeFirstResponder()
    }
    
    private func cancelTextEditMode() {
        textEditView.fadeOut(duration: 0.3)
        [backButton, addTextButton, registerButton].forEach { $0.isHidden = false}
        
        selectedTextView?.removeFromSuperview()
        selectedTextView = nil
        selectedTextViewOrigin = nil
    }
    
    private func completeTextEditMode() {
        textEditView.fadeOut(duration: 0.3)
        [backButton, addTextButton, registerButton].forEach { $0.isHidden = false}
        
        self.selectedTextView?.sizeToFit()
        if let fitSize = self.selectedTextView?.bounds.size {
            self.selectedTextView?.contentSize = fitSize
        }
        self.selectedTextView?.resignFirstResponder()
        self.selectedTextView?.tag = 1 // 기존에 존재하는 textview임을 설정하는 플래그
        if let selectedTextViewOrigin = self.selectedTextViewOrigin {
            UIView.animate(withDuration: 0.3) {
                self.selectedTextView?.frame.origin = selectedTextViewOrigin
            }
        }
        selectedTextView = nil
        selectedTextViewOrigin = nil
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
            .do(onNext: { UIWindow.makeToastAnimation(message: "후기가 등록되었습니다.")})
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
