import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var showLikeErrorAlertCalled = false
    var showSingleImageCalled = false
    var showLoadingIndicatorCalled = false
    var updateLikeStatusCalled = false
    var oldCount: Int?
    var newCount: Int?
    var showPhoto: Photo?
    var loadingIndicatorShow: Bool?
    var likeUpdateIndexPath: IndexPath?
    var likeUpdateStatus: Bool?
    
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
        showPhoto = photo
    }
    
    func showLoadingIndicator(_ show: Bool) {
        showLoadingIndicatorCalled = true
        loadingIndicatorShow = show
    }
    
    func updateLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        updateLikeStatusCalled = true
        likeUpdateIndexPath = indexPath
        likeUpdateStatus = isLiked
    }
}
