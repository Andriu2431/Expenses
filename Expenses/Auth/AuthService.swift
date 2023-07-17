//
//  FirebaseLoginService.swift
//  Expenses
//
//  Created by Andrii Malyk on 07.07.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    
    func googleLogin(vc: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(error!))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    
    func googleSignOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
          try Auth.auth().signOut()
            completion(.success(Void()))
        } catch let signOutError {
            completion(.failure(signOutError))
        }
    }
}
