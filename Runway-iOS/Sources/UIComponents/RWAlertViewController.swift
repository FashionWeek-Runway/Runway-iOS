//
//  RWAlertViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/12.
//

import UIKit

final class RWAlertViewController: UIViewController {
    
    let alertView: RWAlertView = {
        let view = RWAlertView()
        view.textLabel.text = "비밀번호가 변경되었습니다.\n새로운 비밀번호로 로그인 해주세요."
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: Bundle.main)
        self.modalPresentationStyle = .overFullScreen
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.view.addSubviews([alertView])
        alertView.snp.makeConstraints {
            $0.width.equalTo(292)
            $0.height.equalTo(146)
            $0.center.equalToSuperview()
        }
    }
}