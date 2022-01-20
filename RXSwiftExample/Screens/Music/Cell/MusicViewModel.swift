//
//  MusicViewModel.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/29/21.
//

import Action
import Foundation
import RxSwift

struct MusicViewModelDependencies {
    let interactor: MusicListInteractor
}

protocol MusicViewModelInputs {
    var likeButtonTrigger: PublishSubject<Bool> { get }
}

protocol MusicViewModelOutputs {
    var error: Observable<Error> { get }
}

protocol MusicViewModel {
    var dependencies: MusicViewModelDependencies { get }
    var inputs: MusicViewModelInputs { get }
    var outputs: MusicViewModelOutputs { get }
    var lastLikeStatus: Bool { get }
    var music: Music { get }
    var id: String { get }
    var name: String { get }
    var artworkUrl100: String { get }
    var artistName: String { get }
}

class MusicViewModelImpl: MusicViewModel, MusicViewModelInputs, MusicViewModelOutputs {
    var inputs: MusicViewModelInputs { return self }
    var outputs: MusicViewModelOutputs { return self }
    let dependencies: MusicViewModelDependencies

    private lazy var likeMusicAction: Action<(Music, Bool), Music> = {
        Action { likeMusic in
            self.dependencies.interactor.likeMusic(likeMusic.0, like: likeMusic.1)
        }
    }()

    // MARK: - Inputs

    let likeButtonTrigger = PublishSubject<Bool>()

    // MARK: - Outputs

    var error: Observable<Error> {
        likeMusicAction.underlyingError
    }

    // MARK: - Properties

    let disposeBag = DisposeBag()

    var lastLikeStatus: Bool = false
    var id: String { music.id }
    var name: String { music.name }
    var artworkUrl100: String { music.artworkUrl100 }
    var artistName: String { music.artistName }

    // MARK: - Private properties

    private(set) var music: Music
    private let musicUpdatedPublishSubject = PublishSubject<MusicViewModel>()
    private let likePublishSubject = PublishSubject<Bool>()
    private var likeTrigger: Observable<Bool> { return likePublishSubject.asObserver() }

    init(music: Music, dependencies: MusicViewModelDependencies) {
        self.music = music
        self.dependencies = dependencies
        lastLikeStatus = music.isLiked

        likeButtonTrigger
            .do(onNext: { [weak self] isLiked in self?.lastLikeStatus = isLiked })
            .debounce(RxTimeInterval.milliseconds(40),
                      scheduler: MainScheduler.instance)
            .filter { [weak self] isLiked in
                isLiked != self?.music.isLiked
            }
            .map { isLiked in
                (self.music, isLiked)
            }
            .bind(to: likeMusicAction.inputs)
            .disposed(by: disposeBag)

        likeMusicAction.elements
            .subscribe(onError: { _ in
                self.updateMusic(self.music)
            })
            .disposed(by: disposeBag)
    }

    func updateMusic(_ music: Music) {
        self.music = music
        lastLikeStatus = music.isLiked
        musicUpdatedPublishSubject.onNext(self)
    }
}
