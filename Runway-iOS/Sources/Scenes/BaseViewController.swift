//
//  BaseViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body1
        return label
    }()
    
    let navigationBarArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func addNavigationTitleLabel() {
        self.navigationBarArea.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func addBackButton() {
        self.navigationBarArea.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
    
    func configureUI() {
        self.view.addSubview(self.navigationBarArea)
        self.navigationBarArea.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(54)
        }
    }
}
