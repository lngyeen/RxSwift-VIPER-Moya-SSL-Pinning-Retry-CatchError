//
//  CocktailCategoriesViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Kingfisher
import Reusable
import RxCocoa
import RxSwift
import UIKit

class CocktailCategoriesViewController: BaseViewController {
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties

    var presenter: CocktailCategoriesPresenter?
    
    // MARK: - Private dependencies
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        title = "Cocktail Categories"
        
        tableView.register(cellType: UITableViewCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
    }
    
    override func bindingPresenterOutputs() {
        // isLoading trigger
        presenter?
            .outputs
            .isLoading
            .do(onNext: { [refreshControl] isLoading in
                if !isLoading {
                    refreshControl.endRefreshing()
                }
            })
            .bind(to: view.rx.isLoadingHUD)
            .disposed(by: disposeBag)
                
        // categories trigger
        presenter?
            .outputs
            .categories
            .bind(to: tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier,
                                         cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = "\(item.strCategory) - \(String(describing: item.items.count)) items"
            }.disposed(by: disposeBag)
        
        // error trigger
        presenter?
            .outputs
            .error
            .bind(to: rx.errorAlert)
            .disposed(by: disposeBag)
    }
    
    override func bindingPresenterInputs() {
        guard let presenter = presenter else {
            return
        }
        
        // refreshTrigger
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: presenter.inputs.refreshTrigger)
            .disposed(by: disposeBag)

        // showCategoryDetailTrigger
        tableView
            .rx
            .modelSelected(CocktailCategory.self)
            .do { [tableView] (_: CocktailCategory) in
                if let selectedRowIndexPath = tableView?.indexPathForSelectedRow {
                    tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }
            .bind(to: presenter.inputs.showCategoryDetailTrigger)
            .disposed(by: disposeBag)
    }
    
    override func setupData() {
        presenter?.inputs.refreshTrigger.onNext(())
    }
}
