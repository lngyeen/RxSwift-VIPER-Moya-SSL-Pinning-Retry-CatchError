//
//  AppSteps.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation
import RxFlow

enum MainSteps: Step {
    case homeScreenIsRequired
    case registerScreenIsRequired
    case changAvatarScreenIsRequired(onSelect: (UIImage?) -> Void)
    case allMusicIsRequired
    case musicDetailIsRequired(music: MusicViewModel)
    case cocktailCategoriesIsRequired
    case cocktailCategorieDetailIsRequired(category: CocktailCategory)
    case weatherCityIsRequired
}
