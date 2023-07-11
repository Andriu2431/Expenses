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

    @IBOutlet weak var currentPinCode: UILabel!
    
    private let keychain = KeychainSwift()
    private var passwordEntered = "" {
        didSet {
            currentPinCode.text = passwordEntered
        }
    }
    private var myPassword: String? {
        keychain.get("password")
    }
    
    private var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [ #colorLiteral(red: 0.9170659184, green: 0.644534111, blue: 0.9398914576, alpha: 1).cgColor, #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1).cgColor]
            gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                         height: self.view.bounds.height)
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer = CAGradientLayer()
        keychain.synchronizable = true
        biometricLogin()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if myPassword == nil {
            createNewPasswordAlert()
        }
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
//                    self?.presentAlert(title: "Помилка!", massage: error.localizedDescription)
                    print(error.localizedDescription)
                } else {
                    self?.presentVC(.navigationVC)
                }
            }
        }
    }
    
    private func createNewPasswordAlert() {
        let alert = UIAlertController(title: "Впишіть пароль!", message: "Повинен складатись з 4 цифер!", preferredStyle: .alert)
        alert.createCustomTextField(placeholder: "Наприклад: 1234")
        
        let action = UIAlertAction(title: "Зберегти", style: .default) { [weak self] action in
            guard let pinCode = alert.textFields?.first?.text, pinCode.count == 4 else {
                self?.presentAlert(title: "Помилка!", massage: "Некоректний пароль!", completion: {
                    self?.createNewPasswordAlert()
                })
                return
            }
            
            self?.keychain.set("\(pinCode)", forKey: "password")
            self?.presentAlert(title: "Успіх!", massage: "Новий пароль створено!")
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func changePasswordAlert() {
        let alert = UIAlertController(title: "Впишіть старий пароль для заміни, та придумйте новий!", message: "Повинен складатись з 4 цифер!", preferredStyle: .alert)
        alert.createCustomTextField(placeholder: "Старий пароль")
        alert.createCustomTextField(placeholder: "Новий пароль")
        
        let cancel = UIAlertAction(title: "Відмінити", style: .cancel)
        let accept = UIAlertAction(title: "Зберегти", style: .destructive) { [weak self] action in
            guard let oldPinCode = alert.textFields?.first?.text, oldPinCode == self?.myPassword else {
                self?.presentAlert(title: "Помилка!", massage: "Страий ПІН-код не вірний!")
                return
            }
            
            if let newPinCode = alert.textFields?.last?.text, newPinCode.count == 4 {
                self?.keychain.set("\(newPinCode)", forKey: "password")
                self?.presentAlert(title: "Успіх!", massage: "Новий пароль змінено!")
            } else {
                self?.presentAlert(title: "Помилка!", massage: "Новий ПІН-код некоректний!")
            }
        }
        
        alert.addAction(accept)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @IBAction func useFaceIdTapped() {
        biometricLogin()
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        changePasswordAlert()
    }
    
    @IBAction func signOutGoogleTapped(_ sender: Any) {
        AuthService.shared.googleSignOut { [weak self] result in
            switch result {
            case .success():
                self?.dismiss(animated: true) {
                    self?.presentVC(.authVC)
                }
            case .failure(let failure):
                self?.presentAlert(title: "Помилка!", massage: failure.localizedDescription)
            }
        }
    }
    
    @IBAction func pinCodeButtonTapped(_ sender: UIButton) {
        passwordEntered += "\(sender.tag)"
        
        if passwordEntered.count == 4 {
            if passwordEntered == myPassword {
                self.presentVC(.navigationVC)
            } else {
                passwordEntered = ""
            }
        } else if passwordEntered.count > 4 {
            passwordEntered = ""
        }
    }
    
    @IBAction func deletePasswordEntered(_ sender: UIButton) {
        if !passwordEntered.isEmpty {
            passwordEntered.removeLast()
            currentPinCode.text = passwordEntered
        }
    }
}
