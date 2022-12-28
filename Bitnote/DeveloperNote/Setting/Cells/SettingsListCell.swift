//
//  SettingsListCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/26.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class SettingsListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    static let identifier = "settingListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsListCell", bundle: nil)
    }
    
}
