//
//  SenecCommunication.swift
//  SenecClient
//
//  Created by André Rohrbeck on 21.10.18.
//

import Foundation



extension SenecEnergyFlow: Requestable {
    public static func request(url: URL) -> URLRequest {
        return senecRequest(url: url, content: JSONEnergyFlow())
    }
}



extension SenecEnergyStatistic: Requestable {
    public static func request(url: URL) -> URLRequest {
        return senecRequest(url: url, content: JSONEnergyStatistic())
    }
}



extension SenecSockets: Requestable {
    public static func request(url: URL) -> URLRequest {
        /// Workaround as the request contains empty strings but the (properly decodable) reply
        /// contains Arrays. The arrays prevent the simple use of JsonEncoder"
        return senecRequest(url: url, string: "{\"ENERGY\":{\"ZERO_EXPORT\":\"\"},"
            + "\"SOCKETS\":{\"ENABLE\":\"\",\"USE_TIME\":\"\",\"FORCE_ON\":\"\",\"TIME_REM\":\"\",\"POWER_ON\":\"\","
            + "\"UPPER_LIMIT\":\"\",\"LOWER_LIMIT\":\"\",\"TIME_LIMIT\":\"\",\"POWER_ON_TIME\":\"\",\"PRIORITY\":\"\","
            + "\"SWITCH_ON_HOUR\":\"\",\"SWITCH_ON_MINUTE\":\"\",\"NUMBER_OF_SOCKETS\":\"\",\"ALREADY_SWITCHED\":\"\""
            + "}}")

        // End of workaround. The next return is not used at the moment:
        // return senecRequest(url: url, content: JSONSocketsInformation())
    }
}



/// Creates a URLRequest usable for requesting information from a Senec system.
///
/// The function fails, if the JSON encoding of `content` fails. This is considered
/// being a programmer error.
///
/// - Parameter url:     The URL from which to request the information
/// - Parameter content: The Senec Value, which serves as request.
private func senecRequest<T: Encodable>(url: URL, content: T) -> URLRequest {
    do {
        let data = try JSONEncoder().encode(content)
        return senecRequest(url: url, data: data)
    } catch let error {
        preconditionFailure("JSON encoding problem: " + error.localizedDescription)
    }
}



private func senecRequest(url: URL, data: Data) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content")

    request.httpBody = data

    return request
}



private func senecRequest(url: URL, string: String) -> URLRequest {
    guard let data = string.data(using: .utf8) else {
        preconditionFailure("String not convertible using UTF-8.")
    }
    return senecRequest(url: url, data: data)
}
