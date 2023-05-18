//
//  AddOrEditViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class EditTransactionViewModel: DetailViewModelProtocol {
    
    private var item: ExpensesItem
    var selectedOperationType: Operation
    
    init(item: ExpensesItem) {
        self.item = item
        self.selectedOperationType = Operation(rawValue: item.operationType) ?? .product
    }
    
    var title: String {
        "Редагування"
    }
    
    var sumTransactionText: String {
        String(item.sumTransaction)
    }
    
    var dateTransaction: Date {
        item.dateTransaction
    }
    
    var description: String {
        item.description
    }
    
    var operationType: String {
        item.operationType
    }
    
    var operation: Int {
        item.operation
    }
    
    var isSave: Bool {
        true
    }
    
    func saveTransaction(description: String, sum: Int, operation: Int, date: Date) {
        fatalError()
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date) {
        FirestoreServise.shared.updateTransaction(description: description,
                                                  sum: sum,
                                                  operation: operation,
                                                  type: selectedOperationType.rawValue,
                                                  date: date,
                                                  id: item.id)
    }
}
