//
//  CustomTableViewCell.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var opetaionType: UILabel!
    
    weak var viewModel: TableViewCellViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            descriptionLabel.text = viewModel.description
            dateLabel.text = viewModel.dateTransaction
            opetaionType.text = viewModel.operationType
            cost.text = viewModel.sumTransactionText
            cost.textColor = viewModel.sumTransactionTextColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerView.clipsToBounds = true
        cornerView.layer.cornerRadius = 20
        cornerView.layer.borderColor = UIColor.gray.cgColor
        cornerView.layer.borderWidth = 0.5
    }
}
