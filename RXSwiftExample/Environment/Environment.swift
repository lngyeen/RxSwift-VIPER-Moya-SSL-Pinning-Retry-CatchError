//
//  Environment.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/23/21.
//

import Foundation

struct Environment {
    enum Server: String {
        case custom, mock, dev, test, prod
        init(_ value: String?) {
            self = Server(rawValue: value ?? "") ?? .dev
        }
    }
    
    static var server: Server {
#if DEBUG
        return Server("dev") // Server(SettingsBundleHelper.Value.environmentValue)
#elseif RELEASE
        return .prod
#endif
        return .dev
    }
    
    static func baseHost(_ service: BaseEndpoint? = nil) -> String {
        guard let service = service else {
            return ""
        }
        switch service.category {
        case .music: return "rss.applemarketingtools.com"
        case .cocktail: return "www.thecocktaildb.com"
        case .weather: return "api.openweathermap.org"
        }
    }
    
//    static func basePath(_ service: BaseEndpoint? = nil) -> String {
//        return "/api/v2/us/music"
//    }
    
    static func urlScheme(_ service: BaseEndpoint) -> String? {
        switch (Environment.server, service) {
        case (.mock, _): return "http"
        default: return "https"
        }
    }
    
    static func baseUrl(_ service: BaseEndpoint) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Environment.urlScheme(service)
        urlComponents.host = Environment.baseHost(service)
//        urlComponents.path = Environment.basePath(service)
        return urlComponents.url!
    }
    
    /**
     *  The Certificates structure wrap the information used for the certificates like the certificate bundle
     */
    
    public enum Certificates {
        fileprivate static var bundleName: String? {
            switch Environment.server {
            // TODO: Handle certificate bundle name
            default: return nil
            }
        }
        
        /// The NSBundle that hold the certificate for the current build configuration
        public static var bundle: Foundation.Bundle? {
            let mainBundle = Foundation.Bundle.main
            
            if let bundleName = Certificates.bundleName {
                if let certBundlePath = mainBundle.path(forResource: bundleName, ofType: "bundle"),
                   let bundle = Foundation.Bundle(path: certBundlePath)
                {
                    return bundle
                } else {
                    fatalError("Could not load certificates")
                }
            } else {
                return nil
            }
        }
    }
}
