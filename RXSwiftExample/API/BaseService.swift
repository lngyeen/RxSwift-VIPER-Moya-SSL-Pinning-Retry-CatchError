//
//  BaseService.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation
import Moya

protocol BaseService {
    associatedtype T: BaseEndpoint
    var provider: MoyaProvider<T> { get }
}
