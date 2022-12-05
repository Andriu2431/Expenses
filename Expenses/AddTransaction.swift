//
//  DetailVCViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class AddTransaction: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
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
        guard let name = nameTextField.text, let cost = costTextField.text, let totalMoney = returnTotalMoney(price: Int(cost) ?? 0), !name.isEmpty, !cost.isEmpty else { return }
        
        FirestoreServise.shared.saveTransactionWith(name: name,
                                                    cost: cost,
                                                    operation: String(plassOrMinus.selectedSegmentIndex),
                                                    date: dateFormater.string(from: datePicker.date),
                                                    total: totalMoney) { result in
            switch result {
            case .success(let success):
                self.complition?(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func returnTotalMoney(price: Int) -> String? {
        guard var totalMonay = Int(navigationController?.title ?? "0") else { return nil }
        
        switch plassOrMinus.selectedSegmentIndex {
        case 0:
            totalMonay += price
        default:
            guard totalMonay > price else { createAlert(message: "Ти як це хоч зробити? Нехватає грошей😩")
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
        present(alert, animated: true)
    }
}
