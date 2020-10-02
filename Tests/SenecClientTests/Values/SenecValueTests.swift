//
//  SenecValueTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 07.10.18.
//

import XCTest
@testable import SenecClient

/// Tests the SenecValue type.
///
/// - Author: André Rohrbeck
/// - Copyright: André Rohrbeck © 2018
/// - Date: 2018-10-07
class SenecValueTests: XCTestCase {


    // MARK: - Constructor Tests
    func test_SenecValue_DefaultConstructor() {
        _ = SenecValue.float(1.2345)
        _ = SenecValue.uint8(128)
        _ = SenecValue.uint16(32678)
        _ = SenecValue.uint32(100000000)
        _ = SenecValue.uint64(1000000000000)
        _ = SenecValue.int8(-127)
        _ = SenecValue.int16(-32677)
        _ = SenecValue.int32(-100000000)
        _ = SenecValue.int64(-1000000000000)
    }



    func test_SenecValue_constructsCorrectValue_givenCorrectString () {
        // floating point
        assertCorrectConstruction(with: "fl_409DA112", expected: .float(4.925912013758661))
        assertCorrectConstruction(with: "fl_00000000", expected: .float(0.0))
        assertCorrectConstruction(with: "fl_80000000", expected: .float(-0.0))

        // unsigned ints
        assertCorrectConstruction(with: "u8_0c", expected: .uint8(12))
        assertCorrectConstruction(with: "u1_0c45", expected: .uint16(3141))
        assertCorrectConstruction(with: "u3_c456fe38", expected: .uint32(3_294_035_512))
        assertCorrectConstruction(with: "u6_c456fe38c456fe38", expected: .uint64(0xc456fe38c456fe38))

        // signed ints
        assertCorrectConstruction(with: "i8_ff", expected: .int8(-1))
        assertCorrectConstruction(with: "i1_ffff", expected: .int16(-1))
        assertCorrectConstruction(with: "i3_FFFFFFFF", expected: .int32(-1))
        assertCorrectConstruction(with: "i6_FFFFFFFFFFFFFFFF", expected: .int64(-1))

        // strings and characters
        // This is not implemented yet, as no example could be found while analyzing the Senec JSON API.
    }



    func test_SenecValue_constructorReturnsNil_givenIllegalString () {
        assertCorrectConstruction(with: "affe", expected: nil, "The senec type prefix is missing.")
        assertCorrectConstruction(with: "fl_hello", expected: nil, "hello isn't a valid hex string.")
        assertCorrectConstruction(with: "u8_beef", expected: nil, "beef is too long for a uint8 value.")
        // TODO: add more tests
    }


    // MARK: - Test retreival of wrapped value.
    func test_doubleValue_returnsCorrectValue () {
        XCTAssertEqual(SenecValue.float(1.2345).doubleValue!, 1.2345, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.uint8(15).doubleValue!, 15.0, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.uint16(12345).doubleValue!, 12345.0, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.uint32(1_000_000).doubleValue!, 1_000_000, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.uint64(1_000_000_000).doubleValue!, 1_000_000_000, accuracy: 0.1)
        XCTAssertEqual(SenecValue.int8(-15).doubleValue!, -15.0, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.int16(-12345).doubleValue!, -12345.0, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.int32(-1_000_000).doubleValue!, -1_000_000, accuracy: 0.00001)
        XCTAssertEqual(SenecValue.int64(-1_000_000_000).doubleValue!, -1_000_000_000, accuracy: 0.1)
    }



    func test_intValue_returnsCorrectValue () {
        XCTAssertEqual(SenecValue.float(1.2345).intValue!, 1)
        XCTAssertEqual(SenecValue.float(1.5432).intValue!, 2)
        XCTAssertEqual(SenecValue.float(-1.2345).intValue!, -1)
        XCTAssertEqual(SenecValue.float(-1.5345).intValue!, -2)
        XCTAssertEqual(SenecValue.uint8(15).intValue!, 15)
        XCTAssertEqual(SenecValue.uint16(12345).intValue!, 12345)
        XCTAssertEqual(SenecValue.uint32(1_000_000).intValue!, 1_000_000)
        XCTAssertEqual(SenecValue.uint64(1_000_000_000).intValue!, 1_000_000_000)
        XCTAssertEqual(SenecValue.int8(-15).intValue!, -15)
        XCTAssertEqual(SenecValue.int16(-12345).intValue!, -12345)
        XCTAssertEqual(SenecValue.int32(-1_000_000).intValue!, -1_000_000)
        XCTAssertEqual(SenecValue.int64(-1_000_000_000).intValue!, -1_000_000_000)
    }



    func test_uintValue_returnsCorrectValue () {
        XCTAssertEqual(SenecValue.float(1.2345).uintValue!, 1)
        XCTAssertEqual(SenecValue.float(1.5432).uintValue!, 2)
        XCTAssertEqual(SenecValue.float(-1.2345).uintValue, UInt?.none)
        XCTAssertEqual(SenecValue.float(-1.5345).uintValue, UInt?.none)
        XCTAssertEqual(SenecValue.uint8(15).uintValue!, 15)
        XCTAssertEqual(SenecValue.uint16(12345).uintValue!, 12345)
        XCTAssertEqual(SenecValue.uint32(1_000_000).uintValue!, 1_000_000)
        XCTAssertEqual(SenecValue.uint64(1_000_000_000).uintValue!, 1_000_000_000)
        XCTAssertEqual(SenecValue.int8(-15).uintValue, UInt?.none)
        XCTAssertEqual(SenecValue.int16(-12345).uintValue, UInt?.none)
        XCTAssertEqual(SenecValue.int32(-1_000_000).uintValue, UInt?.none)
        XCTAssertEqual(SenecValue.int64(-1_000_000_000).uintValue, UInt?.none)
    }



    func test_boolValue_returnsCorrectValue () {
        XCTAssertEqual(SenecValue.float(1.2345).boolValue, true)
        XCTAssertEqual(SenecValue.float(0.0).boolValue, false)
        XCTAssertEqual(SenecValue.float(-0.0).boolValue, false)
        XCTAssertEqual(SenecValue.float(-1.5345).boolValue, true)
        XCTAssertEqual(SenecValue.uint8(1).boolValue, true)
        XCTAssertEqual(SenecValue.uint8(0).boolValue, false)
        XCTAssertEqual(SenecValue.uint16(1).boolValue, true)
        XCTAssertEqual(SenecValue.uint16(0).boolValue, false)
        XCTAssertEqual(SenecValue.uint32(1).boolValue, true)
        XCTAssertEqual(SenecValue.uint32(0).boolValue, false)
        XCTAssertEqual(SenecValue.uint64(1).boolValue, true)
        XCTAssertEqual(SenecValue.uint64(0).boolValue, false)
        XCTAssertEqual(SenecValue.int8(1).boolValue, true)
        XCTAssertEqual(SenecValue.int8(0).boolValue, false)
        XCTAssertEqual(SenecValue.int16(1).boolValue, true)
        XCTAssertEqual(SenecValue.int16(0).boolValue, false)
        XCTAssertEqual(SenecValue.int32(1).boolValue, true)
        XCTAssertEqual(SenecValue.int32(0).boolValue, false)
        XCTAssertEqual(SenecValue.int64(1).boolValue, true)
        XCTAssertEqual(SenecValue.int64(0).boolValue, false)
    }


    // MARK: - Helper functions
    private func assertCorrectConstruction(with string: String,
                                           expected: SenecValue?,
                                           _ message: String = "",
                                           file: StaticString = #file,
                                           line: UInt = #line) {
        let value = SenecValue(string: string)
        XCTAssertEqual(expected, value, message, file: file, line: line)
    }
}
