import UIKit

// MARK: - ImagesListPresenter
final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Private Properties
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListService
    private var notificationCenter: NotificationCenter
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    // MARK: - Initialization
    init(imagesListService: ImagesListService = ImagesListService.shared,
         notificationCenter: NotificationCenter = .default) {
        self.imagesListService = imagesListService
        self.notificationCenter = notificationCenter
        self.photos = imagesListService.photos
    }
    
    // MARK: - ImagesListPresenterProtocol
    func viewDidLoad() {
        fetchNextPage()
        setupObservers()
    }
    
    func numberOfRows() -> Int {
        return photos.count
    }
    
    func photo(at indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showSingleImage(for: photo)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            fetchNextPage()
        }
    }
    
    func heightForRowAt(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        
        let imageSize = photo.size
        let scale = imageViewWidth / imageSize.width
        return imageSize.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func cellData(for indexPath: IndexPath) -> ImagesListCellData {
        let photo = photos[indexPath.row]
        return ImagesListCellData(
            imageURL: URL(string: photo.largeImageURL),
            createdAt: photo.createdAt,
            isLiked: photo.isLiked,
            indexPath: indexPath
        )
    }
    
    func didTapLike(for indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        view?.showLoadingIndicator(true)
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.showLoadingIndicator(false)
                
                switch result {
                case .success(let updatedPhoto):
                    self.photos[indexPath.row] = updatedPhoto
                    self.view?.updateLikeStatus(at: indexPath, isLiked: updatedPhoto.isLiked)
                    
                case .failure(let error):
                    print("Ошибка изменения лайка: \(error.localizedDescription)")
                    self.view?.showLikeErrorAlert()
                    // Возвращаем предыдущее состояние
                    self.view?.updateLikeStatus(at: indexPath, isLiked: photo.isLiked)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchNextPage() {
        imagesListService.fetchPhotosNextPage { _ in }
    }
    
    private func setupObservers() {
        imagesListServiceObserver = notificationCenter.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handlePhotosUpdate()
        }
    }
    
    private func handlePhotosUpdate() {
        let newPhotosFromService = imagesListService.photos
        
        // Фильтруем только новые уникальные фото
        let newUniquePhotos = newPhotosFromService.filter { newPhoto in
            !photos.contains { $0.id == newPhoto.id }
        }
        
        guard !newUniquePhotos.isEmpty else { return }
        
        let oldCount = photos.count
        photos.append(contentsOf: newUniquePhotos)
        let newCount = photos.count
        
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
}
