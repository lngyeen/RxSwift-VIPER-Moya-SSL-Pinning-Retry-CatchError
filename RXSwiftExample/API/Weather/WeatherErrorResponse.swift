//
//  WeatherErrorResponse.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Alamofire
import RxSwift
import Moya

struct WeatherErrorResponse: Codable {
    var cod: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case cod
        case message
    }
}

extension WeatherErrorResponse: APIErrorResponse {
    var title: String { return "Error" }
    
    var headers: HTTPHeaders? { return nil }
    
    var code: Int { return Int(cod) ?? 404 }
}
