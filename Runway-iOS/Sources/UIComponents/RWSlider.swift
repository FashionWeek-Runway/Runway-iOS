//
//  RWSlider.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWSlider: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100.withAlphaComponent(0.5)
        view.getShadowView(color: UIColor.black.withAlphaComponent(0.25).cgColor, masksToBounds: false, shadowOffset: CGSizeMake(0, 0), shadowRadius: 4, shadowOpacity: 1)
        return view
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        return slider
    }()
    
    // MARK: initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
