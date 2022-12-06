//
//  ListenerServise.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import FirebaseFirestore

class ListenerServise {
    static let shared = ListenerServise()
    
    private let db = Firestore.firestore()
    private var wallerRef: CollectionReference {
        return db.collection("wallet")
    }
    
    func walletObserve(items: [ExpensesItem], completion: @escaping (Result<[ExpensesItem], Error>) -> Void) -> ListenerRegistration? {
        var items = items
        let wallerListener = wallerRef.addSnapshotListener { querySnapshot, error in
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
                    return
                case .removed:
                    return
                }
            }
            completion(.success(items))
        }
        return wallerListener
    }
}
