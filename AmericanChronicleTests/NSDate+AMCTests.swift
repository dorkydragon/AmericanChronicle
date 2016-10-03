import XCTest
@testable import AmericanChronicle

class NSDateAMCTests: XCTestCase {

    func testThatIt_returnsTheCorrectYear_onFirstDayOfYear() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "1903-01-01")
        XCTAssertEqual(date?.year, 1903)
    }

    func testThatIt_returnsTheCorrectYear_onLastDayOfYear() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2015-12-31")
        XCTAssertEqual(date?.year, 2015)
    }

    func testThatIt_returnsTheCorrectMonth_onFirstDayOfMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "1878-03-01")
        XCTAssertEqual(date?.month, 03)
    }

    func testThatIt_returnsTheCorrectMonth_onLastDayOfMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "1899-11-30")
        XCTAssertEqual(date?.month, 11)
    }
}
