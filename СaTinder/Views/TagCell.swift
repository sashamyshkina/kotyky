//
//  TagCell.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 18.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class TagCell: UICollectionViewCell {
     
    var label: UILabel = {
         let l = UILabel()
         l.text = "here tags"
         l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
         l.textColor = UIColor.lightText
         l.numberOfLines = 1
         l.textAlignment = .left
         return l
     }()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         addSubview(label)
         isSelected = false
         layer.borderWidth = 1
         label.translatesAutoresizingMaskIntoConstraints = false
         label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
         label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
         label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
         label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
         translatesAutoresizingMaskIntoConstraints = false
         widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
         heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
         layer.cornerRadius = frame.size.height/2
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
         
     override var isSelected: Bool {
         didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.superLightGreyColor
            label.textColor = isSelected ? UIColor.systemPink : UIColor.white
            layer.borderColor = isSelected ? UIColor.systemPink.cgColor : UIColor.clear.cgColor
        }
    }
}
     
