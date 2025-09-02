import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    private func setupViewControllers() {
        viewControllers = [createImagesListVC(), createProfileVC()]
    }
    
    private func createImagesListVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            return UIViewController()
        }
        
        let presenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        return imagesListViewController
    }
    
    private func createProfileVC() -> UIViewController {
        let profileViewController = ProfileViewController()
        
        let presenter = ProfilePresenter()
        profileViewController.configure(with: presenter)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        return profileViewController
    }
}
