//
//  MusicListPresenter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

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
    var inputs: MusicListPresenterInputs { get }
    var outputs: MusicListPresenterOutputs { get }
}

class MusicListPresenterImpl: MusicListPresenter, MusicListPresenterInputs, MusicListPresenterOutputs {
    var inputs: MusicListPresenterInputs { return self }
    var outputs: MusicListPresenterOutputs { return self }

    // MARK: - Inputs

    let refreshTrigger = PublishSubject<Void>()
    let loadMoreTrigger = PublishSubject<Void>()
    let showMusicDetailTrigger = PublishSubject<MusicViewModel>()
    let searchTrigger = PublishSubject<String>()

    // MARK: - Outputs

    var musics: Observable<[MusicViewModel]> { musicsBehaviorRelay.asObservable() }
    var isLoading: Observable<Bool> { isLoadingPublishSubject.asObservable() }
    var error: Observable<Error> { errorPublishSubject.asObservable() }

    // MARK: - Private properties

    private let dependencies: MusicListPresenterDependencies
    private let disposeBag = DisposeBag()
    private var allMusics: [MusicViewModel] = []
    private var currentPage: Int = 0
    private let musicsBehaviorRelay: BehaviorRelay<[MusicViewModel]> = BehaviorRelay(value: [])
    private let isLoadingPublishSubject = PublishSubject<Bool>()
    private let errorPublishSubject = PublishSubject<Error>()

    init(dependencies: MusicListPresenterDependencies) {
        self.dependencies = dependencies
        bindingInputs()
    }

    // MARK: - Private methods

    private func bindingInputs() {
        // refresh trigger
        inputs
            .refreshTrigger
            .startLoading(isLoadingPublishSubject)
            .flatMap { [dependencies] in
                dependencies.interactor.fetchMusicsAtPage(self.currentPage).materialize()
            }
            .stopLoading(isLoadingPublishSubject)
            .subscribe(onNext: { [weak self] materializedEvent in
                self?.processMusicsEvent(materializedEvent, isRefresing: true)
            }).disposed(by: disposeBag)

        // loadMore trigger
        inputs
            .loadMoreTrigger
            .withLatestFrom(isLoadingPublishSubject)
            .filter { !$0 }
            .withLatestFrom(inputs.searchTrigger)
            .filter { $0.isEmpty }
            .startLoading(isLoadingPublishSubject)
            .flatMap { [dependencies] _ -> Observable<Event<[Music]>> in
                self.currentPage += 1
                return dependencies.interactor.fetchMusicsAtPage(self.currentPage).materialize()
            }
            .stopLoading(isLoadingPublishSubject)
            .subscribe(onNext: { [weak self] materializedEvent in
                self?.processMusicsEvent(materializedEvent, isRefresing: false)
            }).disposed(by: disposeBag)

        // showMusicDetail trigger
        inputs
            .showMusicDetailTrigger
            .subscribe { [dependencies] (music: MusicViewModel) in
                dependencies.router.showMusicDetail(music)
            }.disposed(by: disposeBag)

        // search trigger
        inputs
            .searchTrigger
            .subscribe { (search: String) in
                self.filterMusics(search)
            }.disposed(by: disposeBag)
    }

    private func processMusicsEvent(_ event: Event<[Music]>, isRefresing: Bool = false) {
        switch event {
        case let .next(newMusics):
            let newViewModels = newMusics.map { MusicViewModel(music: $0) }
            setupLikeTriggers(newViewModels)
            if isRefresing {
                allMusics = newViewModels
            } else {
                allMusics += newViewModels
            }
            musicsBehaviorRelay.accept(allMusics)

        case let .error(error):
            errorPublishSubject.onNext(error)

        default: break
        }
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
            let music = musicViewModel.music
            musicViewModel
                .outputs
                .likeTrigger
                .filter { isLiked in isLiked != music.isLiked }
                .map { [dependencies] _ in
                    dependencies.interactor.likeMusic(musicViewModel.music).materialize()
                }
                .switchLatest()
                .subscribe(onNext: { [weak musicViewModel] materializedEvent in

                    switch materializedEvent {
                    case let .next(newMusic):
                        if music.isLiked != newMusic.isLiked {
                            musicViewModel?.updateMusic(newMusic)
                        }

                    case let .error(error):
                        self.errorPublishSubject.onNext(error)

                    default: break
                    }
                }).disposed(by: musicViewModel.disposeBag)
        }
    }
}
