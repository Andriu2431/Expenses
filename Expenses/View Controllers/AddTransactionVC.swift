//
//  DetailVCViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class AddTransactionVC: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sumTransaction: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var operation: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var operationTypePicker: UIPickerView!
    
    private var item: ExpensesItem?
    private let arrayOperationTypes = ["Продукти", "Розваги", "Навчання", "Інше", "Інвестиції"]
    private var selectedOperationType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationTypePicker.delegate = self
        operationTypePicker.dataSource = self
        setupUI()
        changeColorSegmentedControl()
        operation.addTarget(self, action: #selector(changeColorSegmentedControl), for: .valueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    func configure(item: ExpensesItem) {
        self.item = item
    }
    
    private func setupUI() {
        updateButton.isHidden = true
        title = "Нова транзакція"
        guard let item = self.item else { return }
        
        title = "Редагування"
        descriptionTextField.text = item.description
        sumTransaction.text = String(item.sumTransaction)
        operation.selectedSegmentIndex = item.operation
        selectedOperationType = item.operationType
        operationTypePicker.selectRow(arrayOperationTypes.firstIndex(of: selectedOperationType) ?? 0, inComponent: 0, animated: true)
        datePicker.date = item.dateTransaction
        saveButton.isHidden = true
        updateButton.isHidden = false
    }

    
   @objc private func changeColorSegmentedControl() {
       if operation.selectedSegmentIndex == 0 {
           operation.selectedSegmentTintColor = .green
       } else {
           operation.selectedSegmentTintColor = .red
       }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTaped(_ sender: Any) {
        guard let sum = Int(sumTransaction.text ?? "") else {
            self.createAlert(message: "Введіть коректну суму!")
            return
        }
        
        FirestoreServise.shared.saveTransactionWith(description: descriptionTextField.text ?? "",
                                                    sum: sum,
                                                    operation: operation.selectedSegmentIndex,
                                                    type: selectedOperationType,
                                                    date: datePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonTaped(_ sender: Any) {
        guard let item = item, let sum = Int(sumTransaction.text ?? "") else {
            self.createAlert(message: "Введіть коректну суму!")
            return
        }
        
        FirestoreServise.shared.updateTransaction(description: descriptionTextField.text ?? "",
                                                  sum: sum,
                                                  operation: operation.selectedSegmentIndex,
                                                  type: selectedOperationType,
                                                  date: datePicker.date,
                                                  id: item.id)
        navigationController?.popViewController(animated: true)
    }
    
    private func createAlert(message: String, title: String = "Ok") {
        let alert = UIAlertController(title: "Стоп!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: title, style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

extension AddTransactionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        arrayOperationTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        arrayOperationTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOperationType = arrayOperationTypes[row]
    }
}
