//
//  FilterPresenter.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 23.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import Foundation

protocol FilterPresenterProtocol {
    
    var countOfFilters: Int { get }
    
    init(vc: FilterViewControllerProtocol, filterManager: FilterManagerProtocol)
    
    func prepareUI()
    func tapOn(filter: Filter)
    func tapOnApplyButton()
    func getFilter(by: Int) -> Filter
    func isSelected(_ filter: Filter) -> Bool
    
}


class FilterPresenter: FilterPresenterProtocol {
    
    var vc: FilterViewControllerProtocol
    var filterManager: FilterManagerProtocol
    
    required init(vc: FilterViewControllerProtocol, filterManager: FilterManagerProtocol = FilterManager.shared) {
        self.vc = vc
        self.filterManager = filterManager
    }
    
    func prepareUI() {
        
    }
    
    func tapOn(filter: Filter) {
        if filterManager.isSelected(filter) {
            filterManager.setDeselected(filter)
        } else {
            filterManager.setSelected(filter)
        }
    }

    func tapOnApplyButton() {
        vc.dismiss(animated: true) {
            self.vc.delegate?.filterViewControllerDismiss(self.vc)
        }
    }
    
    var countOfFilters: Int {
        return filterManager.filters.count
    }
    
    func getFilter(by index: Int) -> Filter {
        return filterManager.filters[index]
    }
    
    func isSelected(_ filter: Filter) -> Bool {
        return filterManager.isSelected(filter)
    }
}
