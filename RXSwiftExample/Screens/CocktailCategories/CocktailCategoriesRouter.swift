//
//  CocktailCategoriesRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit
import RxSwift
import RxRelay
import RxFlow

protocol CocktailCategoriesRouterProtocol: Stepper {
    var showCocktailCategoryDetailTrigger: PublishSubject<CocktailCategory> { get }
}

class CocktailCategoriesRouter: CocktailCategoriesRouterProtocol {
    // MARK: - Stepper conformances
    let steps = PublishRelay<Step>()
    
    // MARK: - Router trigger
    let showCocktailCategoryDetailTrigger = PublishSubject<CocktailCategory>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        showCocktailCategoryDetailTrigger
            .map { MainSteps.cocktailCategorieDetailIsRequired(category: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}
