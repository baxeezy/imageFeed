import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showLogoutConfirmationCalled = false
        
    func configure(with presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateProfileDetails(name: String, nickname: String, description: String) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(with url: URL?) {
        updateAvatarCalled = true
    }
    
    func showLogoutConfirmation() {
        showLogoutConfirmationCalled = true
    }
}
