//
//  ViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [ExpensesItem]()
    private var listListener: ListenerRegistration?
    private var dateFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormater.dateFormat = "dd/MM/yyyy"
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        listListener = ListenerServise.shared.walletObserve(items: items, completion: { [weak self] result in
            self?.updateUI(result)
        })
    }
    
    private func updateUI(_ result: Result<[ExpensesItem], Error>) {
        switch result {
        case .success(let success):
            items = success.sorted(by: { $0.dateTransaction > $1.dateTransaction })
            title = currentBalanceCalculation(items: items)
            tableView.reloadData()
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    private func currentBalanceCalculation(items: [ExpensesItem]) -> String {
        var profit: [Int] = []
        var costs: [Int] = []
        
        items.forEach { item in
            item.operation == 0 ? profit.append(item.sumTransaction) : costs.append(item.sumTransaction)
        }

        return String(profit.reduce(0, +) - costs.reduce(0, +))
    }
    
    deinit {
        listListener?.remove()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.name.text = item.description
        cell.dateLabel.text = dateFormater.string(from: item.dateTransaction)
        switch item.operation {
        case 0:
            cell.cost.text = "+\(item.sumTransaction) грн"
            cell.cost.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        default:
            cell.cost.text = "-\(item.sumTransaction) грн"
            cell.cost.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        FirestoreServise.shared.deleteTransaction(item: item)
        self.tableView.reloadData()
    }
}

