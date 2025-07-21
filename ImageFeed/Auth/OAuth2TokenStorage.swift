import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "bearerToken"
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: tokenKey)
            } else {
                userDefaults.removeObject(forKey: tokenKey)
            }
        }
    }
}
