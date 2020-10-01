import XCTest
@testable import SenecClient

final class SenecClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SenecClient().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
