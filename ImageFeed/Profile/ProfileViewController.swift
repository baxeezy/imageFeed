import UIKit
import Kingfisher

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private var avatarImageView: UIImageView!
    private var profileName: UILabel!
    private var profileNickname: UILabel!
    private var profileDescription: UILabel!
    private var logoutButton: UIButton!
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupConstraints()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                print("Получено уведомление об изменении аватарки")
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - Private Methods
    @objc private func didTapButton() {
        ProfileLogoutService.shared.logout()
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else {
            print("[updateAvatar]: avatarURL равен nil")
            return
        }
        guard let imageUrl = URL(string: profileImageURL) else {
            print("[updateAvatar]: неверный URL аватарки - \(profileImageURL)")
            return
        }

        print("imageUrl: \(imageUrl)")
    
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateProfileDetails(profile: Profile) {
        profileName.text = profile.name.isEmpty
        ? "Имя не указано"
        : profile.name
        profileNickname.text = profile.loginName.isEmpty
        ? "@неизвестный_пользователь"
        : profile.loginName
        profileDescription.text = (profile.bio?.isEmpty ?? true)
        ? "Профиль не заполнен"
        : profile.bio
    }
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
            action: #selector(Self.didTapButton)
            )
        
            view.addSubview(logoutButton)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.tintColor = UIColor(named: "YP red")
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
