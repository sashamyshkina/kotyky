//
//  CardView.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 22.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class CardView: UIView {

    weak var delegate: CardDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment =  .left
            imageView.image = cardViewModel.image
        }
    }
    
    let imageView = UIImageView(image: nil)
    let infoLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()

    fileprivate let infoButton: UIButton = {
        let b = UIButton(type: .detailDisclosure)
        b.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
        return b
    }()
    
    fileprivate let translationTreshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.backgroundColor = .systemPink
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.pin4Sides()
        
        setupGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.pin(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 40))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        addSubview(infoButton)
        infoButton.pin(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 15, right: 15), size: CGSize(width: 50, height: 50))
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(gesture)
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > translationTreshold
        
        if shouldDismissCard {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                let transform = CGAffineTransform(translationX: 1000 * translationDirection, y: 0)
                self.transform = transform
            }) { (_) in
                if translationDirection == 1 {
                    self.delegate?.cardView(self, like: self.cardViewModel)
                } else {
                    self.delegate?.cardView(self, dislike: self.cardViewModel)
                }
                self.removeFromSuperview()
                self.delegate?.cardViewDidRemoved(self)
            }
        } else {
            self.transform = .identity
        }
    }

    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y:  translation.y)
    }
    
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            return
        }
    }
    
    @objc fileprivate func infoPressed() {
        delegate?.cardView(self, infoTappedOn: cardViewModel)
    }
}


protocol CardDelegate: class {
    func cardViewDidRemoved(_ cardView: CardView)
    func cardView(_ cardView: CardView, infoTappedOn: CardViewModel)
    func cardView(_ cardView: CardView, like: CardViewModel)
    func cardView(_ cardView: CardView, dislike: CardViewModel)
}
