//
//  DrinkListRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit

protocol DrinkListRouterProtocol {
    var viewController: DrinkListViewController? { get }
    func showDrinkDetail(_ drink: Drink)
}

class DrinkListRouter: DrinkListRouterProtocol {
    weak var viewController: DrinkListViewController?

    init(viewController: DrinkListViewController) {
        self.viewController = viewController
    }

    func showDrinkDetail(_ drink: Drink) {
        // let assembly = DrinkDetailAssembly(drink: drink)
        // viewController?.navigationController?.pushViewController(assembly.build(), animated: true)
    }
}
