import UIKit
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
      cleanCookies()
       cleanToken()
       cleanProfileData()
       cleanImagesData()
       switchToSplashScreen()
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
    
    private func cleanToken() {
        OAuth2TokenStorage.shared.token = nil
    }
    
    private func cleanProfileData() {
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanAvatarURL()
    }
    
    private func cleanImagesData() {
        ImagesListService.shared.cleanPhotos()
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Не смогли найти window")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
    
