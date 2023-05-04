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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: createSwipeActions(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        pushEditViewController(item: item)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func pushEditViewController(item: ExpensesItem) {
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! AddTransactionVC
        editVC.configure(item: item)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func createSwipeActions(index: Int) -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .normal, title: "Видалити") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.deleteAllertController(index: index)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Редагувати") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            let item = self.items[index]
            self.pushEditViewController(item: item)
        }
        editAction.backgroundColor = .gray
        
        return [deleteAction, editAction]
    }
    
    private func deleteAllertController(index: Int) {
        let alert = UIAlertController(title: "Підтвердіть!", message: "Ви дійсно хочете видалити цей елемент?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Так", style: .default) { [unowned self] action in
            let item = self.items[index]
            FirestoreServise.shared.deleteTransaction(itemId: item.id)
            self.tableView.reloadData()
        }
        let no = UIAlertAction(title: "Ні", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
}

