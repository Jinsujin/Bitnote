//
//  NoteDetailImageCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/23.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class NoteDetailImageCell: UITableViewCell {

    static let identifier = "NoteDetailImageCell"
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib? {
        return UINib(nibName: "NoteDetailImageCell", bundle: nil)
    }
}
