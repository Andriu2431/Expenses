//
//  ViewController.swift
//  Expenses
//
//  Created by Andrii Malyk on 09.11.2022.
//

import UIKit

struct ExpensesItem: Codable {
    var name: String
    var description: String
    var cost: String
    var operation: Int
    var date: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wallet: UITextField!
    
    var cost = ""
    
    var items = [ExpensesItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items), let encodedWallet = try? encoder.encode(wallet.text) {
               UserDefaults.standard.set(encoded, forKey: "Items")
                UserDefaults.standard.set(encodedWallet, forKey: "Wallet")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if let items = UserDefaults.standard.data(forKey: "Items"), let test = UserDefaults.standard.data(forKey: "Wallet") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpensesItem].self, from: items),
               let decodedWallet = try? decoder.decode(String.self, from: test) {
                self.items = decoded
                self.cost = decodedWallet
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wallet.text = cost
        self.wallet.keyboardType = .numberPad
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let secondViewController as DetailViewController = segue.destination, segue.identifier == "segue" {
            secondViewController.complition = { [unowned self] item in
                guard let walletInt = Int(wallet.text ?? "0"), let costInt = Int(item.cost) else { return }
                switch item.operation {
                case 0:
                    wallet.text = String(walletInt + costInt)
                case 1:
                    guard costInt < walletInt else { createAlert(message: "Ти як це хоч зробити? Нехватає грошей😩")
                        return }
                    wallet.text = String(walletInt - costInt)
                default:
                    break
                }
                self.items.append(item)
                self.tableView.reloadData()
            }
        }
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: "Стоп!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Піду зароблю)", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.forWhat.text = item.name
        cell.descriptionForWhat.text = item.description
        cell.dateLabel.text = item.date
        switch item.operation {
        case 0:
            cell.cost.text = "+\(item.cost) грн"
            cell.cost.textColor = .green
        case 1:
            cell.cost.text = "-\(item.cost) грн"
            cell.cost.textColor = .red
        default:
            break
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

