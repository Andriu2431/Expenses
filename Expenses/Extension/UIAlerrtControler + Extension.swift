//
//  UIAlerrtControler + Extension.swift
//  Expenses
//
//  Created by Andrii Malyk on 11.07.2023.
//

import UIKit

extension UIAlertController {
    
    func createCustomTextField(placeholder: String) {
        self.addTextField { textField in
            textField.placeholder = placeholder
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }
    }
}
