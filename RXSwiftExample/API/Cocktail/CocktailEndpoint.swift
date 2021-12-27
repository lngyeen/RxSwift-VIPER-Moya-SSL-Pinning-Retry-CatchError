//
//  CocktailEndpoint.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Moya

enum CocktailEndpoint {
    case categories
    case drinks(category: String)
}

extension CocktailEndpoint: BaseEndpoint {
    var category: EndpointCategory {
        return .cocktail
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/api/json/v1/1/list.php"
        case .drinks:
            return "/api/json/v1/1/filter.php"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categories, .drinks:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .categories:
            return URLEncoding.default
        case .drinks:
            return URLEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .categories:
            var parameters = [String: Any]()
            parameters["c"] = "list"
            return Task.requestParameters(
                parameters: parameters,
                encoding: parameterEncoding
            )
        
        case .drinks(let category):
            var parameters = [String: Any]()
            parameters["c"] = category
            return Task.requestParameters(
                parameters: parameters,
                encoding: parameterEncoding
            )
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}

