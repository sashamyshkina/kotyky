//
//  InfoViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 05.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, WithLoadingIndicator {
    
    lazy var loadingView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: swipingPhotosController.view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: swipingPhotosController.view.centerYAnchor).isActive = true
        activity.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return activity
    }()
    

    var viewModel: CatViewModel? {
        didSet {
            configureData()
        }
    }
    
    func configureData() {
        guard let model = viewModel else {
            return
        }
        
        childFriendly_view.activeStars = model.childFriendly as Int
        strangerFriendly_view.activeStars = model.strangerFriendly as Int
        intelligence_view.activeStars = model.intelligent as Int
        energyLevel_view.activeStars = model.energyLevel as Int
        dogFriendly_view.activeStars = model.dogFriendly as Int
        
        infoTextLabel.attributedText = model.attributedString
        descriptionLabel.text = model.detailedDescription

        
        viewModel?.onImagesUpdated = {
            DispatchQueue.main.async {
                self.swipingPhotosController.controllers = (self.viewModel?.images ?? []).map { PhotoController(image: $0) }
                guard let photoController = self.swipingPhotosController.controllers.first else {
                    return
                }
                self.swipingPhotosController.setViewControllers([photoController], direction: .forward, animated: true, completion: nil)
            }
        }
        viewModel?.onImagesLoadStart = {
            DispatchQueue.main.async {
                self.showLoading()
                self.swipingPhotosController.view.isUserInteractionEnabled = false
            }
        }
        viewModel?.onImagesLoadEnd = {
            DispatchQueue.main.async {
                self.hideLoading()
                self.swipingPhotosController.view.isUserInteractionEnabled = true
            }
        }
        
        // preload first image
        self.swipingPhotosController.controllers = [self.viewModel?.cat.mainImage].compactMap { image in
            if let image = image {
                return PhotoController(image: image)
            } else {
                return nil
            }
        }
        if let controller = self.swipingPhotosController.controllers.first {
            self.swipingPhotosController.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        }
        
        // load other images
        
        self.viewModel?.prepareUI()
    }
    
    var childFriendly_view = RatingView(character: NSLocalizedString(Const.child_friendly, comment: ""))
    var strangerFriendly_view = RatingView(character: NSLocalizedString(Const.stranger_friendly, comment: ""))
    var intelligence_view = RatingView(character: NSLocalizedString(Const.intellegent, comment: ""))
    var energyLevel_view = RatingView(character: NSLocalizedString(Const.energetic, comment: ""))
    var dogFriendly_view = RatingView(character: NSLocalizedString(Const.dog_friendly, comment: ""))
    
    let infoview: UIView = {
        let s = UIView()
        return s
    }()
    
    let swipingPhotosController = SwipingPhotoController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    lazy var infoTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UITextView = {
        let label = UITextView()
        label.showsVerticalScrollIndicator = true
        label.isEditable = false
        label.isScrollEnabled = true
        label.scrollRangeToVisible(NSMakeRange(0, 0))
        label.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        label.textColor = .textGreyColor
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var starStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [childFriendly_view, strangerFriendly_view, intelligence_view, energyLevel_view, dogFriendly_view])
        stackView.distribution = .equalSpacing
        stackView.spacing = 1
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        let sideInset: CGFloat = 16
        let sideInsetForText: CGFloat = 14

        view.backgroundColor = .systemBackground
        view.addSubview(infoview)
        infoview.pin4Sides()
        let swipingView = swipingPhotosController.view!
        view.addSubview(swipingView)
        

        //images
        swipingView.translatesAutoresizingMaskIntoConstraints = false
        swipingView.heightAnchor.constraint(equalTo: infoview.heightAnchor, multiplier: 0.4).isActive = true
        swipingView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        swipingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        swipingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        

        infoview.addSubview(starStack)
        starStack.translatesAutoresizingMaskIntoConstraints = false
        starStack.heightAnchor.constraint(equalTo: infoview.heightAnchor, multiplier: 0.15).isActive = true
        starStack.bottomAnchor.constraint(equalTo: infoview.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        starStack.leadingAnchor.constraint(equalTo: infoview.leadingAnchor, constant: sideInset).isActive = true
        starStack.trailingAnchor.constraint(equalTo: infoview.trailingAnchor, constant: -sideInset).isActive = true
        
        let containerView = UIView()
        infoview.addSubview(containerView)
        containerView.pin(top: swipingView.bottomAnchor, leading: infoview.leadingAnchor, bottom: starStack.topAnchor, trailing: infoview.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
       
        containerView.addSubview(infoTextLabel)
        
        infoTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        infoTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideInset).isActive = true
        infoTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideInset).isActive = true
        infoTextLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4).isActive = true
        infoTextLabel.minimumScaleFactor = 0.8
        infoTextLabel.adjustsFontSizeToFitWidth = true
        infoTextLabel.lineBreakMode = .byClipping
        
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideInsetForText).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideInsetForText).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: infoTextLabel.bottomAnchor, constant: sideInsetForText).isActive = true


    }
    
}
