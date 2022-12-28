//
//  NoteDetailMemoCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/23.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class NoteDetailMemoCell: UITableViewCell {

    @IBOutlet weak var memoTextView: UITextView!
    
    static let identifier = "NoteDetailMemoCell"
    
    var touchUp: ((String) -> Void)?
    
    @IBAction func touchedCell(_ sender: Any) {
        touchUp?(memoTextView.text ?? "")
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib? {
        return UINib(nibName: "NoteDetailMemoCell", bundle: nil)
    }
}
