import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func didSelectRowAt(indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func numberOfRows() -> Int
    func photo(at indexPath: IndexPath) -> Photo
    func heightForRowAt(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
    func configCell(_ cell: ImagesListCellProtocol, with indexPath: IndexPath)
    func didTapLike(for cell: ImagesListCellProtocol)
}
