//
//  DrinkListInteractor.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import RxSwift

protocol DrinkListInteractorProtocol {
    func fetchDrinksFor(category: String) -> Observable<[Drink]>
}

class DrinkListInteractor: DrinkListInteractorProtocol {
    private let service: CocktailService
    init(service: CocktailService) {
        self.service = service
    }

    func fetchDrinksFor(category: String) -> Observable<[Drink]> {
        return service.fetchDrinksFor(category: category)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }
}
