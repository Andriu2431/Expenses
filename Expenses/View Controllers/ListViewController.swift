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
    private var viewModel: TableViewViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListTableViewViewModel()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        listListener = ListenerServise.shared.walletObserve(items: viewModel!.getAllItemsForListener(), completion: { [weak self] result in
            self?.updateUI(result)
        })
    }
    
    private func updateUI(_ result: Result<[ExpensesItem], Error>) {
        switch result {
        case .success(let success):
            viewModel?.setup(items: success.sorted(by: { $0.dateTransaction > $1.dateTransaction }))
            title = viewModel?.currentBalanceCalculation()
            updateConstaraint()
            tableView.reloadData()
            collectionView.reloadData()
        case .failure(let failure):
            print(failure.localizedDescription)
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: viewModel?.createSwipeActions(indexPath: indexPath, viewController: self) ?? [])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.createEditViewController(indexPath: indexPath, viewController: self)
        tableView.deselectRow(at: indexPath, animated: false)
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
        return cell
    }
    
}
