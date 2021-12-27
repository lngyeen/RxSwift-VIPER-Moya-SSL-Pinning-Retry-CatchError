//
//  CocktailCategoriesInteractor.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import RxSwift

protocol CocktailCategoriesInteractor {
    func fetchCategories() -> Observable<[CocktailCategory]>
    func fetchDrinksFor(category: String) -> Observable<[Drink]>
}

class CocktailCategoriesInteractorImpl: CocktailCategoriesInteractor {
    private let service: CocktailService
    init(service: CocktailService) {
        self.service = service
    }

    func fetchCategories() -> Observable<[CocktailCategory]> {
        return service.fetchCategories()
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }

    func fetchDrinksFor(category: String) -> Observable<[Drink]> {
        return service.fetchDrinksFor(category: category)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }
}
