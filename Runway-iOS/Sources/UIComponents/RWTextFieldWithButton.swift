//
//  RWTextField+Button.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit

final class RWTextFieldWithButton: UIView {
    
    let textField = UITextField()
    
    var bottomLine = UIView()

    var focusColor: UIColor = .black
    
    var unfocusColor: UIColor = .gray300 {
        didSet {
            bottomLine.backgroundColor = unfocusColor
        }
    }
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .error
        label.font = .body2
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.setBackgroundColor(.blue100, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        return button
    }()
    
    var placeholder: String? {
        didSet {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)])
        }
    }
    
    private var timeSecond = 0
    var timer: Timer?
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        self.textField.font = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0

        bottomLine.backgroundColor = unfocusColor
        self.textField.borderStyle = UITextField.BorderStyle.none
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(-6)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(67)
        }
        
        self.addSubview(timerLabel)
        timerLabel.snp.makeConstraints {
            $0.trailing.equalTo(rightButton.snp.leading).offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(29)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(timerLabel.snp.leading)
        }
    }
    
    // MARK: - timer
    
    func startTimer(initialSecond: Int) {
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
        }
        timeSecond = initialSecond
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callBackTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func callBackTimer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        guard let timeString = formatter.string(from: TimeInterval(timeSecond)) else { return }
        timerLabel.text = "\(timeString)"
        
        if timeSecond == 0 {
            timer?.invalidate()
            timer = nil
        } else {
            timeSecond -= 1
        }
    }
}

extension RWTextFieldWithButton: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.bottomLine.backgroundColor = focusColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bottomLine.backgroundColor = unfocusColor
    }
}
