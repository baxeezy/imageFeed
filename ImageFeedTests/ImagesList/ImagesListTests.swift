@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testDidSelectRowAtCallsPresenter() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
        
        // then
        XCTAssertTrue(presenter.didSelectRowAtCalled)
    }
    
    func testWillDisplayCellCallsPresenter() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        let indexPath = IndexPath(row: 5, section: 0)
        let cell = UITableViewCell()
        
        // when
        viewController.tableView(viewController.tableView, willDisplay: cell, forRowAt: indexPath)
        
        // then
        XCTAssertTrue(presenter.willDisplayCellCalled)
    }
    
    func testNumberOfRowsCallsPresenter() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        // when
        _ = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        
        // then
        XCTAssertTrue(presenter.numberOfRowsCalled)
    }
}
