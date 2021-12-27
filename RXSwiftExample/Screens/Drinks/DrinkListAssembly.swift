//
//  DrinkListAssembly.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation

class DrinkListAssembly: Assembly {
    let category: CocktailCategory
    init(category: CocktailCategory) {
        self.category = category
    }

    func build() -> DrinkListViewController {
        let controller = DrinkListViewController()
        let router = DrinkListRouter(viewController: controller)
        let intoractor = DrinkListInteractor(service: CocktailServiceImpl())
        let presenter = DrinkListPresenterImpl(category: category,
                                               dependencies: DrinkListPresenterDependencies(interactor: intoractor, router: router))
        controller.presenter = presenter
        return controller
    }
}
