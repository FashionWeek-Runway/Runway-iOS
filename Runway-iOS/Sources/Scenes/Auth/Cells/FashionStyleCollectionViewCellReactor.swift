//
//  FashionStyleCollectionViewCellReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import Foundation

import ReactorKit

final class FashionStyleCollectionViewCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: FashionStyleCollectionViewCellModel
    
    init(state: FashionStyleCollectionViewCellModel) {
        self.initialState = state
    }
}
