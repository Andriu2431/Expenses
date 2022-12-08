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
    @IBOutlet weak var nextScreen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        biometricLogin()
        nextScreen.isEnabled = false
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
                    self.nextScreen.isEnabled = true
                    self.touchOrFaceID.isEnabled = false
                }
            }
        }
    }
    
}
