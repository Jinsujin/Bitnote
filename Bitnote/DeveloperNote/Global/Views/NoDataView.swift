//
//  NoDataView.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/31.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "nodata_title".localized()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = UIColor(hex: "747474")
        return l
    }()
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.text = "nodata_message".localized()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textColor = UIColor(hex: "8E8E8E")
        l.numberOfLines = 0
        return l
    }()
    
    private let nodataImage: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "img_nodata"))
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        let stackView = UIStackView(arrangedSubviews: [
            nodataImage, titleLabel, contentLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        self.addSubview(stackView)
        
        nodataImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            nodataImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}
