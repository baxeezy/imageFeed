import UIKit

// MARK: - ImagesListPresenter
final class ImagesListPresenter: @preconcurrency ImagesListPresenterProtocol {
    
    // MARK: - Private Properties
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListService
    private var notificationCenter: NotificationCenter
    private var imagesListServiceObserver: NSObjectProtocol?
    private var previousPhotosCount = 0
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Initialization
    init(imagesListService: ImagesListService = ImagesListService.shared,
         notificationCenter: NotificationCenter = .default) {
        self.imagesListService = imagesListService
        self.notificationCenter = notificationCenter
        self.previousPhotosCount = imagesListService.photos.count
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
    
    @MainActor func configCell(_ cell: ImagesListCellProtocol, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let placeholderImage = UIImage(named: "placeholder_stub")
        
        if let imagesListCell = cell as? ImagesListCell {
            imagesListCell.delegate = self
        }
        
        cell.cellImage.kf.indicatorType = .activity
        (cell.cellImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        cell.cellImage.kf.setImage(
            with: URL(string: photo.largeImageURL),
            placeholder: placeholderImage,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ])
        
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        cell.setIsLiked(photo.isLiked)
    }
    
    func didTapLike(for cell: ImagesListCellProtocol) {
        guard let indexPath = cell.indexPath else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPhoto):
                    self.photos[indexPath.row] = updatedPhoto
                    cell.setIsLiked(updatedPhoto.isLiked)
                    UIBlockingProgressHUD.dismiss()
                    
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print("Ошибка изменения лайка: \(error.localizedDescription)")
                    self.view?.showLikeErrorAlert()
                    cell.setIsLiked(photo.isLiked)
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
        
        // Фильтруем только новые уникальные фото (как в рабочем коде)
        let newUniquePhotos = newPhotosFromService.filter { newPhoto in
            !photos.contains { $0.id == newPhoto.id }
        }
        
        guard !newUniquePhotos.isEmpty else { return }
        
        let oldCount = photos.count
        photos.append(contentsOf: newUniquePhotos)
        let newCount = photos.count
        
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        previousPhotosCount = newCount
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListPresenter: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        didTapLike(for: cell)
    }
}
