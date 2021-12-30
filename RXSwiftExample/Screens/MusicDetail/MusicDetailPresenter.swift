//
//  MusicDetailPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

protocol MusicDetailPresenterInputs {}

protocol MusicDetailPresenterOutputs {
    var music: Observable<MusicViewModel> { get }
}

protocol MusicDetailPresenter {
    var inputs: MusicDetailPresenterInputs { get }
    var outputs: MusicDetailPresenterOutputs { get }
}

struct MusicDetailPresenterDependencies {
    let router: CocktailCategoriesRouterProtocol
    let interactor: CocktailCategoriesInteractor
}

class MusicDetailPresenterImpl: MusicDetailPresenter,
    MusicDetailPresenterInputs,
    MusicDetailPresenterOutputs
{
    var inputs: MusicDetailPresenterInputs { return self }
    var outputs: MusicDetailPresenterOutputs { return self }

    // MARK: - Outputs

    var music: Observable<MusicViewModel> { musicPublisher.asObservable() }

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    private var musicPublisher: BehaviorRelay<MusicViewModel>

    init(music: MusicViewModel) {
        self.musicPublisher = BehaviorRelay<MusicViewModel>(value: music)
    }
}
