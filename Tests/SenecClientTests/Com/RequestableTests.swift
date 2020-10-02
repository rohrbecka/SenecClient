//
//  RequestableTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 21.10.18.
//

import XCTest
@testable import SenecClient

/// Ensures the availability of the `Requestable` protocol
class RequestableTests: XCTestCase {

    func testProtocolExistance () {
        let sut: Any = RequestableMock()
        XCTAssert(sut is Requestable)
    }

}



private struct RequestableMock: Requestable {
    static func request (url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
}
