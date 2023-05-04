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
    
    func saveTransactionWith(description: String, sum: Int, operation: Int, date: Date) {
        let item = ExpensesItem(description: description, sumTransaction: sum, operation: operation, dateTransaction: date, id: UUID().uuidString)
        self.walletRef.document(item.id).setData(item.representation) { error in
            if let error {
                print(error.localizedDescription)
            } 
        }
    }
    
    func deleteTransaction(itemId: String) {
        walletRef.document(itemId).delete { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date, id: String) {
        let dictionry: [String: Any] = ["description": description,
                                        "sumTransaction": sum,
                                        "operation": operation,
                                        "dateTransaction": date,
                                        "uid": id]
        walletRef.document(id).updateData(dictionry) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}

