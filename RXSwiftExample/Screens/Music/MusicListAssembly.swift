//
//  MusicListAssembly.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation

class MusicListAssembly: Assembly {
    init() {}

    func build() -> MusicListViewController {
        let controller = MusicListViewController()
        let router = MusicListRouterImpl()
        let interactor = MusicListInteractorImpl(service: MusicServiceImpl())
        let presenterDependencies = MusicListPresenterDependencies(interactor: interactor,
                                                                   router: router)
        let presenter = MusicListPresenterImpl(dependencies: presenterDependencies)
        controller.presenter = presenter
        return controller
    }
}
