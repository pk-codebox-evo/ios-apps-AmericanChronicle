import XCTest
@testable import AmericanChronicle
import ObjectMapper

class OCRCoordinatesTests: XCTestCase {
    var subject: OCRCoordinates!
    override func setUp() {
        super.setUp()

        let path = NSBundle(forClass: OCRCoordinatesTests.self).pathForResource("ocr_coordinates-response", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        subject = Mapper<OCRCoordinates>().map(str!)
    }

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
