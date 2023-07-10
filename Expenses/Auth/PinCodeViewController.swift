//
//  PinCodeViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 08.12.2022.
//

import UIKit
import LocalAuthentication
import KeychainSwift
import FirebaseAuth

class PinCodeViewController: UIViewController {

    @IBOutlet weak var touchOrFaceID: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let keychain = KeychainSwift()
    
    private var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [ #colorLiteral(red: 0.9170659184, green: 0.644534111, blue: 0.9398914576, alpha: 1).cgColor, #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1).cgColor]
            gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                         height: self.view.bounds.height)
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        passwordTextField.keyboardType = .numberPad
        passwordTextField.backgroundColor = .clear
        gradientLayer = CAGradientLayer()
        keychain.synchronizable = true
        biometricLogin()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func biometricLogin() {
        let context = LAContext()
        let reason = "Please authorize with Face ID or Touch ID"
        var error: NSError?
        
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                if let error {
                    self?.presentAlert(title: "Помилка!", massage: error.localizedDescription)
                } else {
                    self?.presentVC(.navigationVC)
                }
            }
        }
    }
    
    private func createNewPasswordAlert() {
        let alert = UIAlertController(title: "Впишіть новий пароль!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Зберегти", style: .default) { [weak self] action in
            guard let text = alert.textFields?.first?.text else { return }
            self?.keychain.set("\(text)", forKey: "password")
        }
        alert.addTextField()
        alert.textFields?.first?.placeholder = "Наприклад: 1234"
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @IBAction func useFaceIdTapped() {
        biometricLogin()
    }
    
    @IBAction func newPasswordButton(_ sender: Any) {
        createNewPasswordAlert()
    }
    
    @IBAction func signOutGoogleTapped(_ sender: Any) {
        AuthService.shared.googleSignOut { [weak self] result in
            switch result {
            case .success():
                self?.dismiss(animated: true) {
                    self?.presentVC(.authVC, isAnimated: false)
                }
            case .failure(let failure):
                self?.presentAlert(title: "Помилка!", massage: failure.localizedDescription)
            }
        }
    }
}

extension PinCodeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.text == keychain.get("password") else { return }
        self.presentVC(.navigationVC)
    }
}
