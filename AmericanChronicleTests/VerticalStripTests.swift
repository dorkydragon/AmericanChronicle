import XCTest
@testable import AmericanChronicle

class VerticalStripTests: XCTestCase {

    private var subject: VerticalStrip!

    // mark: Setup and Teardown

    override func setUp() {
        super.setUp()
        subject = VerticalStrip(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        subject.items = ["One", "Two", "Three"]
        subject.layoutIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }

    // mark: Tests

    func testThat_showItemAtIndex_setsSelectedIndexToTopVisibleIndex_whenFractionHiddenIsLessThanHalf() {

        // when

        subject.showItemAtIndex(1, withFractionScrolled: 0.49)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.selectedIndex, 1)
    }

    func testThat_showItemAtIndex_increasesSelectedIndexByOne_whenFractionHiddenIsEqualToHalf() {

        // when

        subject.showItemAtIndex(1, withFractionScrolled: 0.5)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.selectedIndex, 2)
    }

    func testThat_showItemAtIndex_increasesSelectedIndexByOne_whenFractionHiddenIsGreaterThanHalf() {

        // when

        subject.showItemAtIndex(0, withFractionScrolled: 0.51)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.selectedIndex, 1)
    }

    func testThat_showItemAtIndex_setsSelectedIndexToZero_ifIndexIsLessThanZero() {

        // when

        subject.showItemAtIndex(-1, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.selectedIndex, 0)
    }

    func testThat_showItemAtIndex_setsSelectedIndexToTheLastItem_ifIndexIsGreaterThanNumberOfItems() {

        // when

        subject.showItemAtIndex(3, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.selectedIndex, 2)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifIndexIsZero() {

        // when

        subject.showItemAtIndex(0, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.yOffset, 0.0)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifIndexIsOne() {

        // when

        subject.showItemAtIndex(1, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.yOffset, 212.0)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifFractionIsNotZero() {

        // when

        subject.showItemAtIndex(1, withFractionScrolled: 0.3)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.yOffset, 276.0)
    }

    func testThat_showItemAtIndex_ignoresFraction_ifIndexIsLastItem() {

        // when

        subject.showItemAtIndex(2, withFractionScrolled: 0.3)
        subject.layoutIfNeeded()

        // then

        XCTAssertEqual(subject.yOffset, 424.0)
    }
}
