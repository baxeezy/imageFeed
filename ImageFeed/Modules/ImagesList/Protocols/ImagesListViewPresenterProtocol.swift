import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func numberOfRows() -> Int
    func photo(at indexPath: IndexPath) -> Photo
    func didSelectRowAt(indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func heightForRowAt(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
    func cellData(for indexPath: IndexPath) -> ImagesListCellData
    func didTapLike(for indexPath: IndexPath)
}
