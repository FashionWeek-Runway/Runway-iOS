//
//  ReviewReportingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import RxKeyboard

final class ReviewReportingViewController: BaseViewController {
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 사유를 골라주세요"
        label.font = .headline5
        return label
    }()
    
    private let isSpamButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let spamLabel: UILabel = {
        let label = UILabel()
        label.text = "스팸 홍보 / 도배글이에요"
        label.font = .body1
        return label
    }()
    
    private let isInappropreatedButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let inappropreatedLabel: UILabel = {
        let label = UILabel()
        label.text = "부적절한 사진이에요"
        label.font = .body1
        return label
    }()
    
    private let isHarmfulButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let harmfulLabel: UILabel = {
        let label = UILabel()
        label.text = "청소년에게 유해한 내용이에요"
        label.font = .body1
        return label
    }()
    
    private let isAbuseButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let abuseLabel: UILabel = {
        let label = UILabel()
        label.text = "욕설 / 혐오 / 차별적 표현을 담고있어요"
        label.font = .body1
        return label
    }()
    
    private let isLieButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let lieLabel: UILabel = {
        let label = UILabel()
        label.text = "거짓 정보를 담고 있어요"
        label.font = .body1
        return label
    }()
    
    private let isEtcButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_radio"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_radio_selected"), for: .selected)
        return button
    }()
    
    private let etcLabel: UILabel = {
        let label = UILabel()
        label.text = "기타"
        label.font = .body1
        return label
    }()
    
    
    private let opinionLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 의견이 있다면 적어주세요"
        label.font = .headline5
        return label
    }()
    
    private let opinionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray200.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.clipsToBounds = true
        
        return textView
    }()
    
    private let opnionTextViewPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 사유를 입력해주세요"
        label.font = .body1
        label.textColor = .gray300
        return label
    }()
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "신고자 정보는 익명으로 처리되며, 신고한 사용자 후기는\n검토 후 임시조치 될 예정입니다."
        label.textColor = .gray500
        label.font = .body2
        return label
    }()
    
    private let bottomButtonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let bottomButtonTopBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let reportButton: RWButton = {
        let button = RWButton()
        button.title = "신고하기"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: - initializer
    
    init(with reactor: ReviewReportingReactor) {
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
        
        addBackButton()
        addNavigationTitleLabel("사용자 후기 신고")
        view.addSubviews([scrollView, bottomButtonBackgroundView])
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationBarArea.snp.bottom)
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom - 70)
        }
        
        bottomButtonBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(70)
        }
        
        bottomButtonBackgroundView.addSubviews([bottomButtonTopBorderView, reportButton])
        bottomButtonTopBorderView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        reportButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-21)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.high)
        }
        
        let reasonUI = [(isSpamButton, spamLabel),
                        (isInappropreatedButton, inappropreatedLabel),
                        (isHarmfulButton, harmfulLabel),
                        (isAbuseButton, abuseLabel),
                        (isLieButton, lieLabel),
                        (isEtcButton, etcLabel)].map {
            
            let stackView = UIStackView(arrangedSubviews: [$0.0, $0.1])
            stackView.spacing = 12
            stackView.axis = .horizontal
            stackView.alignment = .center
            return stackView
        }
        
        let reasonUIStackView = UIStackView(arrangedSubviews: reasonUI)
        reasonUIStackView.axis = .vertical
        reasonUIStackView.spacing = 32
        reasonUIStackView.alignment = .leading
        
        containerView.addSubviews([reasonLabel, reasonUIStackView, opinionLabel, opinionTextView, opnionTextViewPlaceholderLabel, guideTextLabel])
        reasonLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        reasonUIStackView.snp.makeConstraints {
            $0.top.equalTo(reasonLabel.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(20)
        }
        
        opinionLabel.snp.makeConstraints {
            $0.top.equalTo(reasonUIStackView.snp.bottom).offset(64)
            $0.leading.equalToSuperview().offset(20)
        }
        
        opinionTextView.snp.makeConstraints {
            $0.top.equalTo(opinionLabel.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalTo((UIScreen.getDeviceWidth() - 40) / 2)
        }
        
        opnionTextViewPlaceholderLabel.snp.makeConstraints {
            $0.top.equalTo(opinionTextView.snp.top).offset(14)
            $0.leading.equalTo(opinionTextView.snp.leading).offset(14)
        }
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(opinionTextView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-42)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : 0
                self.bottomButtonBackgroundView.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                }
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setRx() {
        opinionTextView.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.opnionTextViewPlaceholderLabel.isHidden = self?.opinionTextView.text.isEmpty != true
            }).disposed(by: disposeBag)
    }
}

extension ReviewReportingViewController: View {
    func bind(reactor: ReviewReportingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ReviewReportingReactor) {
        
    }
    
    private func bindState(reactor: ReviewReportingReactor) {
        
    }
}
