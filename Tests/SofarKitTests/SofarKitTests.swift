import XCTest
@testable import SofarKit
@testable import SofarManager
import Light

final class SofarKitTests: XCTestCase {
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SofarKit().text, "Hello, World!")
    }
    
    let manager = SofarManager(webAPI: WebAPI(urlSessionConfiguration: .default),
                               city: "kharkiv",
                               cookieSessionID: "injected")

    func testReport() throws {
        let report = try manager.report.makeSyncStorage().retrieve()
        print(report.renderTextTable())
    }
    
    func testEvent() throws {
        let event = try manager.event(withCode: 19307).makeSyncStorage().retrieve()
        dump(event)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
