//
//  WeatherEndpoint.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Moya


enum WeatherEndpoint {
    case weather(city: String)
    case weatherViaCoordinate(lat: String, lon: String)
}

extension WeatherEndpoint: BaseEndpoint {
    static var apiKey: String { "7eb16ba618149430d18b705dc46d179a" }
    
    var category: EndpointCategory {
        return .weather
    }
    
    var path: String {
        return "/data/2.5/weather"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case .weather(let city):
            var parameters = [String: Any]()
            parameters["appid"] = WeatherEndpoint.apiKey
            parameters["units"] = "metric"
            parameters["q"] = city
            return Task.requestParameters(
                parameters: parameters,
                encoding: parameterEncoding
            )
        case .weatherViaCoordinate(let lat, let lon):
            var parameters = [String: Any]()
            parameters["appid"] = WeatherEndpoint.apiKey
            parameters["units"] = "metric"
            parameters["lat"] = lat
            parameters["lon"] = lon
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

