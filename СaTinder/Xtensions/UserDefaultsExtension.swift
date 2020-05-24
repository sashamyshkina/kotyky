//
//  UserDefaultsExtension.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 02.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


extension UserDefaults {
    
    func profile(_ key: String) -> ProfileViewModel? {
        guard let name = self.string(forKey: "name") else {
            return nil
        }
        
        let profile = ProfileViewModel()
        profile.name = name
        profile.age = self.string(forKey: "age")
        profile.bio = self.string(forKey: "bio")
        let imageData = self.data(forKey: "image")
        if let imageD = imageData, let image = UIImage(data: imageD) {
            profile.image = image
        }
       return profile
    }
    
    
    func set(_ profile: ProfileViewModel, forKey: String) {
        self.set(profile.name, forKey: "name")
        self.set(profile.image?.pngData(), forKey: "image")
        self.set(profile.bio, forKey: "bio")
        self.set(profile.bio, forKey: "age")
    }
    
    
    
}
