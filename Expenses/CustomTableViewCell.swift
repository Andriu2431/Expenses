//
//  CustomTableViewCell.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var forWhat: UILabel!
    @IBOutlet weak var descriptionForWhat: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
