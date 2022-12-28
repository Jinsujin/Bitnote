//
//  ViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/03.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SnapKit


extension Bundle {
    var apiKey: String {
        guard let filePath = self.path(forResource: "APIKeyInfo", ofType: "plist") else {
            fatalError("Not found file: APIKeyInfo.plist")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "GOOGLE_AD_TEST_KEY") as? String  else {
            fatalError("Not found key in 'APIKeyInfo.plist' file")
        }
        return value
    }
}


class AdsBaseViewController: UIViewController {

    private var bannerView: GADBannerView!
    
    // MARK:- 실제 컨텐츠가 들어갈 뷰
//    public let contentsView: UIView = {
//        let v = UIView()
//        v.backgroundColor = .yellow
//        return v
//    }()
//

    
    // Warning:- Change banner test id
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.delegate = self
        bannerView.rootViewController = self

        // TODO:- test id 변경
        bannerView.adUnitID = Bundle.main.apiKey
        bannerView.load(GADRequest())
        
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(named: "contents_gray")
//        let tabbarHeight = (tabBarController?.tabBar.frame.height ?? 0)
//        self.view.addSubview(contentsView)
//        contentsView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.view)
//            make.left.equalTo(self.view)
//            make.right.equalTo(self.view)
//            make.bottom.equalTo(self.view).offset(-(tabbarHeight + kGADAdSizeBanner.size.height + 18))
//        }
    }
    
}

// MARK:- GADBannerViewDelegate
extension AdsBaseViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("😃 Banner loaded successfully")
        addBannerViewToView(bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("😨 Fail to receive ads")
        print(error.localizedDescription)
    }

    private func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
//        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
     }
}
