//
//  ViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 21.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlsStackView()
    let deckView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()
        setupCards()
    }

    
    fileprivate func setupCards() {
        let cardView = CardView()
        deckView.addSubview(cardView)
        cardView.pin4Sides()
    }
    
    
    fileprivate func createLayout() {
        let overallStackview = UIStackView(arrangedSubviews: [topStackView, deckView, buttonStackView])
        overallStackview.axis = .vertical
        view.addSubview(overallStackview)
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackview.isLayoutMarginsRelativeArrangement = true
        overallStackview.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackview.bringSubviewToFront(deckView)
                
    }

}

