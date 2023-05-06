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
    private var selectedOperationType: Operation = .product
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationTypePicker.delegate = self
        operationTypePicker.dataSource = self
        setupUI()
        changeColorSegmentedControl()
        notificationObserver()
        operation.addTarget(self, action: #selector(changeColorSegmentedControl), for: .valueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func notificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func configure(item: ExpensesItem) {
        self.item = item
    }
    
    private func setupUI() {
        datePicker.contentHorizontalAlignment = .center
        updateButton.isHidden = true
        title = "Нова транзакція"
        guard let item = self.item else { return }
        
        title = "Редагування"
        descriptionTextField.text = item.description
        sumTransaction.text = String(item.sumTransaction)
        operation.selectedSegmentIndex = item.operation
        selectedOperationType = Operation(rawValue: item.operationType) ?? .product
        operationTypePicker.selectRow(Operation.allCases.firstIndex(of: selectedOperationType) ?? 0, inComponent: 0, animated: true)
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
                                                    type: selectedOperationType.rawValue,
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
                                                  type: selectedOperationType.rawValue,
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
        Operation.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Operation.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOperationType = Operation.allCases[row]
    }
}
