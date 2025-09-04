@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didSelectRowAtCalled = false
    var willDisplayCellCalled = false
    var numberOfRowsCalled = false
    var didTapLikeCalled = false
    var cellDataCalled = false
    
    private var testPhotos: [Photo] = [
        Photo(
            id: "test_id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: "test_description",
            thumbImageURL: "test_thumb_url",
            largeImageURL: "test_large_url",
            isLiked: false
        )
    ]
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        didSelectRowAtCalled = true
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        willDisplayCellCalled = true
    }
    
    func numberOfRows() -> Int {
        numberOfRowsCalled = true
        return testPhotos.count
    }
    
    func photo(at indexPath: IndexPath) -> Photo {
        return testPhotos[indexPath.row]
    }
    
    func heightForRowAt(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        return 100
    }
    
    func cellData(for indexPath: IndexPath) -> ImagesListCellData {
        cellDataCalled = true
        let photo = testPhotos[indexPath.row]
        return ImagesListCellData(
            imageURL: URL(string: photo.largeImageURL),
            createdAt: photo.createdAt,
            isLiked: photo.isLiked,
            indexPath: indexPath
        )
    }
    
    func didTapLike(for indexPath: IndexPath) {
        didTapLikeCalled = true
    }
}
