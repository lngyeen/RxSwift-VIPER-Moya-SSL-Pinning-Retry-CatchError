//
//  MusicListRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import UIKit

protocol MusicListRouter {
    var viewController: MusicListViewController? { get }
    func showMusicDetail(_ music: MusicViewModel)
}

class MusicListRouterImpl: MusicListRouter {
    weak var viewController: MusicListViewController?

    init(viewController: MusicListViewController) {
        self.viewController = viewController
    }

    func showMusicDetail(_ music: MusicViewModel) {
        let assembly = MusicDetailAssembly(music: music)
        viewController?.navigationController?.pushViewController(assembly.build(), animated: true)
    }
}
