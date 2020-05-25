//
//  ViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 21.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, WithLoadingIndicator, WithShowError {
    
    let deckView = UIView()
    
    lazy var loadingView: UIActivityIndicatorView = {
        return self.setupLoadingView()
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(Const.noCats, comment: "")
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 30)
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        return label
    }()
    
    lazy var topStackView: TopNavigationStackView = {
        let topNav = TopNavigationStackView()
        topNav.profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
        topNav.favCatsButton.addTarget(self, action: #selector(likedCatsVCButton), for: .touchUpInside)
        return topNav
    }()
    
    let buttonStackView: HomeBottomControlsStackView = {
        let bottomControls = HomeBottomControlsStackView()
        bottomControls.reloadButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        bottomControls.filtersButton.addTarget(self, action:  #selector(openFilters), for: .touchUpInside)
        return bottomControls
    }()

    lazy var overallStackview: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.topStackView, self.deckView, self.buttonStackView])
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        self.view.addSubview(stack)
        stack.pin(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        return stack
    }()
    
    var presenter: HomeViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = HomeViewPresenter(vc: self)

        self.view.backgroundColor = .systemBackground
        overallStackview.backgroundColor = .clear
        self.presenter.prepareUI()
    }
    
    
    @objc func likedCatsVCButton() {
        presenter.tapOnFavoritesList()
    }
    
    @objc func openFilters() {
        presenter.tapOnFilterButton()
    }
    
    @objc func handleRefresh() {
        presenter.tapOnRefresh()
    }
    
    @objc func handleLike() {
        presenter.tapOnLikeButton()
    }
    
    @objc func handleDislike() {
        presenter.tapOnDislikeButton()
    }
    
    @objc func handleProfileButton() {
        presenter.tapOnProfileButton()
    }
    
    
    func showLoading() {
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        self.emptyLabel.isHidden = true
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func shakeFavoriteButton() {
        self.topStackView.favCatsButton.shake()
    }
    
    
    func openFiltersScreen() {
        let vc =  FilterViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func openFavoritesListScreen() {
        let profileVC = LikedCatsViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func openProfileScreen() {
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func showCard(for cat: Cat) {
        let cardView = CardView()
        cardView.backgroundColor = .red
        cardView.delegate = self
        cardView.cardViewModel = cat.convertToCardVM()
        deckView.addSubview(cardView)
        deckView.sendSubviewToBack(cardView)
        cardView.pin4Sides()
    }
    
    func showEmptyMessage() {
        emptyLabel.isHidden = false
    }
    
    
    func removeAllCards() {
        self.deckView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func disableBottomButtons() {
        buttonStackView.buttons.forEach { $0.isEnabled = false }
    }
    
    func enableBottomButtons() {
        buttonStackView.buttons.forEach { $0.isEnabled = true }
    }

    func openDetailedScreen(for cat: Cat) {
        let vc = InfoViewController()
        self.present(vc, animated: true) {
            vc.viewModel = CatViewModel(cat)
        }
    }
    
    func removeTopCard() {
        deckView.subviews.last?.removeFromSuperview()
    }
    
    func disableLikeButton() {
        buttonStackView.likeButton.isEnabled = false
    }
    
    func enableLikeButton() {
        buttonStackView.likeButton.isEnabled = true
    }
    
    func disableDislikeButton() {
        buttonStackView.dislikeButton.isEnabled = false
    }
    
    func enableDislikeButton() {
        buttonStackView.dislikeButton.isEnabled = true
    }
    
    func disableFiltersButton() {
        buttonStackView.filtersButton.isEnabled = false
    }
    
    func enableFiltersButton() {
        buttonStackView.filtersButton.isEnabled = true
    }
    
    func disableRefreshButton() {
        buttonStackView.reloadButton.isEnabled = false
    }
    
    func enableRefreshButton() {
        buttonStackView.reloadButton.isEnabled = true
    }
}


extension HomeViewController: CardDelegate {
    func cardViewDidRemoved(_ cardView: CardView) {
        self.presenter.cardRemoved(cardView.cardViewModel)
    }
    
    func cardView(_ cardView: CardView, infoTappedOn: CardViewModel) {
        self.presenter.tapOnInfoButton(on: infoTappedOn)
    }
    
    func cardView(_ cardView: CardView, like: CardViewModel) {
        self.presenter.swipeOnLike(for: like.cat)
    }
    
    func cardView(_ cardView: CardView, dislike: CardViewModel) {
        self.presenter.swipeOnDislike(for: dislike.cat)
    }
    
    
}

extension HomeViewController: FilterViewControllerDelegate {
    func filterViewControllerDismiss(_ filterViewController: FilterViewControllerProtocol) {
        self.presenter.filterViewControllerDismissed()
    }
}
