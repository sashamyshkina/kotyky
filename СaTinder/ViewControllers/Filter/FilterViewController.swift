//
//  FilterViewController.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 17.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit



class FilterViewController: UIViewController {
    
    var presenter: FilterPresenterProtocol!
    var delegate: FilterViewControllerDelegate?
    
    lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: TagFlowLayout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.allowsMultipleSelection = true
        v.backgroundColor = .systemBackground
        view.addSubview(v)
        v.pin(top: descrLabel.bottomAnchor, leading: self.view.leadingAnchor, bottom: applyButton.topAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 20, left: 15, bottom: 0, right: 15))
        v.register(TagCell.self, forCellWithReuseIdentifier: Const.tagCellid)
        return v
    }()
    
    lazy var mainLabel: UILabel = {
        let l = UILabel()
        l.text = NSLocalizedString(Const.clarify, comment: "")
        l.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        l.textColor = .systemPink
        l.numberOfLines = 0
        l.textAlignment = .left
        view.addSubview(l)
        l.pin(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 40, left: 20, bottom: 0, right: 0))
        return l
    }()
    
    lazy var descrLabel: UILabel = {
        let l = UILabel()
        l.text = NSLocalizedString(Const.chooseTags, comment: "")
        l.font = UIFont.systemFont(ofSize: 20, weight: .light)
        l.textColor = UIColor(named: "text_color")
        l.numberOfLines = 0
        l.textAlignment = .left
        view.addSubview(l)

        l.pin(top: self.mainLabel.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        return l
    }()
    
    lazy var applyButton: GradientButton = {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString(Const.apply, comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(applyButtonPressed), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return button
    }()

    
    @objc private func applyButtonPressed() {
        presenter.tapOnApplyButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FilterPresenter(vc: self)
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCellsForSelectionState()
    }
    
    private func configureCellsForSelectionState() {
        for i in 0..<presenter.countOfFilters {
            let filter = presenter.getFilter(by: i)
            if presenter.isSelected(filter) {
                collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: false, scrollPosition: .right)
            }
        }
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.countOfFilters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.tagCellid, for: indexPath) as! TagCell
        let filter = presenter.getFilter(by: indexPath.item)
        configureCell(cell: cell, with: filter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.tapOn(filter: presenter.getFilter(by: indexPath.item))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = self.presenter.getFilter(by: indexPath.item)
        let sizingCell = TagCell()
        configureCell(cell: sizingCell, with: filter)
        return sizingCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    private func configureCell(cell: TagCell, with filter: Filter) {
        cell.label.text = filter.name
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        presenter.tapOn(filter: presenter.getFilter(by: indexPath.item))
    }
}

protocol FilterViewControllerProtocol: UIViewController {
    var delegate: FilterViewControllerDelegate? { get }
}
extension FilterViewController: FilterViewControllerProtocol {}

protocol FilterViewControllerDelegate {
    func filterViewControllerDismiss(_ filterViewController: FilterViewControllerProtocol)
}
