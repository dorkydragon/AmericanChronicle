import XCTest
@testable import AmericanChronicle
import ObjectMapper

class SearchResultTests: XCTestCase {
    func testThat_itProperlyConvertsItsURLToAThumbnailURL() {
        let JSONString = "{\"url\": \"http://chroniclingamerica.loc.gov/lccn/sn83045487/1913-02-20/ed-1/seq-18.json\"}"
        let result = Mapper<SearchResult>().map(JSONString: JSONString)
        XCTAssertEqual(result?.thumbnailURL?.absoluteString, "http://chroniclingamerica.loc.gov/lccn/sn83045487/1913-02-20/ed-1/seq-18/thumbnail.jpg")
    }
}
