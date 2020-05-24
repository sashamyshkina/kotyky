//
//  Breed.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 19.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

struct Breed: Codable {
    
    var name: String
    var id: String
    var dog_friendly: Int
    var child_friendly: Int
    var stranger_friendly: Int
    var energy_level: Int
    var hairless: Int
    var hypoallergenic: Int
    var indoor: Int
    var intelligence: Int
    var suppressed_tail: Int
    var temperament: String
    var short_legs: Int
    var rare: Int
    var description: String
    var life_span: String
}


struct CatImage: Codable {
    var id: String
    var url: String
    
    var breeds: [Breed]
}
