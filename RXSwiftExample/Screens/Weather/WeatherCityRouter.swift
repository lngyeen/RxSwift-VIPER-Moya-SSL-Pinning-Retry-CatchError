//
//  WeatherCityRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit

protocol WeatherCityRouter {
    var viewController: WeatherCityViewController? { get }
}

class WeatherCityRouterImpl: WeatherCityRouter {
    weak var viewController: WeatherCityViewController?

    init(viewController: WeatherCityViewController) {
        self.viewController = viewController
    }
}
