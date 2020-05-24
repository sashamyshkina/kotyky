//
//  RegistrationPhotoView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 22.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class RegistrationPhotoView: UIImageView {
    
    var cameraManager: CameraManager!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        addGestureRecognizer(gesture)
    }
    
    fileprivate func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        contentMode = .scaleAspectFill
        layer.cornerRadius = 16
        layer.masksToBounds = true
        let cameraImage = UIImageView(image: UIImage(named:"camera"))
        cameraImage.contentMode = .scaleAspectFill
        addSubview(cameraImage)
        cameraImage.center(size: CGSize(width: 60, height: 60))
        cameraImage.alpha = 0.6
        let label = UILabel()
        label.text = NSLocalizedString(Const.addProfilePhoto, comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .gray
        label.contentMode = .center
        addSubview(label)
        label.center(-60)
        label.sizeToFit()
    }

    
    @objc private func handleGesture(gesture: UITapGestureRecognizer) {
        cameraManager.openCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    fileprivate func updateBorder() {
        if cameraManager.chosenPhoto == nil {
            self.addBorder()
        } else {
            self.removeLayer(layerName: Const.borderLayerName)
            self.layer.layoutSublayers()
        }
    }
    
    func updateImage(_ im: UIImage?) {
        
        guard let img = im else {
            return
        }
        for v in subviews {
            v.isHidden = true
        }
        image = img
        image?.withRenderingMode(.alwaysOriginal)
        layoutSubviews()
    }
}
