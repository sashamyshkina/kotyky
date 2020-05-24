//
//  ProfileCellView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 27.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class ProfileCellView: UIView, UITextFieldDelegate {
    
    var mainLabel = UILabel()
    var textField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor(named: "bg_grey")
        mainLabel = UILabel()
        mainLabel.textAlignment = .left
        mainLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        mainLabel.textColor = UIColor.systemGray
        mainLabel.text = NSLocalizedString(Const.name, comment: "")
        textField.backgroundColor = UIColor.systemBackground
        textField.textColor = UIColor(named: "text_color")

        self.addSubview(mainLabel)
        self.addSubview(textField)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.5).isActive = true
        textField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        textField.borderStyle = .none

        let padding: CGFloat = 15
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 20))
        let outerViewRight = UIView(frame: CGRect(x: CGFloat(textField.frame.size.width - 35), y: 0, width: CGFloat(30), height: CGFloat(20)))
        let imageView = UIImageView(frame: CGRect(x: -padding, y: 0, width: 18, height: 18))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.33
        imageView.image = UIImage(named: "edit")!
        outerViewRight.addSubview(imageView)

        textField.rightView = outerViewRight
        textField.rightViewMode = .always

        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        
    }
    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
}
