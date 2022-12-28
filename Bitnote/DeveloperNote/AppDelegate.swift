//
//  AppDelegate.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/03.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        connectToDB()
        
        setupNavigationBar()
        
        // 광고 초기화
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // 테스트 디바이스
        // TODO: 배포할때 제거할 것
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        
        return true
    }
    
    
    private func setupNavigationBar(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(named: "main_accent")
        navigationBarAppearace.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0), NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    
    private func connectToDB() {
      RealmManager.connect {
          success in
          if success {
              print("Connecting DB succes!")
          } else {
              print("Connecting DB failed...")
          }
      }
    }

    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

