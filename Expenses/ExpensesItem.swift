//
//  ExpensesItem.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import FirebaseFirestore

struct ExpensesItem: Hashable {
    var name: String
    var cost: String
    var operation: String
    var date: String
    var total: String
    
    init(name: String, cost: String, operation: String, date: String, total: String) {
        self.name = name
        self.cost = cost
        self.operation = operation
        self.date = date
        self.total = total
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String,
              let cost = data["cost"] as? String,
              let operation = data["operation"] as? String,
              let date = data["date"] as? String,
              let total = data["total"] as? String else { return nil }
        
        self.name = name
        self.cost = cost
        self.operation = operation
        self.date = date
        self.total = total
    }
    
    var representation: [String: Any] {
        var rep = ["name": name]
        rep["cost"] = cost
        rep["operation"] = operation
        rep["date"] = date
        rep["total"] = total
        return rep
    }
    
    static func == (lhs: ExpensesItem, rhs: ExpensesItem) -> Bool {
        if lhs.name == rhs.name, lhs.cost == rhs.cost, lhs.total == rhs.total, lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
}
