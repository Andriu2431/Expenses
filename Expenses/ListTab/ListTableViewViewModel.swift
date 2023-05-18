//
//  ListTableViewViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 04.05.2023.
//

import Foundation

enum Operation: String, CaseIterable {
    case product = "Продукти"
    case fun = "Розваги"
    case studying = "Навчання"
    case trips = "Поїздки"
    case other = "Інше"
    case investments = "Інвестиції"
    case salary = "Зарплата"
}

class ListTableViewViewModel: ListTableViewViewModelProtocol {
    
    private var items = [ExpensesItem]()
    private var operationTypeItems = [OperationTypeExpensesItem]()
    
    func setup(items: [ExpensesItem]) {
        self.items = items
        self.operationTypeItems = getOperationTypeItems()
    }
    
    // MARK: List View Controller Methods
    
    func tableViewCellNumberOfRows() -> Int {
        items.count
    }
    
    func getAllItemsForListener() -> [ExpensesItem] {
        items
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
    
    func createEditTransactionViewModel(indexPath: IndexPath) -> DetailViewModelProtocol {
        return EditTransactionViewModel(item: items[indexPath.row])
    }
    
    func createAddTransactionViewModel() -> DetailViewModelProtocol {
        return AddTrnsactionViewModel()
    }
    
    func tableViewCellViewModel(indexPath: IndexPath) -> ListTableViewCellViewModelProtocol? {
        return ListTableViewCellViewModel(item: items[indexPath.row])
    }
    
    // MARK: Collection View Methods
    
    func collectionViewCellNumberOfRows() -> Int {
        operationTypeItems.count
    }
    
    func collectioViewCellViewModel(indexPath: IndexPath) -> ListCollectionViewCellViewModelProtocol? {
        return ListCollectionViewCellViewModel(item: operationTypeItems[indexPath.row])
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
        let countOperationType = collectionViewCellNumberOfRows()
        return countOperationType > 3 ? 180 : 90
    }
    
    // MARK: Private Methods
    
    private func getOperationTypeItems() -> [OperationTypeExpensesItem] {
        var operationTypeItems = [OperationTypeExpensesItem]()
        
        Operation.allCases.forEach { operation in
            let expenses = calculateFor(operation: operation)
            if expenses != 0 {
                operationTypeItems.append(OperationTypeExpensesItem(iconName: operation.rawValue, expenses: expenses))
            }
        }
        return operationTypeItems
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
