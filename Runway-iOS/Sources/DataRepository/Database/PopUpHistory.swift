//
//  PopUpHistory.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/09.
//

import Realm
import RealmSwift

final class PopUpHistory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var popUpId: Int
    @Persisted var userId: Int
}

