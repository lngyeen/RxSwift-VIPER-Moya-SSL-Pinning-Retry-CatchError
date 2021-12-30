//
//  MusicListInteractor.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import Foundation
import RxSwift

protocol MusicListInteractor {
    func fetchMusicsAtPage(_ page: Int) -> Observable<[Music]>
    func likeMusic(_ music: Music, like: Bool) -> Observable<Music>
}

class MusicListInteractorImpl: MusicListInteractor {
    private let service: MusicService
    init(service: MusicService) {
        self.service = service
    }

    func fetchMusicsAtPage(_ page: Int) -> Observable<[Music]> {
        return service.fetchMusics(page: page)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }

    func likeMusic(_ music: Music, like: Bool) -> Observable<Music> {
        return service.likeMusic(music, like: like)
            .asObservable()
            .retry(.exponentialDelayed(maxCount: 3, initial: 2.0, multiplier: 1.0),
                   scheduler: MainScheduler.instance)
    }
}
