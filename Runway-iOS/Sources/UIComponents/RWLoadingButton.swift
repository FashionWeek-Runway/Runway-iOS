//
//  RWLoadingButton.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/08/14.
//

import UIKit

final class RWLoadingButton: UIButton {
    
    // MARK: - Properties
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var trailingImageView: UIImageView = UIImageView(image: UIImage(named: "icon_right_point"))
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([trailingImageView, activityIndicator])
        
        if let titleLabel = titleLabel {
            trailingImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-14)
                make.centerY.equalToSuperview()
            }
            activityIndicator.snp.makeConstraints { make in
                make.edges.equalTo(trailingImageView)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
            }
        }
        activityIndicator.color = .point
        activityIndicator.hidesWhenStopped = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func startLoading() {
        isEnabled = false
        trailingImageView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        isEnabled = true
        trailingImageView.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
