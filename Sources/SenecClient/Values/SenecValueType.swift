//
//  SenecValuePrefix.swift
//  SenecClient
//
//  Created by André Rohrbeck on 07.10.18.
//

import Foundation

/// The prefix in the String representation of a `SenecValue`.
///
/// - Author:       André Rohrbeck
/// - Copyright:    André Rohrbeck © 2018
/// - Date:         2018-10-07
internal enum SenecValueType: String, CaseIterable {
    /// Prefix for floating point value (32 bit) representations.
    case float = "fl_"
    /// Prefix for 8-bit unsigned integer representations.
    case uint8 = "u8_"
    /// Prefix for 16-bit unsigned integer representations.
    case uint16 = "u1_"
    /// Prefix for 32-bit unsigned integer representations.
    case uint32 = "u3_"
    /// Prefix for 64-bit unsigned integer representations.
    case uint64 = "u6_"
    /// Prefix for 8-bit signed integer representations.
    case int8 = "i8_"
    /// Prefix for 16-bit signed integer representations.
    case int16 = "i1_"
    /// Prefix for 32-bit signed integer representations.
    case int32 = "i3_"
    /// Prefix for 64-bit signed integer representations.
    case int64 = "i6_"
    /// Prefix for characters
    case char = "ch_"  // most likely, but no example found in Senec-Webservice
    /// Prefix for strings
    case string = "st_"    // most likely, but no example found in Senec-Webservice



    public init? (of string: String) {
        let allCases = SenecValueType.allCases
        let foundCases = allCases.filter { string.hasPrefix($0.rawValue) }
        guard let foundCase = foundCases.first else {
            return nil
        }
        self = foundCase
    }
}
