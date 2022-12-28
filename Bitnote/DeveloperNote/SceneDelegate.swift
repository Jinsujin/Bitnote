//
//  SceneDelegate.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/03.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        //        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = RootTabBarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            //url = widget://pr?url=1E86C9CC-5B60-4E48-9C4E-E3EBD206D146
            if url.absoluteString.starts(with: "widget://review") {
                guard let urlComponents = URLComponents(string: url.absoluteString) else { return }
                (self.window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//                print("urlComponents: ", urlComponents)
                //widget://pr?url=1E86C9CC-5B60-4E48-9C4E-E3EBD206D146
                
                // TODO: 선택한 노트의 상세화면으로 링크걸기
                // 1. 그룹 탭메뉴 화면으로 들어가기
                // 2. 선택한 노트의 그룹을 리스트중에서 찾아서, 그룹안으로 들어가기
                // 3. 선택한 노트를 노트리스트중에서 찾아, 그룹안으로 들어가기
            }
        }
    }
}

