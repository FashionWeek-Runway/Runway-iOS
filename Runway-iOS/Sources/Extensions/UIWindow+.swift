//
//  UIWindow+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/13.
//

import UIKit

extension UIWindow {
    static func makeToastAnimation(message: String) {
        let toastMessage = RWToastView(message: message)
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveLinear, animations: {
            toastMessage.alpha = 0
        }, completion: {_ in toastMessage.removeFromSuperview() })
    }
}
