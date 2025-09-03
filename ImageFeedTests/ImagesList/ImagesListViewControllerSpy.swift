import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var showLikeErrorAlertCalled = false
    var showSingleImageCalled = false
    var oldCount: Int?
    var newCount: Int?
    var shownPhoto: Photo?
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
        self.oldCount = oldCount
        self.newCount = newCount
    }
    
    func showLikeErrorAlert() {
        showLikeErrorAlertCalled = true
    }
    
    func showSingleImage(for photo: Photo) {
        showSingleImageCalled = true
        shownPhoto = photo
    }
}
