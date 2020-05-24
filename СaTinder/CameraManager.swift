//
//  CameraManager.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 24.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

protocol CameraManager {
    
    var chosenPhoto: UIImage? { get }
    
    func openCamera()
    
}
