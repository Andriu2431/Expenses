//
//  ListTableViewViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 04.05.2023.
//

import UIKit

enum Operation: String, CaseIterable {
    case product = "Продукти"
    case fun = "Розваги"
    case studying = "Навчання"
    case trips = "Поїздки"
    case other = "Інше"
    case investments = "Інвестиції"
    case salary = "Зарплата"
}

class ListTableViewViewModel: TableViewViewModelProtocol {
    
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
    
    func createEditViewController(indexPath: IndexPath, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "DetailTransactionVc") as! DetailTrasactionVC
        let editViewModel = EditTransactionViewModel(item: items[indexPath.row])
        editVC.viewModel = editViewModel
        viewController.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func createAddViewController(viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "DetailTransactionVc") as! DetailTrasactionVC
        let addViewModel = AddTrnsactionViewModel()
        addVC.viewModel = addViewModel
        viewController.navigationController?.pushViewController(addVC, animated: true)
    }
    
    func createSwipeActions(indexPath: IndexPath, viewController: UIViewController) -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .normal, title: "Видалити") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.deleteAllertController(indexPath: indexPath, viewController: viewController)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Редагувати") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.createEditViewController(indexPath: indexPath, viewController: viewController)
        }
        editAction.backgroundColor = .gray
        
        return [deleteAction, editAction]
    }
    
    func tableViewCellViewModel(indexPath: IndexPath) -> TableViewCellViewModelProtocol? {
        let item = items[indexPath.row]
        return ListTableViewCellViewModel(item: item)
    }
    
    // MARK: Collection View Methods
    
    func collectionViewCellNumberOfRows() -> Int {
        operationTypeItems.count
    }
    
    func collectioViewCellViewModel(indexPath: IndexPath) -> CollectionViewCellViewModelProtocol? {
        let item = operationTypeItems[indexPath.row]
        return CollectionViewCellViewModel(item: item)
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
    
    private func deleteAllertController(indexPath: IndexPath, viewController: UIViewController) {
        let alert = UIAlertController(title: "Підтвердіть!", message: "Ви дійсно хочете видалити цей елемент?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Так", style: .default) { [unowned self] action in
            deleteTransaction(indexPath: indexPath)
        }
        let no = UIAlertAction(title: "Ні", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        viewController.present(alert, animated: true)
    }
}
