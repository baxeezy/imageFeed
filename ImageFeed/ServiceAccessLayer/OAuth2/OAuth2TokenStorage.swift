import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let tokenKey = "token"
    private let isFirstLaunchKey = "isFirstLaunch"
    
    
    var token: String? {
        get {
            if UserDefaults.standard.bool(forKey: isFirstLaunchKey) == false {
                UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                return nil
            }
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
