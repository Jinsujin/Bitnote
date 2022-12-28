//
//  BaseNavigationController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/04.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
