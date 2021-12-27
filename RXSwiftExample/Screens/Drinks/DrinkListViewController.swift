//
//  DrinkListViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Kingfisher
import Reusable
import RxCocoa
import RxSwift
import UIKit

class DrinkListViewController: BaseViewController {
    // MARK: - Outlet

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties

    var presenter: DrinkListPresenter?

    // MARK: - Private properties
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        tableView.register(cellType: DrinkCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
    }
    
    override func bindingPresenterInputs() {
        guard let presenter = presenter else {
            return
        }
        
        // refresh trigger
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: presenter.inputs.refreshTrigger)
            .disposed(by: disposeBag)
        
        // show drink detail trigger
        tableView.rx.modelSelected(Drink.self).do { [tableView] (_: Drink) in
            if let selectedRowIndexPath = tableView!.indexPathForSelectedRow {
                tableView!.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }.bind(to: presenter.inputs.showDrinkDetailTrigger)
            .disposed(by: disposeBag)
    }
    
    override func bindingPresenterOutputs() {
        presenter?
            .outputs
            .isLoading
            .do(onNext: { [refreshControl] isLoading in
                if !isLoading {
                    refreshControl.endRefreshing()
                }
            })
            .bind(to: self.view.rx.isLoadingHUD)
            .disposed(by: disposeBag)
        
        presenter?
            .outputs
            .drinks
            .bind(to: tableView.rx.items(cellIdentifier: DrinkCell.reuseIdentifier,
                                         cellType: DrinkCell.self)) { _, drink, cell in
                cell.nameLabel.text = drink.strDrink
                cell.thumbnailImageView.kf.setImage(with: URL(string: drink.strDrinkThumb)!)
            }.disposed(by: disposeBag)
        
        presenter?
            .outputs
            .error
            .bind(to: self.rx.errorAlert)
            .disposed(by: disposeBag)
    }
    
    override func setupData() {
        presenter?.inputs.refreshTrigger.onNext(())
    }
}
