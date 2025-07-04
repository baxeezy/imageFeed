import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView!
    private var profileName: UILabel!
    private var profileNickname: UILabel!
    private var profileDescription: UILabel!
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupConstraints()
    }
    
@objc private func didTapButton() {
    }
    
    private func createUI() {
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
        let avatarImageView = UIImageView(image: profileImage)
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.avatarImageView = avatarImageView
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
