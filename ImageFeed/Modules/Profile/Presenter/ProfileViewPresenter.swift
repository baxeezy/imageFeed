import Foundation

// MARK: - ProfilePresenter
final class ProfilePresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    init(profileService: ProfileService = .shared) {
        self.profileService = profileService
    }
    
    // MARK: - ProfileViewPresenterProtocol
    func viewDidLoad() {
        setupObservers()
        loadInitialData()
    }
    
    func didTapLogoutButton() {
        view?.showLogoutConfirmation()
    }
    
    func didReceiveProfileUpdate(profile: Profile) {
        let name = profile.name
        let nickname = profile.loginName
        let description = profile.bio ?? ""
        view?.updateProfileDetails(name: name, nickname: nickname, description: description)
        
        if ProfileImageService.shared.avatarURL == nil {
            fetchAvatar(for: profile.username)
        }
    }
    
    func didReceiveAvatarUpdate(avatarURL: String?) {
        guard let avatarURLString = avatarURL,
              let url = URL(string: avatarURLString) else {
            view?.updateAvatar(with: nil)
            return
        }
        view?.updateAvatar(with: url)
    }
    
    // MARK: - Private Methods
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let avatarURL = notification.userInfo?["URL"] as? String {
                self?.didReceiveAvatarUpdate(avatarURL: avatarURL)
            }
        }
    }
    
    private func loadInitialData() {
        if let profile = profileService.profile {
            didReceiveProfileUpdate(profile: profile)
        }
        
        if let avatarURL = ProfileImageService.shared.avatarURL {
            didReceiveAvatarUpdate(avatarURL: avatarURL)
        }
    }
    
    private func fetchAvatar(for username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) { [weak self] result in
            switch result {
            case .success(let avatarURL):
                self?.didReceiveAvatarUpdate(avatarURL: avatarURL)
            case .failure(let error):
                print("Ошибка загрузки аватарки: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
