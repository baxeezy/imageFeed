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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Загрузка фотографий
        ImagesListService.shared.fetchPhotosNextPage { [weak self] _ in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("❌ [ImagesListViewController]: Неверное наследование секвея")
                return
            }
            
            let photo = photos[indexPath.row]
            if let url = URL(string: photo.thumbImageURL) {
                        viewController.imageURL = url
                    }
        } else {
            print("❌ [ImagesListViewController]: Неподдерживающий секвей переход")
            super.prepare(for: segue, sender: sender)
        }
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
        ImagesListService.shared.fetchPhotosNextPage { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        let placeholderImage = UIImage(named: "placeholder_stub")
        
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

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let photo = photos[indexPath.row]
                let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
                let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
                
                // Используем размеры фото из модели
                let imageSize = photo.size
                let scale = imageViewWidth / imageSize.width
                let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
                
                return cellHeight
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        let newPhotos = ImagesListService.shared.photos
        
        // Проверяем, что новые фото действительно новые и не дублируют существующие
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
