//
//  RWPicker.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa

final class RWPicker: UIView {
    
    private let disposeBag = DisposeBag()
    
    let textField: UITextField = {
        let field = UITextField()
        field.textColor = .runwayBlack
        field.backgroundColor = .clear
        return field
    }()
    
    let picker: UIPickerView = UIPickerView()
    let doneToolBar = UIToolbar()
    let doneBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)
        
    
    var pickerData: [String] = ["가", "나", "다", "라", "마"]
    
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
    
    convenience init(pickerData: [String]) {
        self.init(frame: .zero)
        self.pickerData = pickerData
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints {
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
    
    private func setRx() {
        Observable.of(pickerData).bind(to: self.picker.rx.itemTitles) {
            _, item in
            return "\(item)"
        }.disposed(by: disposeBag)
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
        textField.inputView = self.picker
        
        picker.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] row, component in
                self?.textField.text = "\(self?.pickerData[row] ?? "")"
            }).disposed(by: disposeBag)
    }
}
