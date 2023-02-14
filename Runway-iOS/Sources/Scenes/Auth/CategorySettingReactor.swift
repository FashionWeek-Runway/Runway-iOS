//
//  CategorySettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import Foundation

import RxSwift
import RxDataSources

typealias FashionStyleCollectionViewSectionModel = SectionModel<Int, FashionStyleCategoryCollectionViewSection>

enum FashionStyleCategoryCollectionViewSection {
    case defaultCell(FashionStyleCollectionViewCellReactor)
}

final class CategorySettingReactor {
    
}
