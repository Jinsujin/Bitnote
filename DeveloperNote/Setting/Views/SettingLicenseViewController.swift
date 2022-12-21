//
//  SettingLicenseViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/24.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit


struct LicenseModel {
    let sectionTitle: String
    let licenseList: [String]
}


class SettingLicenseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var licenseModels = [LicenseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem?.title = "settings_licenses".localized()
        navigationBar.topItem?.leftBarButtonItem?.title = "button_close".localized()
        
        licenseModels.append(
            LicenseModel(sectionTitle: "settings_opensources".localized(), licenseList: ["Firebase", "Toast-Swift", "RxSwift", "Google-Mobile-Ads-SDK"])
        )
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "licenseCell")
    }

    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Tableview delegate & datasource
extension SettingLicenseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return licenseModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenseModels[section].licenseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath)
        
        cell.textLabel?.text = licenseModels[indexPath.section].licenseList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return licenseModels[section].sectionTitle
    }
    
}
