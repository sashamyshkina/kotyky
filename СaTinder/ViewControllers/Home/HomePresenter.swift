//
//  HomeViewModel.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 23.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class HomeViewPresenter: HomeViewPresenterProtocol {
    
    
    var apiClient: APIClientProtocol
    var filterManager: FilterManagerProtocol
    var vc: HomeViewControllerProtocol
    var favoriteManager: FavoriteManagerProtocol
    
    var allCats: [Cat] = [] // Все коты с сервера
    var preparedCats: [Cat] = [] // Готовые к употреблению ( с прогруженной картинкой )
    var shown: [Cat] = []
    
    required init(vc: HomeViewControllerProtocol, filterManager: FilterManagerProtocol = FilterManager.shared, apiClient: APIClientProtocol = APIClient.shared, favoriteManager: FavoriteManagerProtocol = FavoriteManager.shared) {
        self.vc = vc
        self.filterManager = filterManager
        self.apiClient = apiClient
        self.favoriteManager = favoriteManager
    }
    
    func reload() {
        self.allCats = []
        self.preparedCats = []
        self.shown = []
        
        DispatchQueue.main.async {
            self.vc.removeAllCards()
            self.vc.showLoading()
            self.vc.disableBottomButtons()
        }

        
        DispatchQueue.global().async {
            let result = self.apiClient.getBreeds()
            
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    self.vc.hideLoading()
                    self.vc.enableRefreshButton()
                    self.vc.enableFiltersButton()
                    self.vc.showError(error)
                }
            case let .success(breeds):
                let breeds = breeds ?? []
                
                if breeds.isEmpty {
                    DispatchQueue.main.async {
                        self.vc.showEmptyMessage()
                        self.vc.enableRefreshButton()
                        self.vc.enableFiltersButton()
                        self.vc.hideLoading()
                    }
                } else {
                    self.allCats = breeds.filter { self.filterManager.selected.match($0) }.map { Cat($0) }
                    self.allCats.shuffle()
                    
                    self.preloadCats()
                }
            }
        }
    }
    
    func showAllPrepared() {
        let count = preparedCats.count
        
        for _ in 0..<count {
            if let cat = preparedCats.popLast() {
                self.shown.append(cat)
                DispatchQueue.main.async {
                    self.vc.showCard(for: cat)
                    self.vc.enableBottomButtons()
                }
            }
        }
    }
    
    func preloadCats() {
        DispatchQueue.global(qos: .userInitiated).async {
            let count =  5 < self.allCats.count ? 5 : self.allCats.count
             
            let dispatchGroup = DispatchGroup()
            
            for i in 0..<count {
                dispatchGroup.enter()
                self.loadNextCat { (cat, error) in
                    dispatchGroup.leave()
                }
                dispatchGroup.wait()

            }
            dispatchGroup.notify(queue: .main) {
                self.vc.hideLoading()
                self.vc.enableRefreshButton()
                self.vc.enableFiltersButton()
                if self.preparedCats.isEmpty {
                    self.vc.showEmptyMessage()
                    self.vc.enableRefreshButton()
                    self.vc.enableFiltersButton()
                } else {
                    self.showAllPrepared()
                }
            }
        }
    }
    
    func loadNextCat(completion: @escaping (_ cat: Cat?, _ error: Error?) -> ()) {
        guard let cat = self.allCats.first else {
            completion(nil, nil)
            return
        }
        if !self.allCats.isEmpty {
            self.allCats.removeFirst()
        }
        
        DispatchQueue.global(qos: .userInitiated).async  {
            
            switch self.apiClient.getImages(by: cat.breed) {
                
            case let .failure(error):
                completion(nil, error)
                
            case let .success(images):
                
                guard let first = images?.first, let url = URL(string: first.url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                    completion(nil, nil)
                    return
                }
                
                cat.images = [image]
                self.preparedCats.append(cat)
                completion(cat, nil)
            }
        }
    }

    func prepareUI() {
        reload()
    }
    
    func tapOnFilterButton() {
        vc.openFiltersScreen()
    }
    
    
    func tapOnLikeButton() {
        self.vc.removeTopCard()
        if let cat = self.shown.first {
            self.cardRemoved(cat)
            self.swipeOnLike(for: cat)
        }
        
    }
    
    func tapOnDislikeButton() {
        self.vc.removeTopCard()
        if let cat = self.shown.first {
            self.cardRemoved(cat)
            self.swipeOnDislike(for: cat)
        }
    }
    
    func swipeOnLike(for cat: Cat) {
        switch self.favoriteManager.addToFavorite(cat) {
        case let .failure(error):
            self.vc.showError(error)
        case .success(_):
            DispatchQueue.main.async {
                self.vc.shakeFavoriteButton()
            }
        }
    }
    
    func showAndLoadNextCard(completion: @escaping (_ success: Bool) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
                        
            let disableButtons = self.shown.isEmpty
            
            if disableButtons {
                DispatchQueue.main.async {
                    self.vc.disableBottomButtons()
                }
            }
            DispatchQueue.main.async {
                self.vc.showLoading()
                self.vc.disableRefreshButton()
                self.vc.disableFiltersButton()
            }
    
            self.loadNextCat { (cat, error) in
                DispatchQueue.main.async {
                    self.vc.hideLoading()
                    self.vc.enableRefreshButton()
                    self.vc.enableFiltersButton()
                }
                
                if let error = error {
                    self.vc.showError(error)
                }
                
                if let cat = cat {
                    DispatchQueue.main.async {
                        
                        self.shown.append(cat)
                        if self.preparedCats.isEmpty {
                            self.preparedCats.removeFirst()
                        }
                        
                        DispatchQueue.main.async {
                            self.vc.enableBottomButtons()
                            self.vc.showCard(for: cat)
                        }
                        
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func swipeOnDislike(for cat: Cat) {
        
    }
    
    func tapOnProfileButton() {
        self.vc.openProfileScreen()
    }
    
    @objc func tapOnFavoritesList() {
        self.vc.openFavoritesListScreen()
    }
    
    func tapOnRefresh() {
        reload()
    }
    
    func filterViewControllerDismissed() {
        self.reload()
    }
    
    func tapOnInfoButton(on cardViewModel: CardViewModel) {
        self.vc.openDetailedScreen(for: cardViewModel.cat)
    }
    
    func cardRemoved(_ cardViewModel: CardViewModel) {
        self.cardRemoved(cardViewModel.cat)
    }
    
    func cardRemoved( _ cat: Cat) {
        if !self.shown.isEmpty {
            self.shown.removeFirst()
        }

        if self.shown.isEmpty {
            self.vc.disableBottomButtons()
        }
        
        self.showAndLoadNextCard { success in
            if self.preparedCats.isEmpty && self.allCats.isEmpty && self.shown.isEmpty {
                DispatchQueue.main.async {
                    self.vc.showEmptyMessage()
                }
            }
            
            if !success && self.shown.isEmpty {
                DispatchQueue.main.async {                    
                    self.vc.enableFiltersButton()
                    self.vc.enableRefreshButton()
                }
            }
        }
    }
}

protocol HomeViewPresenterProtocol: class {
    init(vc: HomeViewControllerProtocol, filterManager: FilterManagerProtocol, apiClient: APIClientProtocol, favoriteManager: FavoriteManagerProtocol)
    
    func prepareUI()
    
    func tapOnFilterButton()
    func tapOnLikeButton()
    func tapOnDislikeButton()
    func tapOnProfileButton()
    func tapOnFavoritesList()
    func tapOnRefresh()
    
    func swipeOnLike(for cat: Cat)
    func swipeOnDislike(for cat: Cat)
    
    func filterViewControllerDismissed()
    
    func tapOnInfoButton(on cardViewModel: CardViewModel)
    
    func cardRemoved(_ cardViewModel: CardViewModel)
}

protocol HomeViewControllerProtocol: WithShowError, WithLoadingIndicator {
    func openFiltersScreen()
    func openFavoritesListScreen()
    func openProfileScreen()
    func showCard(for: Cat)
    func showEmptyMessage()
    func removeAllCards()
    
    func disableBottomButtons()
    func enableBottomButtons()
    
    func disableLikeButton()
    func enableLikeButton()
    
    func disableDislikeButton()
    func enableDislikeButton()
    
    func disableFiltersButton()
    func enableFiltersButton()
    
    func disableRefreshButton()
    func enableRefreshButton()
    
    func shakeFavoriteButton()
    func openDetailedScreen(for cat: Cat)
    func removeTopCard()
}
