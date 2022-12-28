//
//  RootTabBarController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/04.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // tab1 - Category
        // name: 스토리보드파일이름
        // withIdentifier: 뷰컨트롤러의 스토리보드 아이디
        let tab1 = UIStoryboard(name: "GroupListViewController", bundle: nil).instantiateViewController(withIdentifier: "groupNavi")
        let tab1_barItem = UITabBarItem(title: RootTabbarItem.group.title, image: RootTabbarItem.group.image, selectedImage: RootTabbarItem.group.image)
        tab1.tabBarItem = tab1_barItem
        tab1.title = RootTabbarItem.group.title
        
        // 탭2 - review lesson
//        let tab2 = ReviewLessonNavigationController(rootViewController: ReviewLessonViewController())
        
        let tab2 = UIStoryboard(name: "ReviewLessonViewController", bundle: nil).instantiateViewController(identifier: "reviewNavi")
        let tab2_barItem = UITabBarItem(title: RootTabbarItem.reviewlessons.title, image: RootTabbarItem.reviewlessons.image, selectedImage: RootTabbarItem.reviewlessons.image)
        tab2.tabBarItem = tab2_barItem
        tab2.title = RootTabbarItem.reviewlessons.title
        
        // tab3 - Setting
        let tab3 = UIStoryboard(name: "SettingsViewController", bundle: nil).instantiateViewController(withIdentifier: "settingNavi")
        let tab3_barItem = UITabBarItem(title: RootTabbarItem.settings.title, image: RootTabbarItem.settings.image, selectedImage: RootTabbarItem.settings.image)
        tab3.tabBarItem = tab3_barItem
        tab3.title = RootTabbarItem.settings.title
        
        self.tabBar.tintColor = UIColor(named: "main_accent") ?? UIColor.blue
        self.tabBar.barTintColor = UIColor(named: "tabbar_background") ?? UIColor.white
        self.viewControllers = [tab1, tab2, tab3]
        
    }

}
