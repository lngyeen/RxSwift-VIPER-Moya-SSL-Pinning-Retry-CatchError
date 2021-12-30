//
//  MusicListPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Action
import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxSwiftExt

struct MusicListPresenterDependencies {
    let interactor: MusicListInteractor
    let router: MusicListRouter
}

protocol MusicListPresenterInputs {
    var refreshTrigger: PublishSubject<Void> { get }
    var loadMoreTrigger: PublishSubject<Void> { get }
    var showMusicDetailTrigger: PublishSubject<MusicViewModel> { get }
    var searchTrigger: PublishSubject<String> { get }
}

protocol MusicListPresenterOutputs {
    var musics: Observable<[MusicViewModel]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}

protocol MusicListPresenter {
    var dependencies: MusicListPresenterDependencies { get }
    var inputs: MusicListPresenterInputs { get }
    var outputs: MusicListPresenterOutputs { get }
}

class MusicListPresenterImpl: MusicListPresenter, MusicListPresenterInputs, MusicListPresenterOutputs {
    var inputs: MusicListPresenterInputs { return self }
    var outputs: MusicListPresenterOutputs { return self }
    let dependencies: MusicListPresenterDependencies

    // MARK: - Inputs

    let refreshTrigger = PublishSubject<Void>()
    let loadMoreTrigger = PublishSubject<Void>()
    let showMusicDetailTrigger = PublishSubject<MusicViewModel>()
    let searchTrigger = PublishSubject<String>()

    // MARK: - Outputs

    var musics: Observable<[MusicViewModel]> { musicsBehaviorRelay.asObservable() }

    var isLoading: Observable<Bool> {
        Observable.merge([
            loadMoreMusicsAction.executing,
            refreshMusicsAction.executing,
        ])
    }

    var error: Observable<Error> {
        Observable.merge([
            loadMoreMusicsAction.underlyingError,
            refreshMusicsAction.underlyingError,
            errorPublishSubject,
        ])
    }

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    private var allMusics: [MusicViewModel] = []
    private var currentPage: Int = 0
    private let musicsBehaviorRelay: BehaviorRelay<[MusicViewModel]> = BehaviorRelay(value: [])
    private let errorPublishSubject = PublishSubject<Error>()

    private lazy var loadMoreMusicsAction: Action<Int, [Music]> = {
        Action { page in
            self.dependencies.interactor.fetchMusicsAtPage(page)
        }
    }()

    private lazy var refreshMusicsAction: Action<Int, [Music]> = {
        Action { _ in
            self.dependencies.interactor.fetchMusicsAtPage(0)
        }
    }()

    init(dependencies: MusicListPresenterDependencies) {
        self.dependencies = dependencies
        bindingInputs()
    }

    // MARK: - Private methods

    private func bindingInputs() {
        // refresh trigger
        inputs
            .refreshTrigger
            .map { self.currentPage }
            .bind(to: refreshMusicsAction.inputs)
            .disposed(by: disposeBag)

        refreshMusicsAction.elements
            .subscribe(onNext: { [weak self] materializedEvent in
                self?.processMusics(materializedEvent, isRefresing: true)
            }).disposed(by: disposeBag)

        // loadMore trigger
        inputs
            .loadMoreTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(inputs.searchTrigger)
            .filter { $0.isEmpty }
            .map { _ -> Int in
                self.currentPage += 1
                return self.currentPage
            }
            .bind(to: loadMoreMusicsAction.inputs)
            .disposed(by: disposeBag)

        loadMoreMusicsAction.elements
            .subscribe(onNext: { [weak self] materializedEvent in
                self?.processMusics(materializedEvent, isRefresing: false)
            }).disposed(by: disposeBag)

        // showMusicDetail trigger
        inputs
            .showMusicDetailTrigger
            .bind(to: dependencies.router.showMusicDetailTrigger)
            .disposed(by: disposeBag)

        // search trigger
        inputs
            .searchTrigger
            .subscribe { (search: String) in
                self.filterMusics(search)
            }.disposed(by: disposeBag)
    }

    private func processMusics(_ newMusics: [Music], isRefresing: Bool = false) {
        let newViewModels = newMusics.map {
            MusicViewModelImpl(music: $0,
                               dependencies: MusicViewModelDependencies(interactor: dependencies.interactor))
        }
        setupLikeTriggers(newViewModels)
        if isRefresing {
            allMusics = newViewModels
        } else {
            allMusics += newViewModels
        }
        musicsBehaviorRelay.accept(allMusics)
    }

    private func filterMusics(_ search: String) {
        if search.isEmpty {
            musicsBehaviorRelay.accept(allMusics)
        } else {
            musicsBehaviorRelay.accept(allMusics.filter { $0.name.lowercased().contains(search.lowercased()) })
        }
    }

    private func setupLikeTriggers(_ newViewModels: [MusicViewModel]) {
        // like trigger
        for musicViewModel in newViewModels {
            musicViewModel
                .outputs
                .error
                .bind(to: errorPublishSubject)
                .disposed(by: disposeBag)
        }
    }
}
