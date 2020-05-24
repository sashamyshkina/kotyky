//
//  UIImageView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 27.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

extension UIImageView {
    
  public func maskCircle(anyImage: UIImage) {
    self.contentMode = UIView.ContentMode.scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true
    self.image = anyImage
  }
    
    
    public func loadImage(from url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = NSURL(string: url)! as URL
            if let imageData: NSData = NSData(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData as Data)
                }
            }
            
        }
    }
    
}
