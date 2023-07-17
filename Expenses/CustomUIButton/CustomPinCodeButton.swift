//
//  CustomPinCodeButton.swift
//  Expenses
//
//  Created by Andrii Malyk on 10.07.2023.
//

import Foundation
import UIKit

@IBDesignable
class CustomPinCodeButton: UIButton {

    @IBInspectable var isConfiguration: Bool = false {
        didSet {
            guard isConfiguration else { return }
            
            var configuration = UIButton.Configuration.plain()
            configuration.cornerStyle = .capsule
            self.configuration = configuration
            
            self.configurationUpdateHandler = { button in
                button.configuration?.background.backgroundColor = button.isHighlighted ? #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1) : #colorLiteral(red: 0.9176470588, green: 0.6431372549, blue: 0.9411764706, alpha: 1)
            }
        }
    }
}
