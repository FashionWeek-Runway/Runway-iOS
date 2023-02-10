//
//  BaseViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let navigationBarArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_left_black"), for: .normal)
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
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(94)
        }
    }
}
