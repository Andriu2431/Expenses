//
//  ViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [ExpensesItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let addTransaction as AddTransaction = segue.destination, segue.identifier == "segue" {
            addTransaction.complition = { [unowned self] item in
                self.title = item.total
                self.items.append(item)
                self.tableView.reloadData()
            }
        }
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
            cell.cost.textColor = .green
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
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

