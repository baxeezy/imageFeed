import UIKit

public protocol ImagesListCellProtocol: AnyObject {
    var cellImage: UIImageView { get }
    var dateLabel: UILabel { get }
    var likeButton: UIButton { get }
    var indexPath: IndexPath? { get }
    func setIsLiked(_ isLiked: Bool)
}
