//
//  ListAllOperationViewModel.swift
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
    case car = "Авто"
    case gifts = "Подарунки"
    case clothes = "Одяг"
    case other = "Інше"
    case investments = "Інвестиції"
    case salary = "Зарплата"
}

class ListAllOperationViewModel: ListTableViewViewModelProtocol {
    
    private var items = [ExpensesItem]()
    private var coppyItems = [ExpensesItem]()
    private var collectionViewCells = [CollectionViewCellModel]()
    
    func setup(items: [ExpensesItem]) {
        self.items = items
        self.coppyItems = items
        self.collectionViewCells = getCollectionViewCells()
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
        collectionViewCells.count
    }
    
    func collectioViewCellViewModel(indexPath: IndexPath) -> ListCollectionViewCellViewModelProtocol? {
        return ListCollectionViewCellViewModel(item: collectionViewCells[indexPath.row])
    }
    
    func sortedBy(indexPath: IndexPath, selected: Bool) {
        if selected {
            let selectedCollectionCell = collectionViewCells[indexPath.row]
            let sortedItems = items.filter { $0.operationType == selectedCollectionCell.operation }
            self.items = sortedItems
        } else {
            self.items = coppyItems
        }
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
        let countOperationType = collectionViewCellNumberOfRows()
        return countOperationType > 3 ? 180 : 90
    }
    
    // MARK: Private Methods
    
    private func getCollectionViewCells() -> [CollectionViewCellModel] {
        var operationTypeItems = [CollectionViewCellModel]()
        var totalExpenses = 0
        
        Operation.allCases.forEach { operation in
            let expenses = calculateFor(operation: operation)
            if expenses != 0 {
                operationTypeItems.append(CollectionViewCellModel(iconName: operation.rawValue, expenses: expenses, operation: operation.rawValue))
            }
            if expenses < 0 { totalExpenses += expenses }
        }
        
        operationTypeItems.append(CollectionViewCellModel(iconName: "Тотал витрат", expenses: totalExpenses, operation: "Тотал витрат"))
        return operationTypeItems
    }
    
    private func calculateFor(operation: Operation) -> Int {
        var cost = 0
        
        let filterItems = items.filter {$0.operationType == operation.rawValue}
        filterItems.forEach { item in
            if item.operation == 0 {
                cost += item.sumTransaction
            } else {
                cost -= item.sumTransaction
            }
        }
        
        return cost
    }
}
