//
//  MusicListViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Kingfisher
import Reusable
import RxCocoa
import RxSwift
import UIKit

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}

class MusicListViewController: BaseViewController {
    // MARK: - Outlet

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        return button
    }()

    // MARK: - Properties

    var presenter: MusicListPresenter?

    // MARK: - Private properties

    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = "Musics"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        tableView.register(cellType: MusicCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
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
            .musics
            .bind(to: tableView
                .rx
                .items(cellIdentifier: MusicCell.reuseIdentifier,
                       cellType: MusicCell.self)) { _, musicViewModel, cell in
                cell.musicViewModel = musicViewModel
            }.disposed(by: disposeBag)
        
        presenter?
            .outputs
            .error
            .bind(to: self.rx.errorAlert)
            .disposed(by: disposeBag)
    }
    
    override func bindingPresenterInputs() {
        guard let presenter = presenter else {
            return
        }

        // loadmore trigger
        tableView
            .rx
            .willDisplayCell
            .filter { [weak self] in (self?.tableView.numberOfRows(inSection: 0) ?? 0) - $0.indexPath.row == 10
            }
            .map { _ in () }
            .bind(to: presenter.inputs.loadMoreTrigger)
            .disposed(by: disposeBag)
        
        // refresh trigger
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: presenter.inputs.refreshTrigger)
            .disposed(by: disposeBag)
        button.rx.tap.map { () }
            .bind(to: presenter.inputs.refreshTrigger)
            .disposed(by: disposeBag)
        
        // show music detail trigger
        tableView
            .rx
            .modelSelected(MusicViewModel.self)
            .do { [tableView] (_: MusicViewModel) in
                if let selectedRowIndexPath = tableView?.indexPathForSelectedRow {
                    tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }
            .asObservable()
            .bind(to: presenter.inputs.showMusicDetailTrigger)
            .disposed(by: disposeBag)
        
        // search trigger
        searchTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .bind(to: presenter.inputs.searchTrigger)
            .disposed(by: disposeBag)
    }
    
    override func setupData() {
        super.setupData()
        
        presenter?.inputs.refreshTrigger.onNext(())
    }
}
