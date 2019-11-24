//
//  UIViewController+Alert.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/4/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String,
                   message: String,
                   okBlock: (() -> ())? = .none) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо",
                                      style: .default,
                                      handler: {_ in okBlock?()}))
        present(alert, animated: true)
    }
    
}
