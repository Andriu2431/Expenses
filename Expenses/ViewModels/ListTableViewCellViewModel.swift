//
//  ListTableViewCellViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import UIKit

protocol TableViewCellViewModelProtocol: AnyObject {
    var sumTransactionText: String {get}
    var sumTransactionTextColor: UIColor {get}
    var dateTransaction: String {get}
    var description: String {get}
    var operationType: String {get}
}

class ListTableViewCellViewModel: TableViewCellViewModelProtocol {
    
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
    
    var sumTransactionTextColor: UIColor {
        switch item.operation {
        case 0:
            return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        default:
            return .red
        }
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
