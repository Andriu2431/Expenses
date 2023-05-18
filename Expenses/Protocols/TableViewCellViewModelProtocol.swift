//
//  TableViewCellViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import UIKit

protocol TableViewCellViewModelProtocol: AnyObject {
    var sumTransactionText: String {get}
    var sumTransactionTextColor: UIColor {get}
    var dateTransaction: String {get}
    var description: String {get}
    var operationType: String {get}
}
