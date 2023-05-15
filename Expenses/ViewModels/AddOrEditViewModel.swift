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
    func isItem() -> Bool
    func saveTransaction(description: String, sum: Int, operation: Int, type: String, date: Date)
    func updateTransaction(description: String, sum: Int, operation: Int, type: String, date: Date)
}

class AddOrEditViewModel: AddOrEditViewModelProtocol {
    
    var item: ExpensesItem?
    
    init(item: ExpensesItem) {
        self.item = item
    }
    
    init() {
        self.item = nil
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
    
    func saveTransaction(description: String, sum: Int, operation: Int, type: String, date: Date) {
        FirestoreServise.shared.saveTransactionWith(description: description,
                                                    sum: sum,
                                                    operation: operation,
                                                    type: type,
                                                    date: date)
    }
    
    func updateTransaction(description: String, sum: Int, operation: Int, type: String, date: Date) {
        FirestoreServise.shared.updateTransaction(description: description,
                                                  sum: sum,
                                                  operation: operation,
                                                  type: type,
                                                  date: date,
                                                  id: item?.id ?? "")
    }
}
