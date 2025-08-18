import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

    struct UrlsResult: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var perPage: Int = 10
    private let dateFormatter = ISO8601DateFormatter()
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        print("[fetchPhotosNextPage]: Запрос для ленты фотографий")
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "❌ [fetchPhotosNextPage]: Токен авторизации не найден"])))
            return
        }
        print("[fetchPhotosNextPage]: \(token)")
        
        guard let request = makeImagesListRequest(page: nextPage, perPage: perPage, token: token) else {
            print("❌ [fetchPhotosNextPage]: Неверный URL запроса для токена: \(token)")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("[fetchPhotosNextPage]: Отправка запроса к URL: \(request.url?.absoluteString ?? "nil ❌")")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { photoResult in
                    Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt),
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                }
                print("❤️")
                DispatchQueue.main.async {
                    self.lastLoadedPage = nextPage
                    self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                        )
                }
                
            case .failure(let error):
                print("❌ [fetchPhotosNextPage]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = nil
        task.resume()
    }
    
    private func makeImagesListRequest(page: Int, perPage: Int, token: String) -> URLRequest? {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
