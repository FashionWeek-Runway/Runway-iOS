//
//  Tracking.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/09/05.
//

import Foundation

enum Tracking {
    
    enum Screen: String {
        case splash_01
        case login_selfish_01
        case sign_selfish_02
        case sign_selfish_03
        case sign_selfish_04
        case sign_common_01
        case sign_common_02
        case sign_common_03
        case sign_common_04
        case login_social_01
        case home
        case category_01
        case home_total
        case map_01
        case map_search_01
        case map_02
        case map_detail
        case review_01
        case my
        case my_setting_01
        case my_setting_02
        case my_leave_01
    }
    
    enum Event: String {
        case lookup = "lookup_event"
        case homeTouch = "home_touch_event"
        case mapTouch = "map_touch_event"
        case detailTouch = "detail_touch_event"
        case mypageTouch = "mypage_touch_event"
    }
    
}
