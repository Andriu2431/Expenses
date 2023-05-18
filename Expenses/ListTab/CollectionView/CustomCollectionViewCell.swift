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
    
    weak var viewModel: CollectionViewCellViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            imageView.image = viewModel.image
            costLabel.text = viewModel.sumTransactionText
            costLabel.textColor = viewModel.sumTransactionTextColor
        }
    }
}
