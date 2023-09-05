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
        
        case homeAreaTop = "home_area_top"
        case homeAreaMid = "home_area_mid"
        case homeAreaBot = "home_area_bot"
        case mapDetailArea01 = "mapdetail_area_01"
        case mapDetailArea02 = "mapdetail_area_02"
        case mapDetailArea03 = "mapdetail_area_03"
        case mapDetailArea04 = "mapdetail_area_04"
        case mapDetailArea05 = "mapdetail_area_05"
        case mapDetailArea06 = "mapdetail_area_06"
    }
    
    enum Event: String {
        case lookup = "lookup_event"
        case homeTouch = "home_touch_event"
        case mapTouch = "map_touch_event"
        case detailTouch = "detail_touch_event"
        case mypageTouch = "mypage_touch_event"
        case homeScroll = "home_scroll"
    }
    
}
