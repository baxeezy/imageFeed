@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(with: presenter)
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLogoutButtonActionCallsPresenter() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(with: presenter)
        
        // when
        viewController.didTapLogoutButton()


        // then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled)
    }
    
    func testConfigureSetsPresenter() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        // when
        viewController.configure(with: presenter)
        
        // then
        XCTAssertNotNil(viewController.presenter)
    }
}
