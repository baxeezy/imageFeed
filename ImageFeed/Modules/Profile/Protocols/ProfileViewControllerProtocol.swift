import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(name: String, nickname: String, description: String)
    func updateAvatar(with url: URL?)
    func showLogoutConfirmation()
}
