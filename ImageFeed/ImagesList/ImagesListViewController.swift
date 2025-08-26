import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!

    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesService.fetchPhotosNextPage { [weak self] _ in
            self?.updateTableViewAnimated()
        }
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                print("Получено уведомление об изменении ленты фотографий")
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func showSingleImage(for photo: Photo) {
            let singleImageVC = SingleImageViewController()
            singleImageVC.imageURL = URL(string: photo.largeImageURL)
            singleImageVC.modalPresentationStyle = .fullScreen
            present(singleImageVC, animated: true)
        }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("❌ [tableView: cellForRowAt]: Удаленная из очереди ячейка не является экземпляром ImagesListCell")
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableVIew: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1 else {
            print("❌ [tableView: willDisplay]: Количество фото не равно количеству ячеек: \(indexPath.row)/\(photos.count - 1)")
            return
        }
        imagesService.fetchPhotosNextPage { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let placeholderImage = UIImage(named: "placeholder_stub")
        
        cell.delegate = self
        
        cell.cellImage.kf.indicatorType = .activity
        (cell.cellImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        cell.cellImage.kf.setImage(
            with: URL(string: photo.largeImageURL),
            placeholder: placeholderImage,
            options: [
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
                    print("[configCell]: Ошибка загрузки изображения: \(error)")
                }
            }
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        cell.setIsLiked(photo.isLiked)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        showSingleImage(for: photo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageSize = photo.size
        let scale = imageViewWidth / imageSize.width
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        let newPhotos = imagesService.photos
        let newUniquePhotos = newPhotos.filter { newPhoto in
            !photos.contains { $0.id == newPhoto.id }
        }
        guard !newUniquePhotos.isEmpty else { return }
        
        let oldCount = photos.count
        photos.append(contentsOf: newUniquePhotos)
        let newCount = photos.count
        
        tableView.performBatchUpdates {
            let indexPath = (oldCount ..< newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPath, with: .automatic)
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesService.changeLike(
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
                    self.showLikeErrorAlert()
                    cell.setIsLiked(photo.isLiked)
                }
            }
        }
    }
    
    func showLikeErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

                
