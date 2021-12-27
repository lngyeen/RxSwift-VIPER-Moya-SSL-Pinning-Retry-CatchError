//
//  CocktailCategoriesPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxSwiftExt

protocol CocktailCategoriesPresenterInputs {
    var refreshTrigger: PublishSubject<Void> { get }
    var showCategoryDetailTrigger: PublishSubject<CocktailCategory> { get }
}

protocol CocktailCategoriesPresenterOutputs {
    var categories: Observable<[CocktailCategory]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}

protocol CocktailCategoriesPresenter {
    var inputs: CocktailCategoriesPresenterInputs { get }
    var outputs: CocktailCategoriesPresenterOutputs { get }
}

struct CocktailCategoriesPresenterDependencies {
    let router: CocktailCategoriesRouterProtocol
    let interactor: CocktailCategoriesInteractor
}

class CocktailCategoriesPresenterImpl: CocktailCategoriesPresenter,
    CocktailCategoriesPresenterInputs,
    CocktailCategoriesPresenterOutputs
{
    var inputs: CocktailCategoriesPresenterInputs { return self }
    var outputs: CocktailCategoriesPresenterOutputs { return self }
    
    // MARK: - Inputs
    
    let refreshTrigger = PublishSubject<Void>()
    let showCategoryDetailTrigger = PublishSubject<CocktailCategory>()
    
    // MARK: - Outputs
    
    var categories: Observable<[CocktailCategory]> { categoriesBehaviorRelay.asObservable() }
    var isLoading: Observable<Bool> { isLoadingPublishSubject.asObservable() }
    var error: Observable<Error> { errorPublishSubject.asObservable() }

    // MARK: - Private properties
    
    private let dependencies: CocktailCategoriesPresenterDependencies
    private let disposeBag = DisposeBag()
    private var currentPage: Int = 0
    private let categoriesBehaviorRelay: BehaviorRelay<[CocktailCategory]> = BehaviorRelay(value: [])
    private let isLoadingPublishSubject = PublishSubject<Bool>()
    private let errorPublishSubject = PublishSubject<Error>()
    
    init(dependencies: CocktailCategoriesPresenterDependencies) {
        self.dependencies = dependencies
        bindingInputs()
    }
    
    private var lastRequestDisposable: Disposable?
    
    private func bindingInputs() {
        // refreshTrigger
        inputs
            .refreshTrigger
            .startLoading(isLoadingPublishSubject)
            .flatMap { () in
                self.refreshAllCategories()
            }
            .stopLoading(isLoadingPublishSubject)
            .subscribe(onNext: { materializedEvent in
                switch materializedEvent {
                case let .next(categories):
                    self.processCocktailCategories(categories, isRefresing: true)
                case let .error(error):
                    self.errorPublishSubject.onNext(error)
                default: break
                }
            }).disposed(by: disposeBag)

        // showMusicDetailTrigger
        inputs
            .showCategoryDetailTrigger
            .subscribe { [dependencies] (category: CocktailCategory) in
                dependencies.router.showCocktailCategoryDetail(category)
            }.disposed(by: disposeBag)
    }
    
    private func processCocktailCategories(_ newCategories: [CocktailCategory], isRefresing: Bool = false) {
        categoriesBehaviorRelay.accept(newCategories)
    }
    
    private func refreshAllCategories() -> Observable<Event<[CocktailCategory]>> {
        let newCategories = dependencies.interactor
            .fetchCategories()
            .asObservable()
            .share(replay: 1)
        
        let newDrinks = newCategories
            .flatMap { [dependencies] categories in
                Observable.from(categories.map { category in
                    dependencies.interactor.fetchDrinksFor(category: category.strCategory)
                })
            }
            .merge(maxConcurrent: 3)
        
        return newCategories
            .flatMap { categories in
                newDrinks
                    .enumerated()
                    .scan([]) { (updated, element: (index: Int, drinks: [Drink])) -> [CocktailCategory] in
                        var new: [CocktailCategory] = updated
                        new.append(CocktailCategory(strCategory: categories[element.index].strCategory, items: element.drinks))
                        return new
                    }
            }
            .materialize()
    }
}
