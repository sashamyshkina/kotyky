//
//  WithShowError.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 23.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

protocol WithShowError: UIViewController {
    func showError(_ error: Error)
}

extension WithShowError {
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
