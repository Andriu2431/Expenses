//
//  CollectionViewCellViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import UIKit

protocol CollectionViewCellViewModelProtocol: AnyObject {
    var image: UIImage {get}
    var sumTransactionText: String {get}
    var sumTransactionTextColor: UIColor {get}
}
