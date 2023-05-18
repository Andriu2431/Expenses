//
//  AddTrnsactionViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class AddTrnsactionViewModel: AddOrEditViewModelProtocol {

    var selectedOperationType: Operation = .product
    
    var title: String {
        "Нова транзакція"
    }
    
    var sumTransactionText: String {
        ""
    }
    
    var dateTransaction: Date {
        Date()
    }
    
    var description: String {
        ""
    }
    
    var operationType: String {
        Operation.product.rawValue
    }
    
    var operation: Int {
        1
    }
    
    var isSave: Bool {
        false
    }
    
    func saveTransaction(description: String, sum: Int, operation: Int, date: Date) {
        FirestoreServise.shared.saveTransactionWith(description: description,
                                                    sum: sum,
                                                    operation: operation,
                                                    type: selectedOperationType.rawValue,
                                                    date: date)
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date) {
        fatalError()
    }
    

}
