import XCTest
@testable import SofarKit

final class SofarKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SofarKit().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
