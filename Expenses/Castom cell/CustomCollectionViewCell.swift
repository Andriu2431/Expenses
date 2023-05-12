//
//  CustomCollectionViewCell.swift
//  Expenses
//
//  Created by Andrii Malyk on 08.05.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    
    func configure(item: OperationTypeExpensesItem) {
        imageView.image = UIImage(named: item.iconName)
        costLabel.textColor = item.expenses >= 0 ? .green : .red
        costLabel.text = String(item.expenses)
    }
}
