//
//  DetailVCViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var plassOrMinus: UISegmentedControl!
    
    var complition: ((ExpensesItem) -> ())?
    let dateFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormater.dateFormat = "dd/MM/YY"
        self.costTextField.keyboardType = .numberPad
        self.datePicker.datePickerMode = .date
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let name = nameTextField.text, let description = descriptionTextField.text, let cost = costTextField.text else { return }
        let item = ExpensesItem(name: name, description: description, cost: cost, operation: plassOrMinus.selectedSegmentIndex, date: dateFormater.string(from: datePicker.date))
        complition?(item)
        navigationController?.popViewController(animated: true)
    }
    
}
