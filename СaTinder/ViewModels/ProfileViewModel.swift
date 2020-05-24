//
//  RegistrationViewModel.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class ProfileViewModel {

    static var shared = ProfileViewModel()
    var name: String?
    var image: UIImage?
    var privacyCheck: Bool = false
    var age: String? = nil
    var bio: String? = nil
    var registrationAllowed: Bool {
        return checkValue()
    }
    
   func checkValue() -> Bool {
        if name != nil && image != nil && privacyCheck == true {
            return true
        } else {
            return false
        }
    }
    
    func saveData(name: String?, age: String?, bio: String?, image: UIImage?) {
        self.name = name
        self.age = age
        self.bio = bio
        self.image = image
        UserDefaults.standard.set(self, forKey: "profile")
    }
    
    func removeData() {
        saveData(name: nil, age: nil, bio: nil, image: nil)
    }
}



