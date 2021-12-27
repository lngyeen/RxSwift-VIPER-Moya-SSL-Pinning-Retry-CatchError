//
//  CocktailServiceImpl.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Moya
import RxSwift

protocol CocktailService {
    func fetchCategories() -> Single<[CocktailCategory]>
    func fetchDrinksFor(category: String) -> Single<[Drink]>
}

class CocktailServiceImpl: BaseService, CocktailService {
    private static let musicProvider = MoyaProvider<CocktailEndpoint>(
        session: AlamofireSessionManagerBuilder().build(),
        plugins: [
            NetworkLoggerPlugin(configuration: .init(formatter: .init(),
                                                     logOptions: .verbose)
                               ),
        ]
    )
    
    var provider: MoyaProvider<CocktailEndpoint> {
        return CocktailServiceImpl.musicProvider
    }
    
    func fetchCategories() -> Single<[CocktailCategory]> {
        return provider
            .rx
            .request(.categories)
            .catchError(CocktailErrorResponse.self)
            .map(CategoryResult<CocktailCategory>.self)
            .map({$0.drinks})
    }
    
    func fetchDrinksFor(category: String) -> Single<[Drink]> {
        return provider
            .rx
            .request(.drinks(category: category))
            .catchError(CocktailErrorResponse.self)
            .map(DrinkResult.self)
            .map({$0.drinks})
    }
}
