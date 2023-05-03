//
//  DetailVCViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class AddTransactionVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var plassOrMinus: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costTextField.keyboardType = .numberPad
        datePicker.datePickerMode = .dateAndTime
        plassOrMinus.selectedSegmentIndex = 1
        changeColorSegmentedControl()
        plassOrMinus.addTarget(self, action: #selector(changeColorSegmentedControl), for: .valueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
   @objc private func changeColorSegmentedControl() {
       if plassOrMinus.selectedSegmentIndex == 0 {
           plassOrMinus.selectedSegmentTintColor = .green
       } else {
           plassOrMinus.selectedSegmentTintColor = .red
       }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let description = nameTextField.text,
              let sumTransaction = Int(costTextField.text ?? ""),
              let balance = balanceAfterTransaction(sumTransaction),
              !description.isEmpty else {
            self.createAlert(message: "Введіть коректну суму!")
            return
        }
        
        FirestoreServise.shared.saveTransactionWith(description: description,
                                                    sum: sumTransaction,
                                                    operation: plassOrMinus.selectedSegmentIndex,
                                                    date: datePicker.date,
                                                    balance: balance)
        navigationController?.popViewController(animated: true)
    }
    
    private func balanceAfterTransaction(_ sum: Int) -> Int? {
        guard var curentBalance = Int(navigationController?.title ?? "0") else { return nil }
        
        switch plassOrMinus.selectedSegmentIndex {
        case 0:
            curentBalance += sum
        default:
            guard curentBalance > sum else {
                self.createAlert(message: "Ти як це хоч зробити? Нехватає грошей😩")
                return nil
            }
            curentBalance -= sum
        }
        
        return curentBalance
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: "Стоп!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Піду зароблю)", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
