//
//  LikedCatsViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 07.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class LikedCatsViewController: UIViewController {
    
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

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.pin4Sides()
        tableView.separatorStyle = .none
        tableView.register(CatCell.self, forCellReuseIdentifier: Const.likedCatsCellid)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    var presenter: LikedCatsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        
        view.backgroundColor = .white
        
        self.presenter = LikedCatsPresenter(self)
        self.presenter.prepareUI()
    }
    
    
    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Const.back, comment: ""), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc fileprivate func backTapped() {
        dismiss(animated: true)
    }
}

extension LikedCatsViewController: LikedCatsViewControllerProtocol {
    
    func reload() {
        tableView.reloadData()
    }
    
    func showTable() {
        tableView.isHidden = false
    }
    
    func hideTable() {
        tableView.isHidden = true
    }
    
    func showEmptyLabel() {
        emptyLabel.isHidden = false
    }
    
    func hideEmptyLabel() {
        emptyLabel.isHidden = true
    }
    
    func presentAlertWithActions(for cat: Cat) {
        let alert = UIAlertController(title: cat.name, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Info", style: .default, handler: { [weak self] (action) in
            self?.presenter.tapOnInfo(cat)
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] (action) in
            self?.presenter.tapOnRemove(cat)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentInfoScreen(for cat: Cat) {
        let vc = InfoViewController()
        self.present(vc, animated: true) {
            vc.viewModel = CatViewModel(cat)
        }
    }
}

extension LikedCatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.catsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cat = presenter.catBy(index: indexPath.item)!
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.likedCatsCellid) as! CatCell
        cell.nameLabel.text = cat.name
        cell.catImage.maskCircle(anyImage: cat.mainImage!)
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = presenter.catBy(index: indexPath.item)!
        presenter.tapOn(cat)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
