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
    private var listListener: ListenerRegistration?
    var viewModel: ListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListViewModel()
        tableView.keyboardDismissMode = .onDrag
        listListener = ListenerServise.shared.walletObserve(items: viewModel!.items, completion: { [weak self] result in
            self?.updateUI(result)
        })
    }
    
    private func updateUI(_ result: Result<[ExpensesItem], Error>) {
        switch result {
        case .success(let success):
            viewModel?.setup(items: success.sorted(by: { $0.dateTransaction > $1.dateTransaction }))
            title = viewModel?.currentBalanceCalculation()
            tableView.reloadData()
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    deinit {
        listListener?.remove()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        guard let item = viewModel?.items[indexPath.row] else { return UITableViewCell() }
        cell.configure(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: createSwipeActions(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editVC = viewModel?.createEditViewController(indexPath: indexPath) else { return }
        self.navigationController?.pushViewController(editVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func createSwipeActions(indexPath: IndexPath) -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .normal, title: "Видалити") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.deleteAllertController(indexPath: indexPath)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Редагувати") { [weak self] (action, view, handler) in
            guard let self = self, let editVC = self.viewModel?.createEditViewController(indexPath: indexPath)  else { return }
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        editAction.backgroundColor = .gray
        
        return [deleteAction, editAction]
    }
    
    private func deleteAllertController(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Підтвердіть!", message: "Ви дійсно хочете видалити цей елемент?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Так", style: .default) { [unowned self] action in
            viewModel?.deleteTransaction(indexPath: indexPath)
        }
        let no = UIAlertAction(title: "Ні", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
}

