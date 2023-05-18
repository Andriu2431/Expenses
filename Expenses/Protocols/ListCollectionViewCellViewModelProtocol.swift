//
//  ListCollectionViewCellViewModelProtocol.swift
//  Expenses
//
//  Created by Andrii Malyk on 18.05.2023.
//

import Foundation

protocol ListCollectionViewCellViewModelProtocol: AnyObject {
    var imageName: String {get}
    var sumTransaction: Int {get}
}
