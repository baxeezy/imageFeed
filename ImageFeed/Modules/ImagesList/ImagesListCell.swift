import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImagesListCell
final class ImagesListCell: UITableViewCell & ImagesListCellProtocol {
    var indexPath: IndexPath? {
        guard let tableView = superview as? UITableView else { return nil }
        return tableView.indexPath(for: self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI Elements
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(cellImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            cellImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            cellImage.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -8),
            
            likeButton.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = .ypBlack
        selectionStyle = .none
        backgroundColor = .ypBlack
    }
    
    // MARK: - Actions
    @objc private func likeButtonTapped() {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    //MARK: - Public Methods
    func configure(with photo: Photo, date: String?) {
        dateLabel.text = date
        
        if let url = URL(string: photo.thumbImageURL) {
            cellImage.kf.indicatorType = .activity
            cellImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "Stub"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        setIsLiked(photo.isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
