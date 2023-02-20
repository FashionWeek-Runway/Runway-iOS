//
//  MapModel.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit

struct MapPointDataModel {
    let latitude: Double
    let longtitude: Double
    let storeName: String?
    let type: PointerType
}

enum PointerType {
    case normalStore
    case bookmarkStore
}

struct MainMapCategory {
    let categoryName: String
    let categoryIcon: UIImage
    
    static let allCategoryString = "미니멀, 캐주얼, 스트릿, 페미닌, 빈티지, 시티보이"
}

struct Location {
    let latitude: Double
    let longitude: Double
}
