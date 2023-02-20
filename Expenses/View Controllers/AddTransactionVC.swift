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
    
    let dateFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormater.dateFormat = "dd/MM/yyyy, HH:mm:ss"
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
        guard let name = nameTextField.text, let cost = costTextField.text, let costInt = Int(cost), let totalMoney = returnTotalMoney(price: costInt), !name.isEmpty, !cost.isEmpty else {
            self.createAlert(message: "Введіть коректну суму!")
            return
        }
        
        FirestoreServise.shared.saveTransactionWith(name: name,
                                                    cost: cost,
                                                    operation: String(plassOrMinus.selectedSegmentIndex),
                                                    date: dateFormater.string(from: datePicker.date),
                                                    total: totalMoney)
        navigationController?.popViewController(animated: true)
    }
    
    private func returnTotalMoney(price: Int) -> String? {
        guard var totalMonay = Int(navigationController?.title ?? "0") else { return nil }
        
        switch plassOrMinus.selectedSegmentIndex {
        case 0:
            totalMonay += price
        default:
            guard totalMonay > price else {
                self.createAlert(message: "Ти як це хоч зробити? Нехватає грошей😩")
                return nil
            }
            totalMonay -= price
        }
        
        return String(totalMonay)
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: "Стоп!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Піду зароблю)", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
