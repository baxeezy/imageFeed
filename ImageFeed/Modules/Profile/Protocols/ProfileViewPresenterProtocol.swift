import UIKit

public protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func didReceiveProfileUpdate(profile: Profile)
    func didReceiveAvatarUpdate(avatarURL: String?)
}
