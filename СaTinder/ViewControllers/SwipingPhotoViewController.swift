//
//  SwipingPhotoViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 12.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class SwipingPhotoController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var model: CatViewModel!
    
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    
    var controllers: [PhotoController] = [] {
        didSet {
            self.setupBarViews()
        }
    }
    
    
    fileprivate func setupBarViews() {
        dataSource = self
        delegate = self
        
        barsStackView.arrangedSubviews.forEach { (v) in
            self.barsStackView.removeArrangedSubview(v)
        }
        
        controllers.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = .halfWhite
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .systemPink
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
        view.addSubview(barsStackView)
        let paddingTop = 8
        barsStackView.pin(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: CGFloat(paddingTop), left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = .halfWhite})
            barsStackView.arrangedSubviews[index].backgroundColor = .systemPink
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.controllers.firstIndex(where: {$0 == viewController}), index < (controllers.count - 1)  else {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.controllers.firstIndex(where: {$0 == viewController}), index > 0 else {
            return nil
        }
        return controllers[index - 1]
    }

}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "cat2"))
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.pin4Sides()
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
