//
//  WithLoaderIndicator.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 23.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

protocol WithLoadingIndicator: UIViewController {
    var loadingView: UIActivityIndicatorView { get }

    func showLoading()
    func hideLoading()
    func setupLoadingView() -> UIActivityIndicatorView
}

extension WithLoadingIndicator {
    
    func showLoading() {
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
    }
    
    func hideLoading() {
        self.loadingView.isHidden = false
        self.loadingView.stopAnimating()
    }
    
    func setupLoadingView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activity.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return activity
    }
}
