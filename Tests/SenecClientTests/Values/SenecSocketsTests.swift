//
//  SenecSocketsTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 19.10.18.
//

import XCTest
@testable import SenecClient

/// A Collection of `SenecSocketSetting`s.

class SenecSocketsTests: XCTestCase {

    var autoSocketSetting: SenecSocketSetting = {
        let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger (minTime: 10,
                                                                         lowerPowerLimit: 11,
                                                                         upperPowerLimit: 12,
                                                                         onTime: 13)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 10, minutes: 20)
        let status = SenecSocketSetting.SocketStatus(powerOn: true, timeRemaining: 10)
        return SenecSocketSetting(mode: .automatic, autoTrigger: autoTrigger, timeTrigger: timeTrigger, status: status)
    }()
//
//    var forceSocketSetting =

    var offSocketSetting: SenecSocketSetting = {
		let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger (minTime: 10,
                                                                     lowerPowerLimit: 11,
                                                                     upperPowerLimit: 12,
                                                                     onTime: 13)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 12, minutes: 30)
        let status = SenecSocketSetting.SocketStatus(powerOn: false, timeRemaining: 0)
        return SenecSocketSetting(mode: .off, autoTrigger: autoTrigger, timeTrigger: timeTrigger, status: status)
    }()



    func testConstructor () {
        let sut = SenecSockets (settings: [offSocketSetting])
        XCTAssertEqual(sut[0], offSocketSetting)
    }



    func testConstructor1 () {
        let sut = SenecSockets (settings: [offSocketSetting, autoSocketSetting])

        XCTAssertEqual(sut[0], offSocketSetting)
        XCTAssertEqual(sut[1], autoSocketSetting)
    }



    func testJSONDeserialization_Automatic () {
        let jsonString = """
        {
            "ENERGY": {
                "ZERO_EXPORT": "u8_00"
            },
            "SOCKETS": {
                "ENABLE": [
                    "u8_01",
                    "u8_00"
                ],
                "USE_TIME": [
                    "u8_00",
                    "u8_00"
                ],
                "FORCE_ON": [
                    "u8_00",
                    "u8_00"
                ],
                "TIME_REM": [
                    "u1_0064",
                    "u1_0032"
                ],
                "POWER_ON": [
                    "u8_01",
                    "u8_00"
                ],
                "UPPER_LIMIT": [
                    "u1_09C4",
                    "u1_0100"
                ],
                "LOWER_LIMIT": [
                    "u1_09C4",
                    "u1_0200"
                ],
                "TIME_LIMIT": [
                    "u1_0002",
                    "u1_0004"
                ],
                "POWER_ON_TIME": [
                    "u1_003C",
                    "u1_001E"
                ],
                "PRIORITY": [
                    "u8_00",
                    "u8_00"
                ],
                "SWITCH_ON_HOUR": [
                    "u8_00",
                    "u8_00"
                ],
                "SWITCH_ON_MINUTE": [
                    "u8_00",
                    "u8_00"
                ],
                "NUMBER_OF_SOCKETS": "u8_02",
                "ALREADY_SWITCHED": [
                    "u8_00",
                    "u8_00"
                ]
            }
        }
        """

        let sut = decode (SenecSockets.self, json: jsonString)

        let expectedTrigger0 = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 2,
                                                                             lowerPowerLimit: 2500,
                                                                             upperPowerLimit: 2500,
                                                                             onTime: 60)
        let expectedTimeTrigger0 = SenecSocketSetting.TimeTrigger(hour: 0, minutes: 0)
        let expectedStatus0 = SenecSocketSetting.SocketStatus(powerOn: true, timeRemaining: 100)
        let expectedSettings0 = SenecSocketSetting (mode: .automatic,
                                                    autoTrigger: expectedTrigger0,
                                                    timeTrigger: expectedTimeTrigger0,
                                                    status: expectedStatus0)

        let expectedTrigger1 = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 4,
                                                                             lowerPowerLimit: 512,
                                                                             upperPowerLimit: 256,
                                                                             onTime: 30)
        let expectedTimeTrigger1 = SenecSocketSetting.TimeTrigger(hour: 0, minutes: 0)
        let expectedStatus1 = SenecSocketSetting.SocketStatus(powerOn: false, timeRemaining: 50)
        let expectedSettings1 = SenecSocketSetting(mode: .off,
                                                   autoTrigger: expectedTrigger1,
                                                   timeTrigger: expectedTimeTrigger1,
                                                   status: expectedStatus1)

        XCTAssertEqual(sut![0], expectedSettings0)
        XCTAssertEqual(sut![1], expectedSettings1)
    }
}
