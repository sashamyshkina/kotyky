//
//  HomeBottomControlsStackView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 21.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func configureButton(with image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let reloadButton = configureButton(with: UIImage(named: "03_1")!)
    let dislikeButton = configureButton(with: UIImage(named: "03_2")!)
    let likeButton = configureButton(with: UIImage(named: "03_4")!)
    let filtersButton = configureButton(with: UIImage(named: "03_5")!)
    lazy var buttons: [UIButton] = [reloadButton, dislikeButton, likeButton, filtersButton]

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        buttons.forEach { (button) in
            addArrangedSubview(button)
        }

        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
