//
//  ListTableViewViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import UIKit

protocol ListTableViewViewModelProtocol {
    func tableViewCellNumberOfRows() -> Int
    func collectionViewCellNumberOfRows() -> Int
    func setup(items: [ExpensesItem])
    func getAllItemsForListener() -> [ExpensesItem]
    func currentBalanceCalculation() -> String
    func calculateCollectionViewHeight() -> CGFloat
    func createEditTransactionViewModel(indexPath: IndexPath) -> DetailViewModelProtocol
    func createAddTransactionViewModel() -> DetailViewModelProtocol
    func deleteTransaction(indexPath: IndexPath)
    func tableViewCellViewModel(indexPath: IndexPath) -> ListTableViewCellViewModelProtocol?
    func collectioViewCellViewModel(indexPath: IndexPath) -> ListCollectionViewCellViewModelProtocol?
}
