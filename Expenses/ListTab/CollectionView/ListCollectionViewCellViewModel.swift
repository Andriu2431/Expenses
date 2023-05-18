//
//  CollectionViewCellViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class ListCollectionViewCellViewModel: ListCollectionViewCellViewModelProtocol {
    
    private var item: OperationTypeExpensesItem
    
    init(item: OperationTypeExpensesItem) {
        self.item = item
    }
    
    var imageName: String {
        item.iconName
    }
    
    var sumTransaction: Int {
        item.expenses
    }
}
