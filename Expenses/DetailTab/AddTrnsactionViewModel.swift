//
//  AddTrnsactionViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class AddTrnsactionViewModel: DetailViewModelProtocol {

    var selectedOperationType: Operation = .product
    var title = "Нова транзакція"
    var sumTransactionText = ""
    var dateTransaction = Date()
    var description = ""
    var operation = 1
    var isSave = false
    
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
