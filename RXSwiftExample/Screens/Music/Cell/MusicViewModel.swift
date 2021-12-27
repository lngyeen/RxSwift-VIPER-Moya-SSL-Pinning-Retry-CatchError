//
//  MusicViewModel.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/29/21.
//

import Foundation
import RxSwift

protocol MusicViewModelInputs {
    var likeButtonTrigger: PublishSubject<Bool> { get }
}

protocol MusicViewModelOutputs {
    var likeTrigger: Observable<Bool> { get }
    var musicUpdatedTrigger: Observable<MusicViewModel> { get }
}

class MusicViewModel: MusicViewModelInputs, MusicViewModelOutputs {
    var inputs: MusicViewModelInputs { return self }
    var outputs: MusicViewModelOutputs { return self }

    // MARK: - Inputs

    let likeButtonTrigger = PublishSubject<Bool>()
    
    // MARK: - Outputs
    
    var likeTrigger: Observable<Bool> { return  likePublishSubject.asObserver() }
    var musicUpdatedTrigger: Observable<MusicViewModel> { return musicUpdatedPublishSubject.asObservable() }

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
    
    init(music: Music) {
        self.music = music
        lastLikeStatus = music.isLiked
        likeButtonTrigger
            .do(onNext: { [weak self] _ in self?.lastLikeStatus.toggle() })
            .debounce(RxTimeInterval.milliseconds(400),
                      scheduler: MainScheduler.instance)
            .bind(to: likePublishSubject)
            .disposed(by: disposeBag)
    }

    func updateMusic(_ music: Music) {
        self.music = music
        lastLikeStatus = music.isLiked
        musicUpdatedPublishSubject.onNext(self)
    }
}
