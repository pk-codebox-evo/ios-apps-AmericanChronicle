import XCTest
@testable import AmericanChronicle

class VerticalStripTests: XCTestCase {

    private var subject: VerticalStrip!

    override func setUp() {
        super.setUp()
        subject = VerticalStrip(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        subject.items = ["One", "Two", "Three"]
        subject.layoutIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThat_showItemAtIndex_setsSelectedIndexToTopVisibleIndex_whenFractionHiddenIsLessThanHalf() {

        subject.showItemAtIndex(1, withFractionScrolled: 0.49)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.selectedIndex, 1)
    }

    func testThat_showItemAtIndex_increasesSelectedIndexByOne_whenFractionHiddenIsEqualToHalf() {

        subject.showItemAtIndex(1, withFractionScrolled: 0.5)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.selectedIndex, 2)
    }

    func testThat_showItemAtIndex_increasesSelectedIndexByOne_whenFractionHiddenIsGreaterThanHalf() {

        subject.showItemAtIndex(0, withFractionScrolled: 0.51)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.selectedIndex, 1)
    }

    func testThat_showItemAtIndex_setsSelectedIndexToZero_ifIndexIsLessThanZero() {

        subject.showItemAtIndex(-1, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.selectedIndex, 0)
    }

    func testThat_showItemAtIndex_setsSelectedIndexToTheLastItem_ifIndexIsGreaterThanNumberOfItems() {

        subject.showItemAtIndex(3, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.selectedIndex, 2)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifIndexIsZero() {

        subject.showItemAtIndex(0, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.yOffset, 0.0)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifIndexIsOne() {

        subject.showItemAtIndex(1, withFractionScrolled: 0.0)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.yOffset, 212.0)
    }

    func testThat_showItemAtIndex_setsContentOffsetCorrectly_ifFractionIsNotZero() {

        subject.showItemAtIndex(1, withFractionScrolled: 0.3)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.yOffset, 276.0)
    }

    func testThat_showItemAtIndex_ignoresFraction_ifIndexIsLastItem() {

        subject.showItemAtIndex(2, withFractionScrolled: 0.3)
        subject.layoutIfNeeded()

        XCTAssertEqual(subject.yOffset, 424.0)
    }
}
