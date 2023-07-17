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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var listListener: ListenerRegistration?
    private var viewModel: ListTableViewViewModelProtocol?
    private var isSelectedOperation = false
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListAllOperationViewModel()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransactionTapped))
        listListener = ListenerServise.shared.walletObserve(items: viewModel!.getAllItemsForListener(), completion: { [weak self] result in
            self?.updateUI(result)
        })
    }
    
    @objc func addTransactionTapped() {
        createAddViewController()
    }
    
    private func updateUI(_ result: Result<[ExpensesItem], Error>) {
        switch result {
        case .success(let success):
            viewModel?.setup(items: success.sorted(by: { $0.dateTransaction > $1.dateTransaction }))
            title = viewModel?.currentBalanceCalculation()
            updateConstaraint()
            if let selectedIndexPath {
                filtrationByOperations(indexPath: selectedIndexPath, selected: isSelectedOperation)
            }
            tableView.reloadData()
            collectionView.reloadData()
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    private func createAddViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "DetailTransactionVc") as! DetailTrasactionVC
        let addViewModel = viewModel?.createAddTransactionViewModel()
        addVC.viewModel = addViewModel
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func updateConstaraint() {
        collectionViewHeight.constant = viewModel?.calculateCollectionViewHeight() ?? 90
        contentViewHeight.constant = view.safeAreaLayoutGuide.layoutFrame.size.height + collectionViewHeight.constant
    }
    
    deinit {
        listListener?.remove()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Всі витрати!"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tableViewCellNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        guard let cellViewModel = viewModel?.tableViewCellViewModel(indexPath: indexPath) else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createEditViewController(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: createSwipeActions(indexPath: indexPath))
    }
    
    private func createSwipeActions(indexPath: IndexPath) -> [UIContextualAction] {
        let deleteAction = UIContextualAction(style: .normal, title: "Видалити") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.deleteAllertController(indexPath: indexPath)
            handler(true)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Редагувати") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.createEditViewController(indexPath: indexPath)
            handler(true)
        }
        editAction.backgroundColor = .gray
        
        return [deleteAction, editAction]
    }
    
    private func deleteAllertController(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Підтвердіть!", message: "Ви дійсно хочете видалити цей елемент?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Так", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.viewModel?.deleteTransaction(indexPath: indexPath)
        }
        let no = UIAlertAction(title: "Ні", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
    
    private func createEditViewController(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "DetailTransactionVc") as! DetailTrasactionVC
        let editViewModel = viewModel?.createEditTransactionViewModel(indexPath: indexPath)
        editVC.viewModel = editViewModel
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.collectionViewCellNumberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCollectionViewCell
        guard let cellViewModel = viewModel?.collectioViewCellViewModel(indexPath: indexPath) else { return UICollectionViewCell() }
        cell.viewModel = cellViewModel
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // тут ми повінні перевірити - якщо є вибранйи алемент але ми тапаємо не по ньому, тоді нічого не робимо
        if isSelectedOperation, selectedIndexPath != indexPath {
            return
        } else {
            filtrationByOperations(indexPath: indexPath, selected: isSelectedOperation)
        }
    }
    
    private func filtrationByOperations(indexPath: IndexPath, selected: Bool) {
        isSelectedOperation = !selected
        selectedIndexPath = isSelectedOperation ? indexPath : nil
        viewModel?.sortedBy(indexPath: indexPath, selected: isSelectedOperation)
        collectionView.cellForItem(at: indexPath)?.backgroundColor = isSelectedOperation ? .lightGray : nil
        tableView.reloadData()
    }
}
