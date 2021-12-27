//
//  Api.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import Moya
import RxSwift

enum EndpointCategory {
    case music
    case cocktail
    case weather
}

protocol BaseEndpoint: TargetType {
    var category: EndpointCategory { get }
}

extension BaseEndpoint {
    var baseURL: URL {
        return Environment.baseUrl(self)
    }
    
    var headers: [String : String]? {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return [ "App-Version" :  version ]
        } else {
            return nil
        }
    }
}
