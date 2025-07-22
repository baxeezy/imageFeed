import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, NetworkError>) -> Void
        ) {
            guard lastCode != code else {
                completion(.failure(.invalidRequest))
                return
            }
            lastCode = code
            guard let request = makeOAuthTokenRequest(code: code) else {
                completion(.failure(.invalidRequest))
                return
            }
            task?.cancel()
            
            task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        OAuth2TokenStorage.shared.token = tokenResponse.accessToken
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    completion(.failure(error as? NetworkError ?? .urlSessionError))
                }
                self.lastCode = nil
            }
            task?.resume()
        }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
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
