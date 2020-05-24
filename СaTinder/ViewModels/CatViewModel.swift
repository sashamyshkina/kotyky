//
//  CardViewModel.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 22.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class CatViewModel {
    
    var apiClient: APIClientProtocol
    
    var cat: Cat
    
    var attributedString: NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: cat.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(String(describing: cat.shortDescr))", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return attributedText
    }
    
    var detailedDescription: String {
        return cat.description
    }
    
    let textAlignment: NSTextAlignment = .left
    
    var childFriendly: Int {
        return cat.breed.child_friendly
    }
    var strangerFriendly: Int {
        return cat.breed.stranger_friendly
    }
    var dogFriendly: Int {
        return cat.breed.dog_friendly
    }
    var intelligent: Int {
        return cat.breed.intelligence
    }
    var energyLevel: Int {
        return cat.breed.energy_level
    }
        
    init(_ cat: Cat, apiClient: APIClientProtocol = APIClient.shared) {
        self.cat = cat
        self.apiClient = apiClient
    }
    
    func prepareUI() {
        self.onImagesLoadStart?()
        
        DispatchQueue.global(qos: .userInitiated).async {
            switch self.apiClient.getImages(by: self.cat.breed) {
            case let .failure(error):
                print(error)
            case let .success(images):
                self.onImagesLoadEnd?()
                self.catImages = images ?? []
                self.onImagesLoadEnd?()
            }
        }
    }
    
    var catImages: [CatImage] = [] {
        didSet {
            self.loadImages()
        }
    }
    
    var images: [UIImage] = [] {
        didSet {
            onImagesUpdated?()
        }
    }
    func loadImages() {
        self.images = catImages.compactMap { (catImage) -> UIImage? in
            guard let url = URL(string: catImage.url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                return nil
            }
            return image
        }
    }
    
    // Events
    
    var onImagesLoadStart: (() -> ())?
    var onImagesLoadEnd: (() -> ())?
    var onImagesUpdated: (() -> ())?
}
