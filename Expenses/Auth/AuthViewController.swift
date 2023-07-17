//
//  AuthViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 07.07.2023.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.insertSublayer(createGradientLayer(), at: 0)
    }
    
    @IBAction func googleSignInButton() {
        AuthService.shared.googleLogin(vc: self) { [weak self] result in
            switch result {
            case .success():
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.presentVC(.pinCodeVC)
                }
            case .failure(let failure):
                self?.presentAlert(title: "Помилка!", massage: failure.localizedDescription)
            }
        }
    }
}
