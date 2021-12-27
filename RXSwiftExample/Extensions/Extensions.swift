//
//  Extensions.swift
//  Cathay
//
//  Created by Steve on 11/12/19.
//  Copyright © 2019 Steve. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
