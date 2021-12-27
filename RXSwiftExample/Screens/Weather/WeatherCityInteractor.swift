//
//  WeatherCityInteractor.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import RxSwift

protocol WeatherCityInteractor {
    func fetchWeatherFor(city: String) -> Observable<Weather>
    func fetchWeatherFor(lat: String, lon: String) -> Observable<Weather>
}

class WeatherCityInteractorImpl: WeatherCityInteractor {
    private let service: WeatherService
    init(service: WeatherService) {
        self.service = service
    }

    func fetchWeatherFor(city: String) -> Observable<Weather> {
        return service.fetchWeatherFor(city: city)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }

    func fetchWeatherFor(lat: String, lon: String) -> Observable<Weather> {
        return service.fetchWeatherFor(lat: lat, lon: lon)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }
}
