import XCTest
@testable import AmericanChronicle

class USStatePickerWireframeTests: XCTestCase {
    var subject: USStatePickerWireframe!
    var delegate: FakeUSStatePickerWireframeDelegate!
    var presenter: FakeUSStatePickerPresenter!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        delegate = FakeUSStatePickerWireframeDelegate()
        presenter = FakeUSStatePickerPresenter()
        subject = USStatePickerWireframe(delegate: delegate, presenter: presenter)
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Tests

    func testThat_onInit_itSetsThePresenterWireframe() {
        XCTAssertEqual(presenter.wireframe as? USStatePickerWireframe, subject)
    }

    func testThat_onPresent_itSets_presentedViewController() {

        // when

        subject.present(from: nil, withSelectedStateNames: [])

        // then

        let nvc = subject.presentedViewController as? UINavigationController
        XCTAssert(nvc?.topViewController is USStatePickerViewController)
    }

    func testThat_onPresent_itAsksThePresenterToConfigureTheView_withTheCorrectViewType() {

        // when

        subject.present(from: nil, withSelectedStateNames: [])

        // then

        XCTAssert(presenter.didCallConfigureWithUserInterface is USStatePickerViewController)
    }

    func testThat_onPresent_itAsksThePresenterToConfigureTheView_withTheSameSelectedStateNames() {

        // when

        subject.present(from: nil, withSelectedStateNames: ["One", "Two"])

        // then

        XCTAssertEqual(presenter.didCallConfigureWithSelectedStateNames!, ["One", "Two"])
    }

}
