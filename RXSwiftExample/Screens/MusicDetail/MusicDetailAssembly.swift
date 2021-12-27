//
//  MusicDetailAssembly.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import UIKit

protocol Assembly {
    associatedtype T: UIViewController

    func build() -> T
}

class MusicDetailAssembly: Assembly {
    let music: MusicViewModel
    init(music: MusicViewModel) {
        self.music = music
    }

    func build() -> MusicDetailViewController {
        let controller = MusicDetailViewController()
        let presenter = MusicDetailPresenterImpl(music: music)
        controller.presenter = presenter
        return controller
    }
}
