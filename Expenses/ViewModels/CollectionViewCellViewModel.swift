//
//  CollectionViewCellViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import UIKit

protocol CollectionViewCellViewModelProtocol: AnyObject {
    var image: UIImage {get}
    var sumTransactionText: String {get}
    var sumTransactionTextColor: UIColor {get}
}

class CollectionViewCellViewModel: CollectionViewCellViewModelProtocol {
    
    private var item: OperationTypeExpensesItem
    
    init(item: OperationTypeExpensesItem) {
        self.item = item
    }
    
    var image: UIImage {
        UIImage(named: item.iconName) ?? UIImage()
    }
    
    var sumTransactionText: String {
        String(item.expenses)
    }
    
    var sumTransactionTextColor: UIColor {
        item.expenses >= 0 ? .green : .red
    }
    
    
}
