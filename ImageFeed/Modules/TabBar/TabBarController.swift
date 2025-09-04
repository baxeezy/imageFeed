import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    private func setupViewControllers() {
        viewControllers = [createImagesListVC(), createProfileVC()]
    }
    
    private func setupTabBarAppearance() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .ypBlack
            
            appearance.stackedLayoutAppearance.normal.iconColor = .ypGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ypGray]
            
            appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.ypWhite]
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
            
            tabBar.tintColor = .ypWhite
            tabBar.unselectedItemTintColor = .ypGray
            tabBar.isTranslucent = false
        }
    
    private func createImagesListVC() -> UIViewController {
        let imagesListViewController = ImagesListViewController()
        let presenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        let navigationController = UINavigationController(rootViewController: imagesListViewController)
        navigationController.navigationBar.isHidden = true
        
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        return navigationController
    }
    
    private func createProfileVC() -> UIViewController {
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenter()
        profileViewController.configure(with: presenter)
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.navigationBar.isHidden = true
        
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        return navigationController
    }
}
