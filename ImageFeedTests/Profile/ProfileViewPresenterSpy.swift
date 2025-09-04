import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var didReceiveProfileUpdateCalled = false
    var didReceiveAvatarUpdateCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func didReceiveProfileUpdate(profile: ImageFeed.Profile) {
        didReceiveProfileUpdateCalled = true
    }
    
    func didReceiveAvatarUpdate(avatarURL: String?) {
        didReceiveAvatarUpdateCalled = true
    }
    
}
