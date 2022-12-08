//
//  ViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 08.12.2022.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {

    @IBOutlet weak var touchOrFaceID: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var navigationListVC: UIViewController!
    
    private var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            let startColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.3643370867, green: 0.5554206967, blue: 0.2973009944, alpha: 1).cgColor
            gradientLayer.colors = [startColor, endColor]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationListVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationListVC")
        
        passwordTextField.delegate = self
        passwordTextField.keyboardType = .numberPad
        passwordTextField.backgroundColor = .clear
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        biometricLogin()
    }
    
    @IBAction func useFaceIdTapped() {
        biometricLogin()
    }
    
    private func biometricLogin() {
        let context = LAContext()
        let reason = "Please authorize with Face ID or Touch ID"
        var error: NSError?
        
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            if let error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.present(self.navigationListVC, animated: true)
                }
            }
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.text == "2431" else { return }
        self.present(navigationListVC, animated: true)
    }
}
