//
//  RootTabbarItem.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/04.
//  Copyright © 2020 Tomatoma. All rights reserved.
//


import UIKit

enum RootTabbarItem {
    case group
    case settings
    case reviewlessons
    
    var title: String {
        switch self {
            case .group:
                return "group_title".localized()
        case .reviewlessons:
            return "lesson_title".localized()
            case .settings:
                return "settings_title".localized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .group:
            return #imageLiteral(resourceName: "icon_group")
        case .reviewlessons:
            return #imageLiteral(resourceName: "ico_lesson")
        case .settings:
            return #imageLiteral(resourceName: "icon_setting")
        }
    }
    

}


