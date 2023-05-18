//
//  DetailViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import Foundation

protocol DetailViewModelProtocol {
    var sumTransactionText: String {get}
    var dateTransaction: Date {get}
    var description: String {get}
    var operation: Int {get}
    var selectedOperationType: Operation {get set}
    var title: String {get}
    var isSave: Bool {get}
    func saveTransaction(description: String, sum: Int, operation: Int, date: Date)
    func updateTransaction(description: String, sum: Int, operation: Int, date: Date)
}
