//
//  UIView+Rx.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/26/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

extension Reactive where Base: UIView {
    public var isLoadingHUD: Binder<Bool> {
        return Binder<Bool>.init(base.self, scheduler: MainScheduler.instance) { view, isLoading in
            if isLoading {
                MBProgressHUD.showAdded(to: view, animated: true)
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }
}
