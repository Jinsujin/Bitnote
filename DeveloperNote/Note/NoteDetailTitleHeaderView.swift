//
//  NoteDetailTitleHeaderView.swift
//  DeveloperNote
//
//  Created by jsj on 2021/09/16.
//  Copyright © 2021 Tomatoma. All rights reserved.
//


import UIKit

class NoteDetailTitleHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "note_add_placeholder_title".localized()
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    
    private func setupViews() {
        self.backgroundColor = .white
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor(hex: "F0F0F0")
        topLine.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex: "F0F0F0")
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleTextfield)
        self.addSubview(topLine)
        self.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            titleTextfield.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            titleTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleTextfield.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
            topLine.topAnchor.constraint(equalTo: self.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
