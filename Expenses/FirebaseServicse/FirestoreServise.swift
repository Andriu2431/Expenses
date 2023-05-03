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
    
    func saveTransactionWith(name: String, cost: String, operation: String, date: String, total: String) {
        let item = ExpensesItem(description: name, sumTransaction: cost, operation: operation, dateTransaction: date, balance: total, id: UUID().uuidString)
        self.walletRef.document(item.id).setData(item.representation) { error in
            if let error {
                print(error.localizedDescription)
            } 
        }
    }
    
    func deleteTransaction(item: ExpensesItem) {
        walletRef.document(item.id).delete { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTransaction(item: ExpensesItem) {
        walletRef.document(item.id).updateData(["total": item.balance]) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}

