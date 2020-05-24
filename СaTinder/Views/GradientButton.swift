//
//  GradientButton.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 04.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.buttonOrangeColor.cgColor, UIColor.systemPink.cgColor]
        l.cornerRadius = self.layer.cornerRadius
        l.startPoint = CGPoint(x: 0, y: 0.7)
        l.endPoint = CGPoint(x: 1, y: 0.3)
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
