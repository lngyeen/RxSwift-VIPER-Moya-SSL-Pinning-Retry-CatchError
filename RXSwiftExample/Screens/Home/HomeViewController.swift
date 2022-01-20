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
import RxFlow

extension UITableViewCell: Reusable {}

class HomeViewController: UIViewController, Stepper {
    @IBOutlet var tableView: UITableView!
    private let disposeBag = DisposeBag()
    let names = Observable.just(["Register",
                                 "Fetching Data",
                                 "Networking Model",
                                 "RxCocoa"])
    // Stepper conformances
    let steps = PublishRelay<Step>()
    
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
                    self?.steps.accept(MainSteps.registerScreenIsRequired)
                    
                case 1:
                    self?.steps.accept(MainSteps.allMusicIsRequired)
                    
                case 2:
                    self?.steps.accept(MainSteps.cocktailCategoriesIsRequired)
                    
                case 3:
                    self?.steps.accept(MainSteps.weatherCityIsRequired)
                    
                default: break
                }
            }
        } onError: { _ in }.disposed(by: disposeBag)
    }
}
