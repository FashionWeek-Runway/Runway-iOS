//
//  RWTextField.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import UIKit
import RxSwift
import RxCocoa

class RWTextField: UITextField {
    
    var disposeBag = DisposeBag()
    
    var bottomLine = CALayer()
    
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.font = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0
        
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray300.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
