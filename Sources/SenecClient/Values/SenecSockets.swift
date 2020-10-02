//
//  SenecSockets.swift
//  SenecClient
//
//  Created by André Rohrbeck on 19.10.18.
//

import Foundation

public struct SenecSockets: Decodable {

    public let socketSettings: [SenecSocketSetting]



    public init (settings: [SenecSocketSetting]) {
        socketSettings = settings
    }



    public init(from decoder: Decoder) throws {
        let jsonEnergy = try JSONSocketsInformation(from: decoder)
        let jsonSockets = jsonEnergy.socketSettings

        let numberOfSockets = SenecValue(string: jsonSockets.numberOfSocketsString)?.intValue ?? 0

        var settings = [SenecSocketSetting]()
        for index in 0..<numberOfSockets {

            let socketSettings: SenecSocketSetting = {
                let autoTrigger: SenecSocketSetting.AutomaticSocketModeTrigger = {
                    let minTime = SenecValue(string: jsonSockets.minTimeStrings[index])?.intValue ?? 0
                    let lowerPowerLimit = SenecValue(string: jsonSockets.lowerPowerLimitStrings[index])?.intValue ?? 0
                    let upperPowerLimit = SenecValue(string: jsonSockets.upperPowerLimitStrings[index])?.intValue ?? 0
                    let onTime = SenecValue(string: jsonSockets.onTimeStrings[index])?.intValue ?? 0
                    return SenecSocketSetting.AutomaticSocketModeTrigger(minTime: minTime,
                                                                         lowerPowerLimit: lowerPowerLimit,
                                                                         upperPowerLimit: upperPowerLimit,
                                                                         onTime: onTime)
                }()

                let timeTrigger: SenecSocketSetting.TimeTrigger = {
                    let hour = SenecValue(string: jsonSockets.hourStrings[index])?.intValue ?? 0
                    let minutes = SenecValue(string: jsonSockets.minuteStrings[index])?.intValue ?? 0
                    return SenecSocketSetting.TimeTrigger(hour: hour, minutes: minutes)
                }()

                let status: SenecSocketSetting.SocketStatus = {
                    let powerOn = SenecValue(string: jsonSockets.statusOnStrings[index])?.boolValue ?? false
                    let timeRemaining = SenecValue(string: jsonSockets.timeRemainingStrings[index])?.intValue ?? 0
                    return SenecSocketSetting.SocketStatus(powerOn: powerOn, timeRemaining: timeRemaining)
                }()

                let mode: SenecSocketSetting.SocketMode = {
                    let forced = SenecValue(string: jsonSockets.forcedOnStrings[index])?.boolValue ?? false
                    let auto = SenecValue(string: jsonSockets.automaticOnStrings[index])?.boolValue ?? false
                    let time = SenecValue(string: jsonSockets.useTimeStrings[index])?.boolValue ?? false

                    if !forced && !auto && !time {
                        return .off
                    } else if forced {
                        return .forced
                    } else if time {
                        return .time
                    } else {
                        return .automatic
                    }
                }()

                return SenecSocketSetting(mode: mode,
                                          autoTrigger: autoTrigger,
                                          timeTrigger: timeTrigger,
                                          status: status)
            }()
            settings.append(socketSettings)
        }

        self.init(settings: settings)
    }


    public subscript (index: Int) -> SenecSocketSetting {
        return socketSettings[index]
    }

}



internal struct JSONSocketsInformation: Codable, Equatable {

    fileprivate let socketSettings: JSONSenecSocketSettings

    private enum CodingKeys: String, CodingKey {
        case socketSettings = "SOCKETS"
    }

    public init() {
        socketSettings = JSONSenecSocketSettings (numberOfSocketsString: "",
                                                  forcedOnStrings: [String](),
                                                  useTimeStrings: [String](),
                                                  automaticOnStrings: [String](),
                                                  upperPowerLimitStrings: [String](),
                                                  lowerPowerLimitStrings: [String](),
                                                  minTimeStrings: [String](),
                                                  onTimeStrings: [String](),
                                                  statusOnStrings: [String](),
                                                  timeRemainingStrings: [String](),
                                                  hourStrings: [String](),
                                                  minuteStrings: [String]())
    }
}


private struct JSONSenecSocketSettings: Codable, Equatable {
    let numberOfSocketsString: String
    let forcedOnStrings: [String]
    let useTimeStrings: [String]
    let automaticOnStrings: [String]
    let upperPowerLimitStrings: [String]
    let lowerPowerLimitStrings: [String]
    let minTimeStrings: [String]
    let onTimeStrings: [String]
    let statusOnStrings: [String]
    let timeRemainingStrings: [String]
    let hourStrings: [String]
    let minuteStrings: [String]

    enum CodingKeys: String, CodingKey {
        case numberOfSocketsString = "NUMBER_OF_SOCKETS"
        case forcedOnStrings = "FORCE_ON"
        case useTimeStrings = "USE_TIME"
        case automaticOnStrings = "ENABLE"
        case upperPowerLimitStrings = "UPPER_LIMIT"
        case lowerPowerLimitStrings = "LOWER_LIMIT"
        case minTimeStrings = "TIME_LIMIT"
        case onTimeStrings = "POWER_ON_TIME"
        case statusOnStrings = "POWER_ON"
        case timeRemainingStrings = "TIME_REM"
        case hourStrings = "SWITCH_ON_HOUR"
        case minuteStrings = "SWITCH_ON_MINUTE"
    }
}
