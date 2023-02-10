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
}
