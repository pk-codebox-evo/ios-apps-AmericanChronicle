import XCTest
@testable import AmericanChronicle

class DayMonthYearTests: XCTestCase {

    func testThat_whenCreatedWithValidComponents_itReturnsTheCorrectUserVisibleString() {
        let subject = DayMonthYear(day: 1, month: 12, year: 1865)
        XCTAssertEqual(subject.userVisibleString, "Dec 01, 1865")
    }
}
