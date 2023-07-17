//
//  ListTableViewCellViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class ListTableViewCellViewModel: ListTableViewCellViewModelProtocol {
    
    private var item: ExpensesItem
    
    init(item: ExpensesItem) {
        self.item = item
    }
    
    var sumTransactionText: String {
        switch item.operation {
        case 0:
            return "+\(item.sumTransaction) грн"
        default:
            return "-\(item.sumTransaction) грн"
        }
    }
    
    var operation: Int {
        item.operation
    }
    
    var dateTransaction: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        return dateFormater.string(from: item.dateTransaction)
    }
    
    var description: String {
        item.description
    }
    
    var operationType: String {
        item.operationType
    }
}
