//
//  WeatherCityPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import CoreLocation
import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxSwiftExt

struct WeatherCityPresenterDependencies {
    let router: WeatherCityRouter
    let interactor: WeatherCityInteractor
}

protocol WeatherCityPresenterInputs {
    var textSearchTrigger: PublishSubject<String> { get }
    var locationSearchTrigger: PublishSubject<CLLocationCoordinate2D> { get }
}

protocol WeatherCityPresenterOutputs {
    var weather: Observable<Weather> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}

protocol WeatherCityPresenter {
    var inputs: WeatherCityPresenterInputs { get }
    var outputs: WeatherCityPresenterOutputs { get }
}

class WeatherCityPresenterImpl: WeatherCityPresenter, WeatherCityPresenterInputs, WeatherCityPresenterOutputs {
    var inputs: WeatherCityPresenterInputs { return self }
    var outputs: WeatherCityPresenterOutputs { return self }
    
    // MARK: - Inputs
    
    let textSearchTrigger = PublishSubject<String>()
    let locationSearchTrigger = PublishSubject<CLLocationCoordinate2D>()
    
    // MARK: - Outputs
    
    var weather: Observable<Weather> { weatherBehaviorRelay.asObservable() }
    var isLoading: Observable<Bool> { isLoadingPublishSubject.asObservable() }
    var error: Observable<Error> { errorPublishSubject.asObservable() }
    
    private let dependencies: WeatherCityPresenterDependencies
    private let disposeBag = DisposeBag()
    private var currentPage: Int = 0
    private let weatherBehaviorRelay: BehaviorRelay<Weather> = BehaviorRelay(value: Weather.dummy)
    private var isLoadingPublishSubject = PublishSubject<Bool>()
    private let errorPublishSubject = PublishSubject<Error>()
    
    init(dependencies: WeatherCityPresenterDependencies) {
        self.dependencies = dependencies
        bindingInputs()
    }
    
    private func bindingInputs() {
        // textSearch trigger
        let searchViaCityName = inputs
            .textSearchTrigger.flatMap { [dependencies] cityName in
                dependencies.interactor.fetchWeatherFor(city: cityName)
                    .materialize()
            }
        
        // locationSearch trigger
        let searchViaLocation = inputs
            .locationSearchTrigger
            .flatMap { [dependencies] location in
                dependencies.interactor
                    .fetchWeatherFor(lat: "\(location.latitude)",
                                     lon: "\(location.longitude)")
                    .materialize()
            }
        
        // search trigger
        let search = Observable.merge(
            [
                searchViaCityName,
                searchViaLocation,
            ]
        )
        // Get result via side-effect
        .do(onNext: { [weak self] materializedEvent in
            switch materializedEvent {
            case let .next(weather):
                self?.processWeather(weather)
            case let .error(error):
                self?.errorPublishSubject.onNext(error)
            default: break
            }
        })
        
        // isLoading trigger
        Observable<Bool>.merge(
            [
                inputs.textSearchTrigger.map { _ in true },
                inputs.locationSearchTrigger.map { _ in true },
                search.map { _ in false },
            ]
        )
        .asObservable()
        // Start sequence
        .bind(to: isLoadingPublishSubject)
        .disposed(by: disposeBag)
    }
    
    private func processWeather(_ newWeather: Weather) {
        weatherBehaviorRelay.accept(newWeather)
    }
}
