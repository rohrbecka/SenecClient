//
//  SenecEnergyStatisticTests.swift
//  SenecClientTests
//
//  Created by André Rohrbeck on 15.10.18.
//

import XCTest
@testable import SenecClient

class SenecEnergyStatisticTests: XCTestCase {

    func testConstructor () {
        let sut = SenecEnergyStatistic(photovoltaicEnergy: 1.0,
                                       houseConsumption: 2.0,
                                       batteryCharge: 3.0,
                                       batteryDischarge: 4.0,
                                       gridImport: 5.0,
                                       gridExport: 6.0)

        XCTAssertEqual(sut.photovoltaicEnergy, 1.0)
        XCTAssertEqual(sut.houseConsumption, 2.0)
        XCTAssertEqual(sut.batteryCharge, 3.0)
        XCTAssertEqual(sut.batteryDischarge, 4.0)
        XCTAssertEqual(sut.gridImport, 5.0)
        XCTAssertEqual(sut.gridExport, 6.0)
    }


    // MARK: Codable Tests
    func testDecoding () {
        let jsonString = """
        {
        "STATISTIC":
        {
        "STAT_DAY_E_HOUSE": "fl_41BE04C1",
        "STAT_DAY_E_PV": "fl_41F41699",
        "STAT_DAY_BAT_CHARGE": "fl_40F706C7",
        "STAT_DAY_BAT_DISCHARGE": "fl_40B2E822",
        "STAT_DAY_E_GRID_IMPORT": "fl_3E976083",
        "STAT_DAY_E_GRID_EXPORT": "fl_409DA112",
        "STAT_YEAR_E_PU1_ARR": [
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000",
            "u6_0000000000000000"
        ]
        }
        }
        """

        guard let sut = decode (SenecEnergyStatistic.self, json: jsonString) else {
            XCTFail("JSON decoding failed."); return
        }

        XCTAssertEqual(sut.photovoltaicEnergy, 30.511, accuracy: 0.001)
        XCTAssertEqual(sut.houseConsumption, 23.752, accuracy: 0.001)
        XCTAssertEqual(sut.batteryCharge, 7.720, accuracy: 0.001)
        XCTAssertEqual(sut.batteryDischarge, 5.591, accuracy: 0.001)
        XCTAssertEqual(sut.gridImport, 0.296, accuracy: 0.001)
        XCTAssertEqual(sut.gridExport, 4.926, accuracy: 0.001)
    }
}



// MARK: - Helpers
internal func decode<D: Decodable>(_ type: D.Type,
                                   json: String,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> D? {
    guard let jsonData = json.data(using: .utf8) else {
        XCTFail("Error in the Test JSON data.", file: file, line: line)
        return nil
    }

    do {
        let report = try JSONDecoder().decode(type, from: jsonData)
        return report
    } catch let error {
        print(error)
        XCTFail("Json decoding failed.", file: file, line: line)
        return nil
    }
}
