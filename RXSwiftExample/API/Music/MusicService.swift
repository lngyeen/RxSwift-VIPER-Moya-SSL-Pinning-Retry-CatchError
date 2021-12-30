//
//  MusicServiceImpl.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import Moya
import RxSwift
import RxSwiftExt

protocol MusicService {
    func fetchMusics(page: Int) -> Single<[Music]>
    func likeMusic(_ music: Music, like: Bool) -> Single<Music>
}

class MusicServiceImpl: BaseService, MusicService {
    private static let musicProvider = MoyaProvider<MucisEndpoint>(
        session: AlamofireSessionManagerBuilder().build(),
        plugins: [
            NetworkLoggerPlugin(configuration: .init(formatter: .init(),
                                                     logOptions: .verbose)
            ),
        ]
    )

    var provider: MoyaProvider<MucisEndpoint> {
        return MusicServiceImpl.musicProvider
    }

    func fetchMusics(page: Int) -> Single<[Music]> {
        return provider
            .rx
            .request(.mostPlayed(page: page))
            .catchError(MusicErrorResponse.self)
            .map(FeedResults.self)
            .map { $0.feed.results }
    }
    
    func likeMusic(_ music: Music, like: Bool) -> Single<Music> {
        return Single.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                var music = music
                music.isLiked = like
                single(.success(music))
            })
            return Disposables.create()
        }
    }
}
