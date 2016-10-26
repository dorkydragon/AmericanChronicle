import XCTest
@testable import AmericanChronicle
import ObjectMapper

class OCRCoordinatesTests: XCTestCase {
    var subject: OCRCoordinates!

    // mark: Setup and Teardown

    override func setUp() {
        super.setUp()

        let path = Bundle(for: OCRCoordinatesTests.self).path(forResource: "ocr_coordinates-response", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        subject = Mapper<OCRCoordinates>().map(JSONString: str as! String)
    }

    // mark: Tests

    func testThat_pageWidthIsSetCorrectly() {
        XCTAssertEqual(subject.width, 5418.0)
    }

    func testThat_pageHeightIsSetCorrectly() {
        XCTAssertEqual(subject.height, 8268.0)
    }

    func testThat_numberOfWordsIsCorrect() {
        XCTAssertEqual(subject.wordCoordinates?.count, 209)
    }

    func testThat_itCreatesTheCorrectNumberOfRects_forTheWord_Peterson() {
        XCTAssertEqual(subject.wordCoordinates?["Peterson"]?.count, 7)
    }

    func testThat_itCreatesTheCorrectFirstRect_forTheWord_Peterson() {
        XCTAssertEqual(subject.wordCoordinates?["Peterson"]?[0], CGRect(x: 3291.0, y: 1122.0, width: 597.0, height: 111.0))
    }
}
