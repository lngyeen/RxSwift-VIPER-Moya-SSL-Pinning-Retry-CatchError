//
//  CocktailCategory.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation

public struct CocktailCategory: Codable {
    var strCategory: String
    var items: [Drink] = []
    
    private enum CodingKeys: String, CodingKey {
        case strCategory
    }
}

public struct CategoryResult<T: Codable> : Codable {
    var drinks: [T]
}
