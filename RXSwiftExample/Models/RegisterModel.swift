//
//  RegisterModel.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation
import RxSwift

enum ApiError: Error, CustomStringConvertible {
    case error(String)
    case errorURL
    
    var description: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

final class RegisterModel {
    private static var sharedRegisterModel: RegisterModel = {
        let sharedRegisterModel = RegisterModel()
        return sharedRegisterModel
    }()
    
    class func shared() -> RegisterModel {
        return sharedRegisterModel
    }
    
    private init() { }
    
    func register(username: String?, password: String?, email: String?, avatar: UIImage?) -> Single<Bool> {
       return Single.create { single in
           if let username = username {
               if username == "" {
                   single(.error(ApiError.error("Username is empty")))
               }
           } else {
               single(.error(ApiError.error("Username is nil")))
           }
           
           if let password = password {
               if password == "" {
                   single(.error(ApiError.error("Password is empty")))
               }
           } else {
               single(.error(ApiError.error("Password is nil")))
           }
           
           if let email = email {
               if email == "" {
                   single(.error(ApiError.error("Email is empty")))
               }
           } else {
               single(.error(ApiError.error("Email is nil")))
           }
           
           if avatar == nil {
               single(.error(ApiError.error("avatar is empty")))
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               single(.success(true))
           }
           
           return Disposables.create()
        }
    }
}
