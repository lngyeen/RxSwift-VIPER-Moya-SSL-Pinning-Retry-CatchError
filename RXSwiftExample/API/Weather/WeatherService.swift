//
//  WeatherServiceImpl.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import Moya
import RxSwift
import CoreLocation

protocol WeatherService {
    func fetchWeatherFor(city: String) -> Single<Weather>
    func fetchWeatherFor(lat: String, lon: String) -> Single<Weather>
}

class WeatherServiceImpl: BaseService, WeatherService {
    private static let musicProvider = MoyaProvider<WeatherEndpoint>(
        session: AlamofireSessionManagerBuilder().build(),
        plugins: [
            NetworkLoggerPlugin(configuration: .init(formatter: .init(),
                                                     logOptions: .verbose)
                               ),
        ]
    )
    
    var provider: MoyaProvider<WeatherEndpoint> {
        return WeatherServiceImpl.musicProvider
    }
    
    func fetchWeatherFor(city: String) -> Single<Weather> {
        return provider
            .rx
            .request(.weather(city: city))
            .catchError(WeatherErrorResponse.self)
            .map(Weather.self)
    }
    
    func fetchWeatherFor(lat: String, lon: String) -> Single<Weather> {
        return provider
            .rx
            .request(.weatherViaCoordinate(lat: lat, lon: lon))
            .catchError(WeatherErrorResponse.self)
            .map(Weather.self)
    }
}
