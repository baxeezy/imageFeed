import UIKit

final class AuthViewController: UIViewController {
    
    @IBOutlet weak private var logoView: UIView!
    @IBAction private func didTapLogoButton() {
    }
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()

    }
    
   private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "tap_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "tap_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named :"YP Black")
    }
}
