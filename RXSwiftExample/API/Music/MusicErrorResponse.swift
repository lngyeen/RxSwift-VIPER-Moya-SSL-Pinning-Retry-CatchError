//
//  MusicErrorResponse.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/24/21.
//

import Alamofire
import Foundation
import Moya
import RxSwift

struct MusicErrorResponse: APIErrorResponse {
    let status: Int
    let error: String

    var title: String { return "Error" }

    var headers: HTTPHeaders? { return nil }

    var message: String { return error }

    var code: Int { return status }
}
