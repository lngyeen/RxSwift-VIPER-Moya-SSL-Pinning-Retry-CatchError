//
//  CocktailCategoriesAssembly.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation

class CocktailCategoriesAssembly: Assembly {
    init() {}

    func build() -> CocktailCategoriesViewController {
        let controller = CocktailCategoriesViewController()
        let router = CocktailCategoriesRouter()
        let intoractor = CocktailCategoriesInteractorImpl(service: CocktailServiceImpl())
        let dependencies = CocktailCategoriesPresenterDependencies(router: router, interactor: intoractor)
        let presenter = CocktailCategoriesPresenterImpl(dependencies: dependencies)
        controller.presenter = presenter
        return controller
    }
}
