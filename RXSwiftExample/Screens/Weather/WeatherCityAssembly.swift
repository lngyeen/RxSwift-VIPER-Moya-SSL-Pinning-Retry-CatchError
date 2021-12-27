//
//  WeatherCityAssembly.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation

class WeatherCityAssembly: Assembly {
    init() {}

    func build() -> WeatherCityViewController {
        let controller = WeatherCityViewController()
        let router = WeatherCityRouterImpl(viewController: controller)
        let interactor = WeatherCityInteractorImpl(service: WeatherServiceImpl())
        let dependencies = WeatherCityPresenterDependencies(router: router, interactor: interactor)
        let presenter = WeatherCityPresenterImpl(dependencies: dependencies)
        controller.presenter = presenter
        return controller
    }
}
