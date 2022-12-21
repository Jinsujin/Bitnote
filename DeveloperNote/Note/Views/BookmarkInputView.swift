//
//  BookmarkInputView.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/25.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit


class BookmarkInputView: UIView {
    public let urlTextfield: UITextField = {
        let t = UITextField()
        t.placeholder = "http://"
        t.returnKeyType = .done
        t.autocorrectionType = .no
        t.keyboardType = .URL
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    public let confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("button_ok".localized(), for: .normal)
        btn.backgroundColor = .darkGray
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.backgroundColor = .white
        self.addSubview(confirmButton)
        self.addSubview(urlTextfield)
        NSLayoutConstraint.activate([
            confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            confirmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 50),
            urlTextfield.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            urlTextfield.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -10),
            urlTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
