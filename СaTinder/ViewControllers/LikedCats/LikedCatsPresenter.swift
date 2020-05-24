//
//  LikedCatsPresenter.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import Foundation

protocol LikedCatsPresenterProtocol {
    init(_ vc: LikedCatsViewControllerProtocol, favoriteManager: FavoriteManagerProtocol)
    
    func prepareUI()
    func catsCount() -> Int
    func catBy(index: Int) -> Cat?
    func tapOn(_ cat: Cat)
    func tapOnRemove(_ cat: Cat)
    func tapOnInfo(_ cat: Cat)
}

protocol LikedCatsViewControllerProtocol: WithLoadingIndicator, WithShowError {
    func reload()
    func showTable()
    func hideTable()
    func showEmptyLabel()
    func hideEmptyLabel()
    func presentAlertWithActions(for cat: Cat)
    func presentInfoScreen(for cat: Cat)
}

class LikedCatsPresenter: LikedCatsPresenterProtocol {
    
    var vc: LikedCatsViewControllerProtocol
    var favoriteManager: FavoriteManagerProtocol
    
    var cats: [Cat] = []
    
    required init(_ vc: LikedCatsViewControllerProtocol, favoriteManager: FavoriteManagerProtocol = FavoriteManager.shared) {
        self.vc = vc
        self.favoriteManager = favoriteManager
    }
    
    func prepareUI() {
        DispatchQueue.main.async {
            self.vc.showLoading()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.updateData()
            DispatchQueue.main.async {
                self.vc.hideLoading()
            }
        }
    }
    
    func catsCount() -> Int {
        return cats.count
    }
    
    func catBy(index: Int) -> Cat? {
        return cats[index]
    }
    
    func tapOn(_ cat: Cat) {
        self.vc.presentAlertWithActions(for: cat)
    }
    
    private func updateData() {
        switch self.favoriteManager.getFavorites() {
        case let .failure(error):
            DispatchQueue.main.async {
                self.vc.showError(error)
            }
        case let .success(cats):
            self.cats = cats
            
            DispatchQueue.main.async {
                if self.cats.isEmpty {
                    self.vc.showEmptyLabel()
                    self.vc.hideTable()
                } else {
                    self.vc.hideEmptyLabel()
                    self.vc.showTable()
                }
                self.vc.reload()
            }
        }
    }
    
    func tapOnRemove(_ cat: Cat) {
        DispatchQueue.global(qos: .userInitiated).async {
            switch self.favoriteManager.removeFromFavorite(cat) {
            case let .failure(error):
                DispatchQueue.main.async {
                    self.vc.showError(error)
                }
            case .success(_):
                self.updateData()
            }
        }
    }
    
    func tapOnInfo(_ cat: Cat) {
        self.vc.presentInfoScreen(for: cat)
    }
}
