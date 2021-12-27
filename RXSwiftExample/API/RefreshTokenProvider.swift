//
//  RefreshTokenProvider.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/27/21.
//

import Foundation
import Alamofire
import Moya
import RxSwift

/*
final class CustomMoyaProvider<Target> where Target: Moya.TargetType {
    
    private let provider: MoyaProvider<Target>
    private let preferencesHelper: PreferencesHelper
    
    init(preferencesHelper: PreferencesHelper,
         endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Alamofire.Session = AlamofireSessionManagerBuilder().build(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        
        //self.preferencesHelper = preferencesHelper
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Single<Moya.Response> {
        let request = provider.rx.request(token)
        return request
            .flatMap { response in
                if response.statusCode == 401 {
                    let oldCredentials = self.preferencesHelper.credentials!
                    return self.refreshSessionToken(oldCredentials: oldCredentials)
                        .do(onNext: {
                            self.preferencesHelper.credentials = Credentials(accessToken: $0.accessToken,
                                                                                       
                                                                             tokenType: $0.tokenType,
                                                                                       
                                                                             idToken: $0.idToken,
                                                                                       
                                                                             refreshToken: oldCredentials.refreshToken,
                                                                                       
                                                                             expiresIn: $0.expiresIn,
                                                                                       
                                                                             scope: oldCredentials.scope) })
                            .flatMap { _ in return self.request(token) }
                } else {
                    return Single.just(response)
                }
            }
            .filterSuccessfulStatusCodes()
    }
    
    private func refreshSessionToken(oldCredentials: Credentials) -> Single<Auth0.Credentials> {
        return Single.create { subscriber in
            Auth0.authentication(clientId: "MY_CLIENT_ID", domain: "MY_DOMAIN")
                .renew(withRefreshToken: oldCredentials.refreshToken!, scope: oldCredentials.scope)
                .start { result in
                    switch result {
                    case .success(let credentials):
                        subscriber(.success(credentials))
                    case .failure(let error):
                        subscriber(.error(error))
                    }
                }
            return Disposables.create()
        }
    }
}
*/
