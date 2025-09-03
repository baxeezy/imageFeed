@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didSelectRowAtCalled = false
    var willDisplayCellCalled = false
    var numberOfRowsCalled = false
    var didTapLikeCalled = false
    
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
        return 0
    }
    
    func photo(at indexPath: IndexPath) -> Photo {
        return Photo(
                    id: "test_id",
                    size: CGSize(width: 100, height: 100),
                    createdAt: Date(),
                    welcomeDescription: "test_description",
                    thumbImageURL: "test_thumb_url",
                    largeImageURL: "test_large_url",
                    isLiked: false
                )
    }
    
    func heightForRowAt(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        return 100
    }
    
    func configCell(_ cell: ImagesListCellProtocol, with indexPath: IndexPath) {}
    
    func didTapLike(for cell: ImagesListCellProtocol) {
        didTapLikeCalled = true
    }
}
