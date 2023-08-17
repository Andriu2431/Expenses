//
//  ViewController + Extension.swift
//  Expenses
//
//  Created by Andrii Malyk on 07.07.2023.
//

import UIKit

extension UIViewController {
    
    enum StoryboardId: String {
        case authVC = "AuthVC"
        case pinCodeVC = "PinCodeViewController"
        case navigationVC = "NavigationListVC"
        case detailOrCreateItemVC = "DetailTransactionVc"
    }
    
    func presentVC(_ id: StoryboardId, isAnimated: Bool = true) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: id.rawValue) else { return }
        self.present(viewController, animated: isAnimated)
    }
    
    func presentAlert(title: String, massage: String? = nil, completion: (() -> Void)? = nil) {
        let allert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { alert in
            completion?()
        }
        
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func createGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [ #colorLiteral(red: 0.9170659184, green: 0.644534111, blue: 0.9398914576, alpha: 1).cgColor, #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1).cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        return gradientLayer
    }
}
