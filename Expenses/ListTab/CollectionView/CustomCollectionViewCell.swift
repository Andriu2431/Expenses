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
    
    weak var viewModel: ListCollectionViewCellViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            imageView.image = UIImage(named: viewModel.imageName)
            costLabel.text = viewModel.sumTransaction.description
            costLabel.textColor = viewModel.sumTransaction >= 0 ? .green : .red
        }
    }
}
