import XCTest
@testable import AmericanChronicle

class SearchWireframeTests: XCTestCase {

    var subject: SearchWireframe!

    // mark: Setup and Teardown

    override func setUp() {
        super.setUp()
        subject = SearchWireframe()
    }

    // mark: Tests

    func testThat_whenAskedToPresentSearch_itPresentsItsView_wrappedInANavigationController() {

        // when

        let window = UIWindow()
        subject.beginAsRootFromWindow(window)
        let nvc = window.rootViewController as? UINavigationController

        // then

        XCTAssertTrue(nvc?.topViewController is SearchViewController)
    }
}
