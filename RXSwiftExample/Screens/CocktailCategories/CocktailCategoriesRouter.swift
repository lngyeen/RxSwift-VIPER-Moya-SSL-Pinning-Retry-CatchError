//
//  CocktailCategoriesRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit

protocol CocktailCategoriesRouterProtocol {
    var viewController: CocktailCategoriesViewController? { get }
    func showCocktailCategoryDetail(_ category: CocktailCategory)
}

class CocktailCategoriesRouter: CocktailCategoriesRouterProtocol {
    weak var viewController: CocktailCategoriesViewController?

    init(viewController: CocktailCategoriesViewController) {
        self.viewController = viewController
    }

    func showCocktailCategoryDetail(_ category: CocktailCategory) {
        let assembly = DrinkListAssembly(category: category)
        viewController?.navigationController?.pushViewController(assembly.build(), animated: true)
    }
}
