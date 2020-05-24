//
//  CatCell.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 18.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class CatCell: UITableViewCell {
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Cat's name"
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.textColor = UIColor(named: "text_color")
        l.numberOfLines = 1
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    lazy var catImage: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "cat2")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(catImage)
        selectionStyle = .none
        catImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        catImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        catImage.heightAnchor.constraint(equalToConstant: frame.size.height/2).isActive = true
        catImage.widthAnchor.constraint(equalToConstant: frame.size.height/2).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: catImage.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        contentView.layer.borderColor = UIColor.systemPink.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = frame.size.height / 2
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        catImage.layer.cornerRadius = catImage.frame.width / 2
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
