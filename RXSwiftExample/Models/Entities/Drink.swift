//
//  Cocktail.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation

public struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

public struct DrinkResult: Codable {
    var drinks: [Drink]
}
