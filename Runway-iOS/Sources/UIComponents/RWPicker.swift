//
//  RWPicker.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa

class RWPicker: UIView {
    
    private let disposeBag = DisposeBag()
    
    lazy var labelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.runwayBlack, for: .normal)
        return button
    }()
    
    let picker: UIPickerView = UIPickerView()
    
    var pickerData:[String] = ["1", "2", "3", "4", "5"]
    
    var bottomLine = UIView()
    var focusColor: UIColor = .black
    var unfocusColor: UIColor = .gray300 {
        didSet {
            bottomLine.backgroundColor = unfocusColor
        }
    }
    
    let dropDownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_down_grey"))
        return imageView
    }()
    
    // MARK: - intializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setButtonEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        self.addSubview(labelButton)
        labelButton.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        bottomLine.backgroundColor = unfocusColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    private func setButtonEvent() {
        labelButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.picker.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
