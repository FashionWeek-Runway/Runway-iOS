//
//  UIView+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/11.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func getShadowView(color : CGColor, masksToBounds : Bool, shadowOffset : CGSize, shadowRadius : Int, shadowOpacity : Float) {
        layer.shadowColor = color
        layer.masksToBounds = masksToBounds
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOpacity = shadowOpacity
    }
    
    func removeShadowView() {
        layer.shadowOpacity = 0
    }
}
