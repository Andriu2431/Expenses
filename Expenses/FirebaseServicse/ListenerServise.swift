//
//  ListenerServise.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import FirebaseFirestore
import FirebaseAuth

class ListenerServise {
    static let shared = ListenerServise()
    
    private let db = Firestore.firestore()
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    private var transactionsRef: CollectionReference {
        return db.collection(["users", currentUserId, "transactions"].joined(separator: "/"))
    }
    
    func transactionsObserve(items: [ExpensesItem], completion: @escaping (Result<[ExpensesItem], Error>) -> Void) -> ListenerRegistration? {
        var items = items
        let transactionsListener = transactionsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let item = ExpensesItem(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !items.contains(item) else { return }
                    items.append(item)
                case .modified:
                    guard let index = items.firstIndex(of: item) else { return }
                    items[index] = item
                case .removed:
                    guard let index = items.firstIndex(of: item) else { return }
                    items.remove(at: index)
                }
            }
            completion(.success(items))
        }
        return transactionsListener
    }
}
