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
        self.dateFormater.dateFormat = "dd/MM/yyyy, HH:mm:ss"
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
        listListener = ListenerServise.shared.walletObserve(items: items, completion: { [self] result in
            switch result {
            case .success(let success):
                self.items = success.sorted(by: {
                    self.dateFormater.date(from: $0.date)! > self.dateFormater.date(from: $1.date)!
                })
                self.title = self.items.first?.total
                self.tableView.reloadData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
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
        cell.name.text = item.name
        cell.dateLabel.text = item.date
        switch item.operation {
        case "0":
            cell.cost.text = "+\(item.cost) грн"
            cell.cost.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        default:
            cell.cost.text = "-\(item.cost) грн"
            cell.cost.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard var lastItem = items.first, let lastItemTotal = Int(lastItem.total), let itemCost = Int(item.cost) else { return }
        switch item.operation {
        case "0":
            lastItem.total = String(lastItemTotal - itemCost)
        default:
            lastItem.total = String(lastItemTotal + itemCost)
        }
        
        FirestoreServise.shared.updateTransaction(item: lastItem)
        FirestoreServise.shared.deleteTransaction(item: item)
        self.tableView.reloadData()
    }
}

