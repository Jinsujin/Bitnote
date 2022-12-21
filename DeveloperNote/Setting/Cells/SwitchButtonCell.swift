//
//  SwitchButtonCell.swift
//  DeveloperNote
//
//  Created by jsj on 2021/03/24.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import UIKit

class SwitchButtonCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SwitchButtonCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SwitchButtonCell", bundle: nil)
    }
}
