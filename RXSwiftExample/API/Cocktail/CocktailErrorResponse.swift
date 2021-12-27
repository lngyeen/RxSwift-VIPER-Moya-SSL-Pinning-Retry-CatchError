//
//  CocktailErrorResponse.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Alamofire
import RxSwift
import Moya

struct CocktailErrorResponse: APIErrorResponse {
    let status: Int
    let error: String
    
    var title: String { return "Error" }
    
    var headers: HTTPHeaders? { return nil }
    
    var message: String { return error }
    
    var code: Int { return status }
}
