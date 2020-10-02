//
//  SenecSocketTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 18.10.18.
//

import XCTest
@testable import SenecClient

class SenecSocketSettingTests: XCTestCase {

    func testConstructor () {
        let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 10,
                                                                        lowerPowerLimit: 20,
                                                                        upperPowerLimit: 30,
                                                                        onTime: 40)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 12, minutes: 0)
        let status = SenecSocketSetting.SocketStatus(powerOn: true,
                                                     timeRemaining: 100)
        let forcedSut = SenecSocketSetting(mode: .forced,
                                           autoTrigger: autoTrigger,
                                           timeTrigger: timeTrigger,
                                           status: status)


        let expectedAutoTrigger = autoTrigger
        let expectedTimeTrigger = timeTrigger
        let expectedStatus = status
        XCTAssertEqual(forcedSut.mode, .forced)
        XCTAssertEqual(forcedSut.autoTrigger, expectedAutoTrigger)
        XCTAssertEqual(forcedSut.timeTrigger, expectedTimeTrigger)
        XCTAssertEqual(forcedSut.status, expectedStatus)
    }



    func testConstructor1 () {
        let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 100,
                                                                        lowerPowerLimit: 200,
                                                                        upperPowerLimit: 300,
                                                                        onTime: 400)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 20, minutes: 15)
        let status = SenecSocketSetting.SocketStatus(powerOn: false,
                                                     timeRemaining: 0)
        let automaticSut = SenecSocketSetting(mode: .automatic,
                                              autoTrigger: autoTrigger,
                                              timeTrigger: timeTrigger,
                                              status: status)


        let expectedAutoTrigger = autoTrigger
        let expectedTimeTrigger = timeTrigger
        let expectedStatus = status
        XCTAssertEqual(automaticSut.mode, .automatic)
        XCTAssertEqual(automaticSut.autoTrigger, expectedAutoTrigger)
        XCTAssertEqual(automaticSut.timeTrigger, expectedTimeTrigger)
        XCTAssertEqual(automaticSut.status, expectedStatus)
    }



    func testConstructor2 () {
        let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 2,
                                                                        lowerPowerLimit: 4,
                                                                        upperPowerLimit: 6,
                                                                        onTime: 8)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 1, minutes: 45)
        let status = SenecSocketSetting.SocketStatus(powerOn: true,
                                                     timeRemaining: 1)
        let timeSut = SenecSocketSetting(mode: .time,
                                         autoTrigger: autoTrigger,
                                         timeTrigger: timeTrigger,
                                         status: status)


        let expectedAutoTrigger = autoTrigger
        let expectedTimeTrigger = timeTrigger
        let expectedStatus = status
        XCTAssertEqual(timeSut.mode, .time)
        XCTAssertEqual(timeSut.autoTrigger, expectedAutoTrigger)
        XCTAssertEqual(timeSut.timeTrigger, expectedTimeTrigger)
        XCTAssertEqual(timeSut.status, expectedStatus)
    }



    func testConstructor3 () {
        let autoTrigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 1,
                                                                        lowerPowerLimit: 2,
                                                                        upperPowerLimit: 3,
                                                                        onTime: 4)
        let timeTrigger = SenecSocketSetting.TimeTrigger(hour: 6, minutes: 30)
        let status = SenecSocketSetting.SocketStatus(powerOn: true,
                                                     timeRemaining: 1)
        let offSut = SenecSocketSetting(mode: .off,
                                              autoTrigger: autoTrigger,
                                              timeTrigger: timeTrigger,
                                              status: status)


        let expectedAutoTrigger = autoTrigger
        let expectedTimeTrigger = timeTrigger
        let expectedStatus = status
        XCTAssertEqual(offSut.mode, .off)
        XCTAssertEqual(offSut.autoTrigger, expectedAutoTrigger)
        XCTAssertEqual(offSut.timeTrigger, expectedTimeTrigger)
        XCTAssertEqual(offSut.status, expectedStatus)
    }



    // MARK: - AutomaticSocketModeTrigger
    func testTriggerConstructor () {
        let trigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 1,
                                                                    lowerPowerLimit: 2,
                                                                    upperPowerLimit: 3,
                                                                    onTime: 4)
        XCTAssertEqual(trigger.minTime, 1)
        XCTAssertEqual(trigger.lowerPowerLimit, 2)
        XCTAssertEqual(trigger.upperPowerLimit, 3)
        XCTAssertEqual(trigger.onTime, 4)
    }



    func testTriggerConstructor1 () {
        let trigger = SenecSocketSetting.AutomaticSocketModeTrigger(minTime: 10,
                                                                    lowerPowerLimit: 20,
                                                                    upperPowerLimit: 30,
                                                                    onTime: 40)
        XCTAssertEqual(trigger.minTime, 10)
        XCTAssertEqual(trigger.lowerPowerLimit, 20)
        XCTAssertEqual(trigger.upperPowerLimit, 30)
        XCTAssertEqual(trigger.onTime, 40)
    }



    // MARK: - TimeTrigger
    func testTimeTriggerConstructor () {
        let trigger = SenecSocketSetting.TimeTrigger(hour: 1, minutes: 2)
        XCTAssertEqual(trigger.hour, 1)
        XCTAssertEqual(trigger.minutes, 2)
    }



    func testTimeTriggerConstructor2 () {
        let trigger = SenecSocketSetting.TimeTrigger(hour: 3, minutes: 4)
        XCTAssertEqual(trigger.hour, 3)
        XCTAssertEqual(trigger.minutes, 4)
    }



    // MARK: - SocketStatus
    func testSocketStatusConstructor () {
        let status = SenecSocketSetting.SocketStatus(powerOn: true, timeRemaining: 100)
        XCTAssertEqual(status.powerOn, true)
        XCTAssertEqual(status.timeRemaining, 100)
    }



    func testSocketStatusConstructor1 () {
        let status = SenecSocketSetting.SocketStatus(powerOn: false, timeRemaining: 0)
        XCTAssertEqual(status.powerOn, false)
        XCTAssertEqual(status.timeRemaining, 0)
    }

}
