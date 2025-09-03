import UIKit

enum Constants {
    static let accessKey = "qzoF4exRpYsXJxjaBgLJFbbJY7Jo2KTdALw9KL2S3h8"
    static let secretKey = "uoTrWlY9oJZM-92j1SsI_F1cp4wjb1ugUSEzxoSkRx0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     authURLString: Constants.unsplashAuthorizeURLString,
                                     defaultBaseURL: Constants.defaultBaseURL)
        }
}

// Второй акк для запросов
//enum Constants {
//    static let accessKey = "aiJCy-QT8b97cRhn-wvKHdCxM5RIfEv8Owg95Uk2S40"
//    static let secretKey = "GBhkbuu5X1JKpKZ1LzZnZ-F7KHUBQpxcZZ4m2T-Hs2c"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    static let accessScope = "public+read_user+write_likes"
//    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
//    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//}
