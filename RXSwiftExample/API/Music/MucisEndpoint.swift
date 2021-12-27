//
//  MucisEndpoint.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import Moya

enum MucisEndpoint {
    case mostPlayed(page: Int)
}

extension MucisEndpoint: BaseEndpoint {
    var category: EndpointCategory {
        return .music
    }
    
    var path: String {
        switch self {
        case .mostPlayed:
            return "/api/v2/us/music/most-played/50/albums.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .mostPlayed:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .mostPlayed(let page):
            var parameters = [String: Any]()
            parameters["page"] = page
            return Task.requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
        }
    }

    var sampleData: Data {
        return Data()
    }
}
