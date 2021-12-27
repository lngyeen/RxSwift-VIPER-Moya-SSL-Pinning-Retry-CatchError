//
//  ViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

extension UITableViewCell: Reusable {}

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private let disposeBag = DisposeBag()
    let names = Observable.just(["Register",
                                 "Fetching Data",
                                 "Networking Model",
                                 "RxCocoa"])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "RxSwift Notes"

        tableView.register(cellType: UITableViewCell.self)
        setupCellConfiguration()
        setupCellTapHandling()
    }
}

// MARK: - Rx Setup

private extension HomeViewController {
    func setupCellConfiguration() {
        names.bind(to: tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { row, name, cell in
            cell.textLabel?.text = "\(row + 1) : \(name)"
        }.disposed(by: disposeBag)
    }

    func setupCellTapHandling() {
        tableView.rx.modelSelected(String.self).subscribe { [weak self] name in
            print("Selected cell \(name)")
            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                
                switch selectedRowIndexPath.row {
                case 0:
                    let registerVC = RegisterViewController()
                    self?.navigationController?.pushViewController(registerVC, animated: true)
                case 1:
                    let assembly = MusicListAssembly()
                    self?.navigationController?.pushViewController(assembly.build(), animated: true)
                case 2:
                    let assembly = CocktailCategoriesAssembly()
                    self?.navigationController?.pushViewController(assembly.build(), animated: true)
                case 3:
                    let assembly = WeatherCityAssembly()
                    self?.navigationController?.pushViewController(assembly.build(), animated: true)
                default: break
                }
            }
        } onError: { _ in }.disposed(by: disposeBag)
    }
}
