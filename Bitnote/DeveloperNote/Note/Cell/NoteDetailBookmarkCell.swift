//
//  NoteDetailBookmarkCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/23.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class NoteDetailBookmarkCell: UITableViewCell {

    static let identifier = "NoteDetailBookmarkCell"
    
    @IBOutlet weak var urlLinkButton: UIButton!
    
    
    var touchUp: ((String) -> Void)?
    
    @IBAction func touchedOpenWebviewButton(_ sender: Any) {
        
        touchUp?(urlLinkButton.titleLabel?.text ?? "")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NoteDetailBookmarkCell", bundle: nil)
    }
    
}
