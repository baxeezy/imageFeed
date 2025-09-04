import UIKit
import Kingfisher

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - UI Elements
    private var avatarImageView: UIImageView!
    private var profileName: UILabel!
    private var profileNickname: UILabel!
    private var profileDescription: UILabel!
    private var logoutButton: UIButton!
    
    // MARK: - Private Properties
    weak var delegate: ProfileViewControllerDelegate?
    var presenter: ProfileViewPresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Configuration Method
    func configure(with presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupConstraints()
        
        guard presenter != nil else {
            fatalError("❌ [ProfileViewController.viewDidLoad]: Неправильная настройка профиля")
        }
        presenter?.viewDidLoad()
    }
    
    // MARK: - ProfileViewControllerProtocol
    func updateProfileDetails(name: String, nickname: String, description: String) {
        profileName.text = name.isEmpty ? "Имя не указано" : name
        profileNickname.text = nickname.isEmpty ? "@неизвестный_пользователь" : nickname
        profileDescription.text = description.isEmpty ? "Профиль не заполнен" : description
    }
    
    func updateAvatar(with url: URL?) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        guard let url = url else {
            avatarImageView.image = placeholderImage
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }
    
    func showLogoutConfirmation() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alertController.view.accessibilityIdentifier = "Bye bye!"
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in }
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        yesAction.accessibilityIdentifier = "Yes"
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didTapLogoutButton() {
        presenter?.didTapLogoutButton()
    }
    // MARK: - Private Methods
    private func createUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        createAvatarImageView()
        createProfileName()
        createProfileNickname()
        createProfileDescription()
        createLogoutButton()
    }
    
    private func setupConstraints() {
        setupAvatarImageView()
        setupProfileName()
        setupProfileNickname()
        setupProfileDescription()
        setupLogoutButton()
    }
    
    private func createAvatarImageView() {
        let profileImage = UIImage(named: "userpick")
        avatarImageView = UIImageView(image: profileImage)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
    }
    
    private func setupAvatarImageView() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createProfileName() {
        let profileName = UILabel()
        view.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        
        profileName.text = "Екатерина Новикова"
        profileName.font = UIFont.boldSystemFont(ofSize: 23)
        profileName.textColor = UIColor(named: "YP White")
        self.profileName = profileName
    }
    
    private func setupProfileName() {
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func createProfileNickname() {
        let profileNickname = UILabel()
        view.addSubview(profileNickname)
        profileNickname.translatesAutoresizingMaskIntoConstraints = false
        
        profileNickname.text = "@ekaterina_nov"
        profileNickname.font = UIFont.systemFont(ofSize: 13)
        profileNickname.textColor = UIColor(named: "YP Gray")
        self.profileNickname = profileNickname
    }
    
    private func setupProfileNickname() {
        NSLayoutConstraint.activate([
            profileNickname.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileNickname.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func createProfileDescription() {
        let profileDescription = UILabel()
        view.addSubview(profileDescription)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        
        profileDescription.text = "Hello, world!"
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        profileDescription.textColor = UIColor(named: "YP White")
        self.profileDescription = profileDescription
    }
    
    private func setupProfileDescription() {
        NSLayoutConstraint.activate([
            profileDescription.topAnchor.constraint(equalTo: profileNickname.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func createLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.tintColor = UIColor(named: "YP red")
        logoutButton.accessibilityIdentifier = "logout button"
        self.logoutButton = logoutButton
    }
    
    private func setupLogoutButton() {
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
}
