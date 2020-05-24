//
//  TopNavigationStackView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 21.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let profileButton = UIButton(type: .system)
    let favCatsButton = UIButton(type: .system)
    let catImageView = UIImageView(image: UIImage(named: "paw_print"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        catImageView.contentMode = .scaleAspectFit
        profileButton.setImage(#imageLiteral(resourceName: "03_6").withRenderingMode(.alwaysOriginal), for: .normal)
        favCatsButton.setImage(#imageLiteral(resourceName: "03_8").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [profileButton, UIView(), catImageView, UIView(), favCatsButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    

    required init(coder: NSCoder) {
        fatalError()
    }
}
