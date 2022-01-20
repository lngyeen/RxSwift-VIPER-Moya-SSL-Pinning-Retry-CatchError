//
//  DrinkListRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit
import RxSwift

protocol DrinkListRouterProtocol {
    var showDrinkDetailTrigger: PublishSubject<Drink> { get }
}

class DrinkListRouter: DrinkListRouterProtocol {
    let showDrinkDetailTrigger = PublishSubject<Drink>()
    
    private let disposeBag = DisposeBag()
    
    init() { }
}
