//
//  PrivacyView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class PrivacyView: UIView {
    
    var registrationViewModel = ProfileViewModel.shared
    
    var button = UIButton()
    var label = UILabel()
    var privacyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        button = UIButton()
        button.setImage(UIImage(named: "empty_checkbox"), for: UIControl.State.normal)
        button.setImage(UIImage(named: "full_checkbox"), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(checkboxTapped(_:)), for: UIControl.Event.touchUpInside)

        label.text = NSLocalizedString(Const.accept, comment: "")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        label.textColor = .black
        
        let policyString = NSAttributedString(string: NSLocalizedString(Const.catsPolicy, comment: ""), attributes: [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor : UIColor.blue
        ])
        privacyButton.setAttributedTitle(policyString, for: .normal)
        privacyButton.addTarget(self, action: #selector(descrTapped), for: UIControl.Event.touchUpInside)
        privacyButton.setTitleColor(.blue, for: .normal)
        privacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        
        let horStackView = UIStackView(arrangedSubviews: [
            button,
            label,
            privacyButton
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        horStackView.spacing = 4
        horStackView.alignment = .center
        horStackView.distribution = .equalCentering
        horStackView.axis = .horizontal
        horStackView.backgroundColor = .yellow
        addSubview(horStackView)
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.center(with: 0, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    

    @objc func checkboxTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        registrationViewModel.privacyCheck = button.isSelected
    }
    
    
    @objc func descrTapped() {
        guard let url = URL(string: Const.privacyURL)  else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    
}
