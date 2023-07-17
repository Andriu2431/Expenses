//
//  ListTableViewCellViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import Foundation

protocol ListTableViewCellViewModelProtocol: AnyObject {
    var sumTransactionText: String {get}
    var operation: Int {get}
    var dateTransaction: String {get}
    var description: String {get}
    var operationType: String {get}
}
