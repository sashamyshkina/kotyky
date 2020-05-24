//
//  Filter.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 21.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

protocol Filter: class {
    var name: String { get set }
    func match(_ breed: Breed) -> Bool
}

extension Array where Element == Filter {
    func match(_ breed: Breed) -> Bool {
        return self.reduce(true) { (result, filter) -> Bool in
            return !result ? result : filter.match(breed)
        }
    }
}

class IntellegentFilter: Filter {
    var name: String = Const.intellegent
    
    func match(_ breed: Breed) -> Bool {
        return breed.intelligence >= 3
    }
}

class ChilFriendlyFilter: Filter {
    var name: String = Const.child_friendly
    
    func match(_ breed: Breed) -> Bool {
        return breed.intelligence >= 3
    }
}

class StrangerFriednlyFilter: Filter {
    var name: String = Const.stranger_friendly
    
    func match(_ breed: Breed) -> Bool {
        return breed.stranger_friendly >= 3
    }
}

class RareFilter: Filter {
    var name: String = Const.rare
    
    func match(_ breed: Breed) -> Bool {
        return breed.rare == 1
    }
}

class ShortLegsFilter: Filter {
    var name: String = Const.short_legs
    
    func match(_ breed: Breed) -> Bool {
        return breed.short_legs == 1
    }
}

class EnergeticFilter: Filter {
    var name: String = Const.energetic
    
    func match(_ breed: Breed) -> Bool {
        return breed.energy_level >= 3
    }
}

class IndoorFilter: Filter {
    var name: String = Const.stayHome
    
    func match(_ breed: Breed) -> Bool {
        return breed.indoor == 1
    }
}

class DogfriendlyFilter: Filter {
    var name: String = Const.dog_friendly
    
    func match(_ breed: Breed) -> Bool {
        return breed.dog_friendly >= 3
    }
}

class HairlessFilter: Filter {
    var name: String = Const.hairless
    
    func match(_ breed: Breed) -> Bool {
        return breed.hairless >= 3 && breed.intelligence <= 5
    }
}

class NonallergyFilter: Filter {
    var name: String = Const.hypoallergenic
    
    func match(_ breed: Breed) -> Bool {
        return breed.hypoallergenic == 1
    }
}

class TailFilter: Filter {
    var name: String = Const.suppressed_tail
    
    func match(_ breed: Breed) -> Bool {
        return breed.suppressed_tail == 1
    }
}

protocol FilterManagerProtocol {
    var filters: [Filter] { get }
    var selected: [Filter] { get }
    
    func isSelected(_ filter: Filter) -> Bool
    
    func setSelected(_ filter: Filter)
    func setDeselected(_ filter: Filter)
}

extension FilterManagerProtocol {
    func isSelected(_ filter: Filter) -> Bool {
        return selected.contains { (f) -> Bool in
            return f.name == filter.name
        }
    }
}


class FilterManager: FilterManagerProtocol {
    
    static let shared = FilterManager()
    
    var filters: [Filter] = [IntellegentFilter(), ChilFriendlyFilter(), StrangerFriednlyFilter(), NonallergyFilter(), IndoorFilter(), EnergeticFilter(), ShortLegsFilter(), RareFilter(), DogfriendlyFilter(), HairlessFilter(), TailFilter()]
    
    var selected: [Filter] = []
    
    func setSelected(_ filter: Filter) {
        selected.append(filter)
    }
    
    func setDeselected(_ filter: Filter) {
        selected = selected.filter { $0.name != filter.name }
    }
}
