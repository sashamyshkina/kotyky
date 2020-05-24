//
//  FavoriteManager.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import Foundation

class FavoriteManager: FavoriteManagerProtocol {
    
    static let shared = FavoriteManager()
    
    private var favorites: [Cat] = []
    
    func getFavorites() -> Result<[Cat], Error> {
        return .success(self.favorites)
    }
    
    func addToFavorite(_ cat: Cat) -> Result<Bool, Error> {
        switch isFavorite(cat) {
        case let .failure(error):
            return .failure(error)
        case let .success(already):
            if already {
                return .success(false)
            }
            self.favorites.append(cat)
            return .success(true)
        }
    }
    
    func removeFromFavorite(_ cat: Cat) -> Result<Bool, Error> {
        favorites = favorites.filter { $0.name != cat.name }
        return .success(true)
    }
    
    func isFavorite(_ cat: Cat) -> Result<Bool, Error> {
        return .success(self.favorites.contains(where: { (item) -> Bool in
            return item.name == cat.name
        }))
    }
}


protocol FavoriteManagerProtocol {
    func getFavorites() -> Result<[Cat], Error>
    func addToFavorite(_ cat: Cat) -> Result<Bool, Error>
    func removeFromFavorite(_ cat: Cat) -> Result<Bool, Error>
    func isFavorite(_ cat: Cat) -> Result<Bool, Error>
}

