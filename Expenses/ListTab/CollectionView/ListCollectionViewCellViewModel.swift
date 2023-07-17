//
//  CollectionViewCellViewModel.swift
//  Expenses
//
//  Created by Andrii Malyk on 15.05.2023.
//

import Foundation

class ListCollectionViewCellViewModel: ListCollectionViewCellViewModelProtocol {
    
    private var item: CollectionViewCellModel
    
    init(item: CollectionViewCellModel) {
        self.item = item
    }
    
    var imageName: String {
        item.iconName
    }
    
    var sumTransaction: Int {
        item.expenses
    }
}
