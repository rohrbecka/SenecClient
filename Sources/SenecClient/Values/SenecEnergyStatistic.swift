//
//  SenecEnergyStatistic.swift
//  SenecClient
//
//  Created by André Rohrbeck on 15.10.18.
//

import Foundation


/// The statistics regarding energy creation and consumption within a Senec System.
///
/// YES. I know, there is no such thing as energy creation :-)
///
/// - Author: André Rohrbeck
/// - Copyright: PROSE Berlin GmbH
/// - Date: 2018-10-15
public struct SenecEnergyStatistic: Codable {

    /// The energy created in this period by the photovoltaic cells in kWh.
    public let photovoltaicEnergy: Double

    /// The energy consumed by the house within this period in kWh.
    public let houseConsumption: Double

    /// The energy charged into the battery in kWh.
    public let batteryCharge: Double

    /// The energy gotten from the battery in kWn.
    public let batteryDischarge: Double

    /// The energy gotten from the grid in kWh.
    public let gridImport: Double

    /// The energy exported to the grid in kWh.
    public let gridExport: Double


    /// Default constructor.
    ///
    /// - Parameter photovoltaicEnergy: Energy produced by the photovoltaic cells in kWh.
    /// - Parameter houseConsumption: Energy consumed by the house in kWh.
    /// - Parameter batteryCharge: Energy charged into the battery in kWh.
    /// - Parameter batteryDischarge: Energy gotten from the battery in kWh.
    /// - Parameter gridImport: Energy gotten from the grid in kWh.
    /// - Parameter gridExport: Energy uploaded into the grid in kWh.
    public init(photovoltaicEnergy: Double,
                houseConsumption: Double,
                batteryCharge: Double,
                batteryDischarge: Double,
                gridImport: Double,
                gridExport: Double) {
        self.photovoltaicEnergy = photovoltaicEnergy
        self.houseConsumption = houseConsumption
        self.batteryCharge = batteryCharge
        self.batteryDischarge = batteryDischarge
        self.gridImport = gridImport
        self.gridExport = gridExport
    }


    // MARK: - Decodable protocol
    public init(from decoder: Decoder) throws {
        do {
            let jsonStatistic = try JSONEnergyStatistic(from: decoder)

            photovoltaicEnergy = SenecValue(string: jsonStatistic.values.photovoltaicEnergyString)?.doubleValue ?? 0.0
            houseConsumption = SenecValue(string: jsonStatistic.values.houseConsumptionString)?.doubleValue ?? 0.0
            batteryCharge = SenecValue(string: jsonStatistic.values.batteryChargeString)?.doubleValue ?? 0.0
            batteryDischarge = SenecValue(string: jsonStatistic.values.batteryDischargeString)?.doubleValue ?? 0.0
            gridImport = SenecValue(string: jsonStatistic.values.gridImportString)?.doubleValue ?? 0.0
            gridExport = SenecValue(string: jsonStatistic.values.gridExportString)?.doubleValue ?? 0.0
        } catch {
            throw error
        }
    }
}



// MARK: - Inner Type for decoding / encoding
internal struct JSONEnergyStatistic: Codable, Equatable {
    fileprivate let values: JSONEnergyStatisticValues

    public enum CodingKeys: String, CodingKey {
        case values = "STATISTIC"
    }

    public init() {
        values = JSONEnergyStatisticValues(photovoltaicEnergyString: "",
                                           houseConsumptionString: "",
                                           batteryChargeString: "",
                                           batteryDischargeString: "",
                                           gridImportString: "",
                                           gridExportString: "")
    }
}



private struct JSONEnergyStatisticValues: Codable, Equatable {
    let photovoltaicEnergyString: String
    let houseConsumptionString: String
    let batteryChargeString: String
    let batteryDischargeString: String
    let gridImportString: String
    let gridExportString: String

    enum CodingKeys: String, CodingKey {
        case photovoltaicEnergyString = "STAT_DAY_E_PV"
        case houseConsumptionString = "STAT_DAY_E_HOUSE"
        case batteryChargeString = "STAT_DAY_BAT_CHARGE"
        case batteryDischargeString = "STAT_DAY_BAT_DISCHARGE"
        case gridImportString = "STAT_DAY_E_GRID_IMPORT"
        case gridExportString = "STAT_DAY_E_GRID_EXPORT"
    }
}
