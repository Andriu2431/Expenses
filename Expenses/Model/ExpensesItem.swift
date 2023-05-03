//
//  ExpensesItem.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import FirebaseFirestore

struct ExpensesItem: Hashable {
    var description: String
    var sumTransaction: String
    var operation: String
    var dateTransaction: String
    var balance: String
    var id: String
    
    init(description: String, sumTransaction: String, operation: String, dateTransaction: String, balance: String, id: String) {
        self.description = description
        self.sumTransaction = sumTransaction
        self.operation = operation
        self.dateTransaction = dateTransaction
        self.balance = balance
        self.id = id
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String,
              let cost = data["cost"] as? String,
              let operation = data["operation"] as? String,
              let date = data["date"] as? String,
              let total = data["total"] as? String,
              let id = data["id"] as? String
        else { return nil }
        
        self.description = name
        self.sumTransaction = cost
        self.operation = operation
        self.dateTransaction = date
        self.balance = total
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep = ["name": description]
        rep["cost"] = sumTransaction
        rep["operation"] = operation
        rep["date"] = dateTransaction
        rep["total"] = balance
        rep["id"] = id
        return rep
    }
    
    static func == (lhs: ExpensesItem, rhs: ExpensesItem) -> Bool {
        return lhs.id == rhs.id
    }
}
