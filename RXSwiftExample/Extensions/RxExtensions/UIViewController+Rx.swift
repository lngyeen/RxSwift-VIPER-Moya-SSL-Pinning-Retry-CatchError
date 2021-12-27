//
//  Reactive+Extensions.swift
//  Cathay
//
//  Created by Steve on 11/20/19.
//  Copyright © 2019 Steve. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

extension Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in return }
    }
    
    public var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in return }
    }
    
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var errorAlert: Binder<Error> {
        return Binder<Error>.init(base.self, scheduler: MainScheduler.instance) { viewController, error in
            if let apiPresentableError = error as? ApiPresentableError {
                viewController.showAlert(title: apiPresentableError.title,
                                         message: "\(String(describing: apiPresentableError.code)) - \(apiPresentableError.message)")
            } else {
                viewController.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension Observable where Element: Any {
    func startLoading(_ loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: {_ in loadingSubject.onNext(true)})
    }
    
    func stopLoading(_ loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: {_ in loadingSubject.onNext(false)})
    }
}
