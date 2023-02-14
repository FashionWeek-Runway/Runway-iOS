//
//  FashionStyleCollectionViewCellModel.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import Foundation

struct FashionStyleCollectionViewCellModel {
    var title: String
    
    var isSelected: Bool = false
    
    static let initialModels: [Self] = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"].map { Self(title: $0) }
}
