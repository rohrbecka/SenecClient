//
//  SenecEnergyFlowTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 08.10.18.
//

import XCTest
@testable import SenecClient


class SenecEnergyFlowTests: XCTestCase {

    func testDefaultConstructor() {
        let flow = SenecEnergyFlow (photovoltaicPowerGeneration: 3.0,
                                    batteryPowerFlow: 1.0,
                                    gridPowerFlow: 2.0,
                                    housePowerConsumption: 1.0,
                                    batteryStateOfCharge: 4.0)
        XCTAssertEqual(flow.photovoltaicPowerGeneration, 3.0)
        XCTAssertEqual(flow.batteryPowerFlow, 1.0)
        XCTAssertEqual(flow.gridPowerFlow, 2.0)
        XCTAssertEqual(flow.housePowerConsumption, 1.0)
        XCTAssertEqual(flow.batteryStateOfCharge, 1.0)


        let flow2 = SenecEnergyFlow (photovoltaicPowerGeneration: 3.0,
                                    batteryPowerFlow: 1.0,
                                    gridPowerFlow: 2.0,
                                    housePowerConsumption: 1.0,
                                    batteryStateOfCharge: 0.75)
        XCTAssertEqual(flow2.photovoltaicPowerGeneration, 3.0)
        XCTAssertEqual(flow2.batteryPowerFlow, 1.0)
        XCTAssertEqual(flow2.gridPowerFlow, 2.0)
        XCTAssertEqual(flow2.housePowerConsumption, 1.0)
        XCTAssertEqual(flow2.batteryStateOfCharge, 0.75)


        let flow3 = SenecEnergyFlow (photovoltaicPowerGeneration: 4.0,
                                     batteryPowerFlow: -2.0,
                                     gridPowerFlow: -1.0,
                                     housePowerConsumption: 7.0,
                                     batteryStateOfCharge: -1.0)
        XCTAssertEqual(flow3.photovoltaicPowerGeneration, 4.0)
        XCTAssertEqual(flow3.batteryPowerFlow, -2.0)
        XCTAssertEqual(flow3.gridPowerFlow, -1.0)
        XCTAssertEqual(flow3.housePowerConsumption, 7.0)
        XCTAssertEqual(flow3.batteryStateOfCharge, 0.0)
    }



    func testBatteryChargingAndDischargingPower () {
        let chargingBatteryFlow1 = SenecEnergyFlow (photovoltaicPowerGeneration: 6.0,
                                                    batteryPowerFlow: 5.0,
                                                    gridPowerFlow: 0.0,
                                                    housePowerConsumption: 1.0,
                                                    batteryStateOfCharge: 80.0)
        let chargingBatteryFlow2 = SenecEnergyFlow (photovoltaicPowerGeneration: 4.0,
                                                    batteryPowerFlow: 3.0,
                                                    gridPowerFlow: 0.0,
                                                    housePowerConsumption: 1.0,
                                                    batteryStateOfCharge: 80.0)
        let dischargingBatteryFlow1 = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                                       batteryPowerFlow: -3.0,
                                                       gridPowerFlow: 0.0,
                                                       housePowerConsumption: 3.0,
                                                       batteryStateOfCharge: 80.0)
        let dischargingBatteryFlow2 = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                                       batteryPowerFlow: -5.0,
                                                       gridPowerFlow: 1.0,
                                                       housePowerConsumption: 6.0,
                                                       batteryStateOfCharge: 80.0)

        // Assertions regarding charging power
        XCTAssertEqual(chargingBatteryFlow1.batteryChargingPower, 5.0)
        XCTAssertEqual(chargingBatteryFlow2.batteryChargingPower, 3.0)
        XCTAssertEqual(dischargingBatteryFlow1.batteryChargingPower, 0.0)
        XCTAssertEqual(dischargingBatteryFlow2.batteryChargingPower, 0.0)

        // Assertions regarding discharging power
        XCTAssertEqual(chargingBatteryFlow1.batteryDischargingPower, 0.0)
        XCTAssertEqual(chargingBatteryFlow2.batteryDischargingPower, 0.0)
        XCTAssertEqual(dischargingBatteryFlow1.batteryDischargingPower, 3.0)
        XCTAssertEqual(dischargingBatteryFlow2.batteryDischargingPower, 5.0)
    }



    func testGridFlow () {
        let toGridFlow1 = SenecEnergyFlow (photovoltaicPowerGeneration: 6.0,
                                                    batteryPowerFlow: 2.0,
                                                    gridPowerFlow: -3.0,
                                                    housePowerConsumption: 1.0,
                                                    batteryStateOfCharge: 80.0)
        let toGridFlow2 = SenecEnergyFlow (photovoltaicPowerGeneration: 4.0,
                                                    batteryPowerFlow: 1.0,
                                                    gridPowerFlow: -2.0,
                                                    housePowerConsumption: 1.0,
                                                    batteryStateOfCharge: 80.0)
        let fromGridFlow1 = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                                       batteryPowerFlow: 0.0,
                                                       gridPowerFlow: 3.0,
                                                       housePowerConsumption: 3.0,
                                                       batteryStateOfCharge: 80.0)
        let fromGridFlow2 = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                                       batteryPowerFlow: 0.0,
                                                       gridPowerFlow: 1.0,
                                                       housePowerConsumption: 1.0,
                                                       batteryStateOfCharge: 80.0)

        // Assertions regarding charging power
        XCTAssertEqual(toGridFlow1.gridUpPower, 3.0)
        XCTAssertEqual(toGridFlow2.gridUpPower, 2.0)
        XCTAssertEqual(fromGridFlow1.gridUpPower, 0.0)
        XCTAssertEqual(fromGridFlow2.gridUpPower, 0.0)

        // Assertions regarding discharging power
        XCTAssertEqual(toGridFlow1.gridDownPower, 0.0)
        XCTAssertEqual(toGridFlow2.gridDownPower, 0.0)
        XCTAssertEqual(fromGridFlow1.gridDownPower, 3.0)
        XCTAssertEqual(fromGridFlow2.gridDownPower, 1.0)
    }



    // MARK: - Scenario Testing
    func testScenario_PhotoVoltaicPowersHouse () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 4.5,
                                   batteryPowerFlow: 0.0,
                                   gridPowerFlow: 0.0,
                                   housePowerConsumption: 4.5,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 0.0)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 4.5)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 0.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_PhotovoltaicPowersHouseAndChargesBattery () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 4.0,
                                   batteryPowerFlow: 1.0,
                                   gridPowerFlow: 0.0,
                                   housePowerConsumption: 3.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 1.0)
        XCTAssertEqual(sut.batteryDischargingPower, 0.0)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 3.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 1.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 0.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_PhotovoltaicPowersHouseChargesBatteryAndSendsToGrid () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 6.5,
                                   batteryPowerFlow: 2.0,
                                   gridPowerFlow: -1.5,
                                   housePowerConsumption: 3.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 2.0)
        XCTAssertEqual(sut.batteryDischargingPower, 0.0)
        XCTAssertEqual(sut.gridUpPower, 1.5)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 3.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 2.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 1.5)
        XCTAssertEqual(sut.batteryToHousePower, 0.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_PhotovoltaicPowersHouseChargesBatteryAndFetchesFromGridToChargeBattery () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 6.5,
                                   batteryPowerFlow: 2.0,
                                   gridPowerFlow: 0.5,
                                   housePowerConsumption: 5.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 2.0)
        XCTAssertEqual(sut.batteryDischargingPower, 0.0)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.5)
        XCTAssertEqual(sut.photovoltaicToHousePower, 5.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 1.5)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 0.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.5)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_HouseConsumesPhotovoltaicAndBattery () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 0.5,
                                   batteryPowerFlow: -2.0,
                                   gridPowerFlow: 0.0,
                                   housePowerConsumption: 2.5,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 2.0)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 0.5)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 2.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_HouseConsumesBattery () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                   batteryPowerFlow: -1.0,
                                   gridPowerFlow: 0.0,
                                   housePowerConsumption: 1.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 1.0)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 0.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 1.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_HouseConsumesBatteryAndGrid () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                   batteryPowerFlow: -2.5,
                                   gridPowerFlow: 0.5,
                                   housePowerConsumption: 3.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 2.5)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 0.5)
        XCTAssertEqual(sut.photovoltaicToHousePower, 0.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 2.5)
        XCTAssertEqual(sut.gridToHousePower, 0.5)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_HouseConsumesBatteryGridAndPhotovoltaic () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 0.5,
                                   batteryPowerFlow: -2.5,
                                   gridPowerFlow: 1.5,
                                   housePowerConsumption: 4.5,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 2.5)
        XCTAssertEqual(sut.gridUpPower, 0.0)
        XCTAssertEqual(sut.gridDownPower, 1.5)
        XCTAssertEqual(sut.photovoltaicToHousePower, 0.5)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 2.5)
        XCTAssertEqual(sut.gridToHousePower, 1.5)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.0)
    }



    func testScenario_HouseConsumesBatteryAndBatterySendsToGrid () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 0.0,
                                   batteryPowerFlow: -2.5,
                                   gridPowerFlow: -0.5,
                                   housePowerConsumption: 2.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 2.5)
        XCTAssertEqual(sut.gridUpPower, 0.5)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 0.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 2.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.5)
    }



    func testScenario_HouseConsumesBatteryAndPhotovoltaicAndBatterySendsToGrid () {
        let sut = SenecEnergyFlow (photovoltaicPowerGeneration: 1.0,
                                   batteryPowerFlow: -2.5,
                                   gridPowerFlow: -0.5,
                                   housePowerConsumption: 3.0,
                                   batteryStateOfCharge: 80.0)
        XCTAssertEqual(sut.batteryChargingPower, 0.0)
        XCTAssertEqual(sut.batteryDischargingPower, 2.5)
        XCTAssertEqual(sut.gridUpPower, 0.5)
        XCTAssertEqual(sut.gridDownPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToHousePower, 1.0)
        XCTAssertEqual(sut.photovoltaicToBatteryPower, 0.0)
        XCTAssertEqual(sut.photovoltaicToGridPower, 0.0)
        XCTAssertEqual(sut.batteryToHousePower, 2.0)
        XCTAssertEqual(sut.gridToHousePower, 0.0)
        XCTAssertEqual(sut.gridToBatteryPower, 0.0)
        XCTAssertEqual(sut.batteryToGridPower, 0.5)
    }
}



// MARK: - Codable Tests
extension SenecEnergyFlowTests {
    func testDecoding () {
        let jsonString = """
        {"ENERGY":{
            "STAT_STATE": "u8_10",
            "STAT_STATE_DECODE": "u8_10",
            "GUI_BAT_DATA_POWER": "fl_C3FF68B3",
            "GUI_INVERTER_POWER": "fl_40652F1B",
            "GUI_HOUSE_POW": "fl_43F59E76",
            "GUI_GRID_POW": "fl_C19CA3D7",
            "STAT_MAINT_REQUIRED": "u8_00",
            "GUI_BAT_DATA_FUEL_CHARGE": "fl_4287A5E4",
            "GUI_CHARGING_INFO": "u8_00",
            "GUI_BOOSTING_INFO": "u8_01"
        }}
        """

        guard let sut = decode (SenecEnergyFlow.self, json: jsonString) else {
            XCTFail("JSON decoding failed."); return
        }

        XCTAssertEqual(sut.photovoltaicPowerGeneration, 3.581000, accuracy: 0.001)
        XCTAssertEqual(sut.batteryPowerFlow, -510.818, accuracy: 0.001)
        XCTAssertEqual(sut.gridPowerFlow, -19.580, accuracy: 0.001)
        XCTAssertEqual(sut.housePowerConsumption, 491.238, accuracy: 0.001)
        XCTAssertEqual(sut.batteryStateOfCharge, 0.678, accuracy: 0.001)
    }


}
