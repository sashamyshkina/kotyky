//
//  CardViewModel.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

struct CardViewModel {
    let cat: Cat
    
    var image: UIImage {
        return cat.mainImage!
    }
    
    var attributedString: NSAttributedString {
        let attributedText = NSMutableAttributedString(string: cat.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])

        attributedText.append(NSAttributedString(string: "\n\(String(describing: cat.shortDescr))", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return attributedText
    }
}
