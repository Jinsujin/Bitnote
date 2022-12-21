//
//  NoteListCell.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/08.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class NoteListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var isEditMode: Bool = false
    
    override var isEditing: Bool {
        didSet {
            if isEditMode && isEditing { // 삭제 활성화
                self.deleteButton.isHidden = false
            } else {
                self.deleteButton.isHidden = true
            }
        }
    }
    
    
    var onDelete: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }

    @IBAction func touchedDeleteButton(_ sender: Any) {
        onDelete?()
    }
    
    func setViewModel(viewModel : Note) {
//        viewModel.title.bind(title.rx.text)
        reviewCountLabel.text = ""//"lesson_count_%d".localized(with: viewModel.reviewcount, comment: "review count")
        
        if viewModel.isDone {
            self.titleLabel.attributedText =
            NSMutableAttributedString().strikethrough(viewModel.title)
            titleLabel.textColor = .gray
        } else {
            titleLabel.attributedText = NSMutableAttributedString().regular(string: viewModel.title, fontSize: 16)
            titleLabel.textColor = .black
        }
    }

}
