//
//  FirestoreServise.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import Firebase
import FirebaseFirestore

class FirestoreServise {
    static let shared = FirestoreServise()
    
    var db = Firestore.firestore()
    
    private var walletRef: CollectionReference {
        return db.collection("wallet")
    }
    
    func saveTransactionWith(name: String, cost: String, operation: String, date: String, total: String, completion: @escaping (Result<ExpensesItem, Error>) -> Void) {
        
        let item = ExpensesItem(name: name, cost: cost, operation: operation, date: date, total: total)
        self.walletRef.document(UUID().uuidString).setData(item.representation) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(item))
            }
        }
    }
}

