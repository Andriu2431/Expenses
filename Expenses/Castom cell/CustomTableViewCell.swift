//
//  CustomTableViewCell.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var opetaionType: UILabel!
    
    private var dateFormater = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater.dateFormat = "dd/MM/yyyy"
    }

    func configure(item: ExpensesItem) {
        descriptionLabel.text = item.description
        dateLabel.text = dateFormater.string(from: item.dateTransaction)
        opetaionType.text = item.operationType
        switch item.operation {
        case 0:
            cost.text = "+\(item.sumTransaction) грн"
            cost.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        default:
            cost.text = "-\(item.sumTransaction) грн"
            cost.textColor = .red
        }
    }
}
