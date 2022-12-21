//
//  SettingsViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/24.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit
import MessageUI


struct SettingModel {
    let sectionTitle: String
    let menus: [SettingEtcType]
}


enum SettingEtcType {
    case version
    case inquiry // 문의메일
    case license
    case lesson
    
    var title: String {
        switch self {
        case .version:
            return "settings_version".localized()
        case .lesson:
            return "settings_study".localized()
        case .inquiry:
            return "settings_inquiry".localized()
        case .license:
            return "settings_licenses".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .version:
            return #imageLiteral(resourceName: "icon_info")
        case .lesson:
            return #imageLiteral(resourceName: "ico_lesson").withRenderingMode(.alwaysTemplate)
        case .inquiry:
            return #imageLiteral(resourceName: "icon_inquiry")
        case .license:
            return #imageLiteral(resourceName: "icon_license")
        }
    }
}


/**
    기타
 앱버전 - 링크 X
 문의 - 메일보내기 present
 앱스토어 리뷰
 라이선스 - present
 */
class SettingsViewController: AdsBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let adminEmail = "sylpid003@gmail.com"
    var settingModel = [SettingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "settings_title".localized()
        
        tableView.register(SettingsListCell.nib(), forCellReuseIdentifier: SettingsListCell.identifier)
        tableView.register(SettingsListAppVersionCell.nib(), forCellReuseIdentifier: SettingsListAppVersionCell.identifier)
        
        settingModel.append(
            SettingModel(sectionTitle: "기타", menus: [
                .version, .lesson, .inquiry, .license
            ])
        )
    }

}

// MARK:- TableView Delegate&DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingModel[section].menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingModel[indexPath.section].menus[indexPath.row]
        switch item {
        case .version:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsListAppVersionCell.identifier, for: indexPath) as! SettingsListAppVersionCell
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell.versionLabel.text = appVersion ?? ""
            return cell
            
        case .inquiry, .license, .lesson:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsListCell.identifier, for: indexPath) as! SettingsListCell
            cell.titleLabel.text = item.title
            cell.iconImage.image = item.image
            cell.iconImage.tintColor = UIColor(named: "main_accent")
            return cell
        }
   
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = settingModel[indexPath.section].menus[indexPath.row]
        switch item {
        case .lesson:
            let vc = SettingLessonViewController()
            navigationController?.pushViewController(vc, animated: true)
            break
        case .inquiry:
            if !MFMailComposeViewController.canSendMail() {
               print("Mail services are not available")
                return
           }
            
            // 메일 보내기
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let messageBodyText =
                "Device: \(UIDevice.modelName)" +
                "\nSystemVersion: \(UIDevice.current.systemVersion)" +
                "\nAppVersion: \(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""))" +
                "\nLanguage: \(String(describing: Locale.current.languageCode ?? ""))"
            composeVC.setToRecipients([adminEmail])
            composeVC.setMessageBody(messageBodyText, isHTML: false)

            self.present(composeVC, animated: true, completion: nil)
            
        case .license:
            let vc = SettingLicenseViewController(nibName: "SettingLicenseViewController", bundle: nil)
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}




// MARK:- Mail Delegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        
//        if !MFMailComposeViewController.canSendMail(){
//            print("메일을 보낼수 없습니다")
//        }
//    }
    // 취소 눌렀을때
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
