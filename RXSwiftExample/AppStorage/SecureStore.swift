//
//  Keychain.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 1/4/22.
//

import Foundation
import KeychainAccess

class SecureStore {
    enum Key: String {
        case email
        case password
        case accessTokenAPI_A
        case accessTokenAPI_B
        case refreshToken
    }

    private static var mainKeychainIdentifier = Bundle.main.bundleIdentifier!
    static var main = Keychain(service: SecureStore.mainKeychainIdentifier)
}

extension Keychain {
    
    subscript(key: SecureStore.Key) -> String? {
        get {
            return self[key.rawValue]
        } set {
            self[key.rawValue] = newValue
        }
    }

    subscript(string key: SecureStore.Key) -> String? {
        get {
            return self[key.rawValue]
        } set {
            self[key.rawValue] = newValue
        }
    }

    subscript(key: SecureStore.Key) -> Data? {
        get {
            return self[data: key.rawValue]
        } set {
            self[data: key.rawValue] = newValue
        }
    }

    subscript(attributes key: SecureStore.Key) -> Attributes? {
        return self[attributes: key.rawValue]
    }

    subscript(key: SecureStore.Key) -> Bool? {
        get {
            switch self[key.rawValue] {
            case .some("YES"): return true
            case .some("NO"): return false
            default: return nil
            }
        } set {
            switch newValue {
            case .some(true): self[key.rawValue] = "YES"
            case .some(false): self[key.rawValue] = "NO"
            case .none: do { try remove(key.rawValue) } catch {}
            }
        }
    }

    subscript(bool key: SecureStore.Key) -> Bool? {
        get {
            return self[key]
        } set {
            self[key] = newValue
        }
    }
}
