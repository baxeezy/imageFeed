import UIKit

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username, bio
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    private(set) var profile: Profile?
    private var task: URLSessionTask?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(token: token) else {
            print("[fetchProfile]: Неверный URL запроса для токена: \(token)")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                    let profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.firstName) \(profileResult.lastName)"
                            .trimmingCharacters(in: .whitespaces),
                        loginName: "@\(profileResult.username)",
                        bio: profileResult.bio
                    )
                    self?.profile = profile
                    completion(.success(profile))
                
            case .failure(let error):
                print("[fetchProfile]: Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
