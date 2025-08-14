import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private let urlSession = URLSession.shared
    
    private(set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    private init() {}

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            guard lastCode != code else {
                print("[fetchOAuthToken]: Повторный запрос токена с тем же кодом авторизации")
                completion(.failure(.invalidRequest))
                return
            }
        }
        
            lastCode = code
            guard let request = makeOAuthTokenRequest(code: code) else {
                print("[fetchOAuthToken]: Не удалось создать запрос для токена: \(code)")
                completion(.failure(.invalidRequest))
                return
            }
            task?.cancel()
            
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                switch result {
                case .success(let tokenResponse):
                        OAuth2TokenStorage.shared.token = tokenResponse.accessToken
                        completion(.success(tokenResponse.accessToken))
                    
                case .failure(let error):
                    print("[fetchOAuthToken]: Ошибка запроса: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .urlSessionError))
                }
                self?.lastCode = nil
            }
            task?.resume()
        }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let authTokenUrl = urlComponents.url else { return nil }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
