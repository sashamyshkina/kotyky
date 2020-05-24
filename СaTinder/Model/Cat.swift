//
//  Cat.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 22.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class Cat {
    var breed: Breed
    
    var name: String {
        return breed.name
    }
    
    var description: String {
        return breed.description
    }
    
    var shortDescr: String {
        return breed.temperament
    }

    var mainImage: UIImage? {
        return images?.first
    }
    
    var images: [UIImage]?
    
    init(_ breed: Breed) {
        self.breed = breed
    }
    
    func convertToCardVM() -> CardViewModel  {
        return CardViewModel(cat: self)
    }
}
