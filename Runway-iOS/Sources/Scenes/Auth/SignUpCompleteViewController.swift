//
//  SignUpCompleteViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .runwayBlack
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

}


