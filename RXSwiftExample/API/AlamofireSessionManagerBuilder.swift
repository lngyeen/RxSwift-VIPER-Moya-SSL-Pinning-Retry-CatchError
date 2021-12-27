//
//  AlamofireSessionManagerBuilder.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Alamofire
import Foundation

class AlamofireSessionManagerBuilder {
    var policies: [String: ServerTrustEvaluating]?
    var configuration = URLSessionConfiguration.default

    // 1 - Builder initializer
    init() {
        var allowsArbitraryLoads: Bool = true

        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let transportSecurity = NSDictionary(contentsOfFile: path)?["NSAppTransportSecurity"] as? [String: Any],
           let arbitraryLoads = transportSecurity["NSAllowsArbitraryLoads"] as? Bool
        {
            allowsArbitraryLoads = arbitraryLoads
        }

        // If we have a certificate and the APS does not allows arbitrary loads, then we enable the certificate pinning using the trustPolicyManager
        if case .some = Environment.Certificates.bundle, !allowsArbitraryLoads {
            policies = [
                Environment.baseHost(): PublicKeysTrustEvaluator(
                    performDefaultValidation: true,
                    validateHost: true)
            ]
        }
    }

    // 2 - Configures alamofire's session manager
    // to increase timeout interval, useful for upload requests.
    func prepareForFileUpload() -> Self {
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        return self
    }

    // 3 - Session manager creator
    func build() -> Alamofire.Session {
        var serverTrustPolicyManager: ServerTrustManager?
        if let policies = policies {
            serverTrustPolicyManager = ServerTrustManager(evaluators: policies)
        }

        let manager = Alamofire.Session(configuration: configuration,
                                        serverTrustManager: serverTrustPolicyManager)
        return manager
    }
}
