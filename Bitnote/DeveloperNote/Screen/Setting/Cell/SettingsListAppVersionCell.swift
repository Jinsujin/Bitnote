//
//  SettingsListAppVersionCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/26.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class SettingsListAppVersionCell: UITableViewCell {
    static let identifier = "appVersionCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "settings_version".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsListAppVersionCell", bundle: nil)
    }
    
}
