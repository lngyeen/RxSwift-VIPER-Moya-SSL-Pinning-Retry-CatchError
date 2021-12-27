//
//  DrinkListPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxSwiftExt

struct DrinkListPresenterDependencies {
    let interactor: DrinkListInteractorProtocol
    let router: DrinkListRouterProtocol
}

protocol DrinkListPresenterInputs {
    var showDrinkDetailTrigger: PublishSubject<Drink> { get }
    var refreshTrigger: PublishSubject<Void> { get }
}

protocol DrinkListPresenterOutputs {
    var drinks: Observable<[Drink]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}

protocol DrinkListPresenter {
    var inputs: DrinkListPresenterInputs { get }
    var outputs: DrinkListPresenterOutputs { get }
}

class DrinkListPresenterImpl: DrinkListPresenter, DrinkListPresenterInputs, DrinkListPresenterOutputs {
    var inputs: DrinkListPresenterInputs { return self }
    var outputs: DrinkListPresenterOutputs { return self }

    // MARK: - Inputs
    
    let showDrinkDetailTrigger = PublishSubject<Drink>()
    
    let refreshTrigger = PublishSubject<Void>()
    
    // MARK: - Outputs

    var drinks: Observable<[Drink]> { drinksBehaviorRelay.asObservable() }
    
    var isLoading: Observable<Bool> { isLoadingPublishSubject.asObservable() }
    
    var error: Observable<Error> { errorPublishSubject.asObservable() }
    
    // MARK: - Private properties
    
    private let dependencies: DrinkListPresenterDependencies
    private let disposeBag = DisposeBag()
    private var category: CocktailCategory
    private let drinksBehaviorRelay: BehaviorRelay<[Drink]> = BehaviorRelay(value: [])
    private let isLoadingPublishSubject = PublishSubject<Bool>()
    private let errorPublishSubject = PublishSubject<Error>()
    
    init(category: CocktailCategory,
         dependencies: DrinkListPresenterDependencies)
    {
        self.category = category
        self.dependencies = dependencies
        bindingInputs()
    }
    
    // MARK: - Private methods
    
    private func bindingInputs() {
        // refreshTrigger
        inputs
            .refreshTrigger
            .startLoading(isLoadingPublishSubject)
            .flatMap { [dependencies, category] in
                dependencies.interactor.fetchDrinksFor(category: category.strCategory).materialize()
            }
            .stopLoading(isLoadingPublishSubject)
            .subscribe(onNext: { [weak self] materializedEvent in
                switch materializedEvent {
                case let .next(drinks):
                    self?.processDrinks(drinks, isRefresing: true)
                case let .error(error):
                    self?.errorPublishSubject.onNext(error)
                default: break
                }
            }).disposed(by: disposeBag)
        
        // showDrinkDetailTrigger
        inputs
            .showDrinkDetailTrigger
            .subscribe { [dependencies] (drink: Drink) in
                dependencies.router.showDrinkDetail(drink)
            }.disposed(by: disposeBag)
    }
    
    private func processDrinks(_ newDrinks: [Drink], isRefresing: Bool = false) {
        var allDrinks: [Drink]
        if isRefresing {
            allDrinks = newDrinks
        } else {
            allDrinks = drinksBehaviorRelay.value + newDrinks
        }
        drinksBehaviorRelay.accept(allDrinks)
    }
}
