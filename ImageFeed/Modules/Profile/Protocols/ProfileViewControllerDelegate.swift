import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func profileViewControllerDidLogout(_ vc: ProfileViewController)
}
