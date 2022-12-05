//
//  ExpensesItem.swift
//  Expenses
//
//  Created by Andrii Malyk on 05.12.2022.
//

import Foundation

struct ExpensesItem {
    var name: String
    var cost: String
    var operation: String
    var date: String
    var total: String
    
    var representation: [String: Any] {
        var rep = ["name": name]
        rep["cost"] = cost
        rep["operation"] = operation
        rep["date"] = date
        rep["total"] = total
        return rep
    }
}
