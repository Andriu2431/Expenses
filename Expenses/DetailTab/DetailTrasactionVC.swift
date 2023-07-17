//
//  AddOrEditTransactionVC.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class DetailTrasactionVC: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sumTransaction: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var operation: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var operationTypePicker: UIPickerView!
    
    var viewModel: DetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeColorSegmentedControl()
        operation.addTarget(self, action: #selector(changeColorSegmentedControl), for: .valueChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        self.view.layer.insertSublayer(createGradientLayer(), at: 0)
    }
    
    private func setup() {
        guard let viewModel = viewModel else { return }
        title = viewModel.title
        operationTypePicker.delegate = self
        operationTypePicker.dataSource = self
        datePicker.contentHorizontalAlignment = .center
        descriptionTextField.text = viewModel.description
        sumTransaction.text = viewModel.sumTransactionText
        operation.selectedSegmentIndex = viewModel.operation
        operationTypePicker.selectRow(Operation.allCases.firstIndex(of: viewModel.selectedOperationType) ?? 0, inComponent: 0, animated: true)
        datePicker.date = viewModel.dateTransaction
        saveButton.isHidden = viewModel.isSave
        updateButton.isHidden = !viewModel.isSave
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
            self.presentAlert(title: "Помилка!", massage: "Введіть коректну суму!")
            return
        }
        viewModel?.saveTransaction(description: descriptionTextField.text ?? "",
                                   sum: sum,
                                   operation: operation.selectedSegmentIndex,
                                   date: datePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonTaped(_ sender: Any) {
        guard let sum = Int(sumTransaction.text ?? "") else {
            self.presentAlert(title: "Помилка!", massage: "Введіть коректну суму!")
            return
        }

        viewModel?.updateTransaction(description: descriptionTextField.text ?? "",
                                     sum: sum,
                                     operation: operation.selectedSegmentIndex,
                                     date: datePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailTrasactionVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
        viewModel?.selectedOperationType = Operation.allCases[row]
    }
}
