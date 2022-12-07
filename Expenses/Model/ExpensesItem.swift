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
    var id: String
    
    init(name: String, cost: String, operation: String, date: String, total: String, id: String) {
        self.name = name
        self.cost = cost
        self.operation = operation
        self.date = date
        self.total = total
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
        
        self.name = name
        self.cost = cost
        self.operation = operation
        self.date = date
        self.total = total
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep = ["name": name]
        rep["cost"] = cost
        rep["operation"] = operation
        rep["date"] = date
        rep["total"] = total
        rep["id"] = id
        return rep
    }
    
    static func == (lhs: ExpensesItem, rhs: ExpensesItem) -> Bool {
        return lhs.id == rhs.id
    }
}
