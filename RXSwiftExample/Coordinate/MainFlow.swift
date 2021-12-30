//
//  MainFlow.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation
import RxFlow
import UIKit

class MainFlow: Flow {
    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }()
    
    // Flow conformances
    var root: Presentable {
        return navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps else { return .none }
        
        switch step {
        case .homeScreenIsRequired:
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
            
        case .registerScreenIsRequired:
            let viewController = RegisterViewController()
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNext: viewController))
            
        case .changAvatarScreenIsRequired(let onSelect):
            let viewController = ChangeAvatarViewController()
            navigationController.pushViewController(viewController, animated: true)
            viewController.selectedPhotos
                .subscribe(onNext: { img in
                    onSelect(img)
                })
                .disposed(by: viewController.disposeBag)
            return .none
            
        case .allMusicIsRequired:
            let viewController = MusicListAssembly().build()
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.presenter!.dependencies.router))
            
        case .musicDetailIsRequired(let music):
            let viewController = MusicDetailAssembly(music: music).build()
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNext: viewController))
            
        case .cocktailCategoriesIsRequired:
            let viewController = CocktailCategoriesAssembly().build()
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.presenter!.dependencies.router))
            
        case .cocktailCategorieDetailIsRequired(let category):
            let viewController = DrinkListAssembly(category: category).build()
            navigationController.pushViewController(viewController, animated: true)
            return .none
            
        case .weatherCityIsRequired:
            let viewController = WeatherCityAssembly().build()
            navigationController.pushViewController(viewController, animated: true)
            return .none
        }
    }
}
