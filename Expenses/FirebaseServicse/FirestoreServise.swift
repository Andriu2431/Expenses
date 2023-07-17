//
//  FirestoreServise.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirestoreServise {
    static let shared = FirestoreServise()
    
    private let db = Firestore.firestore()
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    private var transactionsRef: CollectionReference {
        return db.collection(["users", currentUserId, "transactions"].joined(separator: "/"))
    }
    
    func saveTransactionWith(description: String, sum: Int, operation: Int, type: String, date: Date) {
        let item = ExpensesItem(description: description, sumTransaction: sum, operation: operation, operationType: type, dateTransaction: date, id: UUID().uuidString)
        self.transactionsRef.document(item.id).setData(item.representation) { error in
            if let error {
                print(error.localizedDescription)
            } 
        }
    }
    
    func deleteTransaction(itemId: String) {
        transactionsRef.document(itemId).delete { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, type: String, date: Date, id: String) {
        let dictionry: [String: Any] = ["description": description,
                                        "sumTransaction": sum,
                                        "operation": operation,
                                        "operationType": type,
                                        "dateTransaction": date,
                                        "uid": id]
        transactionsRef.document(id).updateData(dictionry) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}

