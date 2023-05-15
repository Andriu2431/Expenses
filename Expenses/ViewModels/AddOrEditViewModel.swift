//
//  AddOrEditViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

protocol AddOrEditViewModelProtocol {
    var sumTransactionText: String {get}
    var dateTransaction: Date {get}
    var description: String {get}
    var operationType: String {get}
    var operation: Int {get}
    var selectedOperationType: Operation {get set}
    func isItem() -> Bool
    func saveTransaction(description: String, sum: Int, operation: Int, date: Date)
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date)
}

class AddOrEditViewModel: AddOrEditViewModelProtocol {
    
    var item: ExpensesItem?
    var selectedOperationType: Operation
    
    init(item: ExpensesItem) {
        self.item = item
        self.selectedOperationType = Operation(rawValue: item.operationType) ?? .product
    }
    
    init() {
        self.item = nil
        self.selectedOperationType = .product
    }
    
    var sumTransactionText: String {
        String(item?.sumTransaction ?? 0)
    }
    
    var dateTransaction: Date {
        item?.dateTransaction ?? Date()
    }
    
    var description: String {
        item?.description ?? ""
    }
    
    var operationType: String {
        item?.operationType ?? ""
    }
    
    var operation: Int {
        item?.operation ?? 0
    }
    
    func isItem() -> Bool {
        if item != nil {
            return true
        } else {
            return false
        }
    }
    
    func saveTransaction(description: String, sum: Int, operation: Int, date: Date) {
        FirestoreServise.shared.saveTransactionWith(description: description,
                                                    sum: sum,
                                                    operation: operation,
                                                    type: selectedOperationType.rawValue,
                                                    date: date)
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date) {
        FirestoreServise.shared.updateTransaction(description: description,
                                                  sum: sum,
                                                  operation: operation,
                                                  type: selectedOperationType.rawValue,
                                                  date: date,
                                                  id: item?.id ?? "")
    }
}
