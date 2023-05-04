//
//  ListViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 04.05.2023.
//

import UIKit

protocol ListViewModelProtocol {
    var items: [ExpensesItem] {get}
    func setup(items: [ExpensesItem])
    func currentBalanceCalculation() -> String
    func createEditViewController(indexPath: IndexPath) -> AddTransactionVC
    func deleteTransaction(indexPath: IndexPath) 
}


class ListViewModel: ListViewModelProtocol {
    
    var items = [ExpensesItem]()
    
    func setup(items: [ExpensesItem]) {
        self.items = items
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
}
