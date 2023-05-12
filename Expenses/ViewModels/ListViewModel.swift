//
//  ListViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 04.05.2023.
//

import UIKit

protocol ListViewModelProtocol {
    var items: [ExpensesItem] {get}
    var operationTypeItems: [OperationTypeExpensesItem] {get}
    func setup(items: [ExpensesItem])
    func currentBalanceCalculation() -> String
    func createEditViewController(indexPath: IndexPath) -> AddTransactionVC
    func deleteTransaction(indexPath: IndexPath) 
}

enum Operation: String, CaseIterable {
    case product = "Продукти"
    case fun = "Розваги"
    case studying = "Навчання"
    case trips = "Поїздки"
    case other = "Інше"
    case investments = "Інвестиції"
    case salary = "Зарплата"
}

class ListViewModel: ListViewModelProtocol {
    
    var items = [ExpensesItem]()
    var operationTypeItems = [OperationTypeExpensesItem]()
    
    func setup(items: [ExpensesItem]) {
        self.items = items
        self.operationTypeItems = getOperationTypeItems()
    }
    
    func currentBalanceCalculation() -> String {
        var profit: [Int] = []
        var costs: [Int] = []
        
        items.forEach { item in
            item.operation == 0 ? profit.append(item.sumTransaction) : costs.append(item.sumTransaction)
        }
        
        return String(profit.reduce(0, +) - costs.reduce(0, +))
    }
    
    func deleteTransaction(indexPath: IndexPath) {
        FirestoreServise.shared.deleteTransaction(itemId: items[indexPath.row].id)
    }
    
    func createEditViewController(indexPath: IndexPath) -> AddTransactionVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "detailVC") as! AddTransactionVC
        editVC.configure(item: items[indexPath.row])
        return editVC
    }
    
    private func getOperationTypeItems() -> [OperationTypeExpensesItem] {
        var collectionItemModel = [OperationTypeExpensesItem]()
        
        Operation.allCases.forEach { operation in
            let expenses = calculateFor(operation: operation)
            if expenses != 0 {
                collectionItemModel.append(OperationTypeExpensesItem(iconName: operation.rawValue, expenses: expenses))
            }
        }
        return collectionItemModel
    }
    
    private func calculateFor(operation: Operation) -> Int {
        var cost = 0
        
        let filterItesm = items.filter {$0.operationType == operation.rawValue}
        filterItesm.forEach { item in
            if item.operation == 0 {
                cost += item.sumTransaction
            } else {
                cost -= item.sumTransaction
            }
        }
        
        return cost
    }
}
