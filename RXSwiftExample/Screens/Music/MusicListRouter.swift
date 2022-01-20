//
//  MusicListRouter.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import RxFlow
import RxRelay
import RxSwift
import UIKit

protocol MusicListRouter: Stepper {
    var showMusicDetailTrigger: PublishSubject<MusicViewModel> { get }
}

class MusicListRouterImpl: MusicListRouter {
    // MARK: - Stepper conformances
    let steps = PublishRelay<Step>()
    
    // MARK: - Router trigger
    let showMusicDetailTrigger = PublishSubject<MusicViewModel>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        showMusicDetailTrigger
            .map { MainSteps.musicDetailIsRequired(music: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}
