//
//  RatingView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 13.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class RatingView: UIView {

    
    lazy var starsList = populateStars(count: 5)
    
    var activeStars: Int = 0 {
        didSet {
            for i in 0..<activeStars {
                starsList[i].image = UIImage(named: "full_star")
                setNeedsDisplay()
            }
        }
    }
    
    func populateStars(count: Int) -> [UIImageView] {
        var starList = [UIImageView]()
        for _ in 0..<count {
            let s = UIImageView(image: UIImage(named: "empty_star"))
            s.translatesAutoresizingMaskIntoConstraints = false
            s.heightAnchor.constraint(equalToConstant: 15).isActive = true
            s.widthAnchor.constraint(equalToConstant: 15).isActive = true
            starList.append(s)
        }
        return starList
    }
    
    lazy var stackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: starsList)
        s.distribution = .equalCentering
        return s
    }()
    
    lazy var fullStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [headerLabel, stackView])
        s.distribution = .equalCentering
        s.alignment = .center
        s.axis = .horizontal
        return s
    }()
    
    var headerLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor(named: "text_color")
        l.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return l
    }()
    
    
    init(character: String) {
        super.init(frame: .init(x: 0, y: 0, width: 115, height: 40))
        setupView()
        isUserInteractionEnabled = true
        headerLabel.text = character
        for i in 0..<activeStars {
            starsList[i].image = UIImage(named: "full_star")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = true
        for i in 0..<activeStars {
            starsList[i].image = UIImage(named: "full_star")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(fullStackView)
        
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        fullStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        fullStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        fullStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    
    
    
}
