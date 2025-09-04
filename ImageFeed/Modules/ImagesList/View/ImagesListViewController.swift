import UIKit
import Kingfisher

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: ImagesListPresenterProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        guard presenter != nil else {
            fatalError("❌ [ImagesListViewController.viewDidLoad]: Неправильная настройка ленты фотографий")
        }
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func configureCell(_ cell: ImagesListCell, with data: ImagesListCellData) {
        let placeholderImage = UIImage(resource: .placeholderStub)
        
        cell.delegate = self
        
        cell.cellImage.kf.indicatorType = .activity
        (cell.cellImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        cell.cellImage.kf.setImage(
            with: data.imageURL,
            placeholder: placeholderImage,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ])
        
        if let createdAt = data.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.setIsLiked(data.isLiked)
    }
    
    // MARK: - ImagesListViewControllerProtocol
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPath = (oldCount ..< newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPath, with: .automatic)
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
    
    func showSingleImage(for photo: Photo) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.imageURL = URL(string: photo.largeImageURL)
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    func showLoadingIndicator(_ show: Bool) {
        if show {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func updateLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.setIsLiked(isLiked)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell,
              let cellData = presenter?.cellData(for: indexPath) else {
            return UITableViewCell()
        }
        
        configureCell(imageListCell, with: cellData)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt(indexPath: indexPath, tableViewWidth: tableView.bounds.width) ?? 0
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = cell.indexPath else { return }
        presenter?.didTapLike(for: indexPath)
    }
}
