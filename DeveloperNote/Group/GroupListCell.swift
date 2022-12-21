//
//  GroupListCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/08.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setViewModel(viewModel : Group) {
//        viewModel.title.bind(title.rx.text)
        
        titleLabel.text = viewModel.title
        countLabel.text = "group_note_count%d".localized(with: viewModel.notelist?.count ?? 0, comment: "note count")
    }
    
}
