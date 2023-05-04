//
//  ExpensesItem.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import FirebaseFirestore

struct ExpensesItem: Hashable {
    var description: String
    var sumTransaction: Int
    var operation: Int
    var operationType: String
    var dateTransaction: Date
    var id: String
    
    init(description: String, sumTransaction: Int, operation: Int, operationType: String, dateTransaction: Date, id: String) {
        self.description = description
        self.sumTransaction = sumTransaction
        self.operation = operation
        self.operationType = operationType
        self.dateTransaction = dateTransaction
        self.id = id
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let description = data["description"] as? String,
              let sumTransaction = data["sumTransaction"] as? Int,
              let operation = data["operation"] as? Int,
              let operationType = data["operationType"] as? String,
              let dateTransaction = data["dateTransaction"] as? Timestamp,
              let id = data["uid"] as? String
        else { return nil }
        
        self.description = description
        self.sumTransaction = sumTransaction
        self.operation = operation
        self.operationType = operationType
        self.dateTransaction = dateTransaction.dateValue()
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep = [String: Any]()
        rep["description"] = description
        rep["sumTransaction"] = sumTransaction
        rep["operation"] = operation
        rep["operationType"] = operationType
        rep["dateTransaction"] = dateTransaction
        rep["uid"] = id
        return rep
    }
    
    static func == (lhs: ExpensesItem, rhs: ExpensesItem) -> Bool {
        return lhs.id == rhs.id
    }
}
