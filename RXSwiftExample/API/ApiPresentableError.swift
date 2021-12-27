//
//  ApiPresentableError.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import Alamofire
import Moya
import RxSwift

typealias NetworkCompletion<T> = ((Result<T, ApiPresentableError>) -> ())

protocol APIErrorResponse: Codable {
    var title: String { get }
    var message: String { get }
    var headers: HTTPHeaders? { get }
    var code: Int { get }
}

class ApiPresentableError: Error {
    private(set) public var title: String
    private(set) public var message: String
    private(set) public var code: Int?
    
    convenience init() {
        self.init(title: "Error!",
                  message: "Oops! Something went wrong!\nHelp us improve your experience by sending an error report.")
    }
    
    convenience init(code: Int? = nil) {
        self.init(title: "Error!", message: "Oops! Something went wrong", code: code)
    }
    
    init(title: String,
                message: String,
                code: Int? = nil) {
        self.message = message
        self.title = title
        self.code = code
    }
    
    init(error: APIErrorResponse) {
        self.title = error.title
        self.message = error.message
        self.code = error.code
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func catchError<T: APIErrorResponse>(_ type: T.Type) -> Single<Element> {
        return flatMap { (response) -> Single<Element> in
            guard 200 ... 299 ~= response.statusCode else {
                do {
                    let errorResponse = try response.map(T.self)
                    throw ApiPresentableError(error: errorResponse)
                } catch {
                    throw error
                }
            }
            return .just(response)
        }
    }
}
