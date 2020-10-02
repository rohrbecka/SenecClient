//
//  SenecSocket.swift
//  SenecClient
//
//  Created by André Rohrbeck on 18.10.18.
//

import Foundation

/// The Settings for one Socket in a Senec System
///
/// Senec systems are able to handle to 'power sockets', which can be triggered
/// in dependency of the currently availabe photovoltaic power.
/// In fact the "outlets" are only relay triggers, which can swith a switchable
/// Outlet. One typical duty of these outlets are charging an electric vehicle or
/// Triggering a washing machine or a dishwasher.
///
/// - Author: André Rohrbeck
/// - Copyright: André ©Rohrbeck @ 2018
/// - Date: 2018-10-18
public struct SenecSocketSetting: Equatable {

    /// The mode in which a switchable socket in a Senec system is operated.
    public enum SocketMode {
        /// The socket is forcedly switched on.
        case forced
        /// The socket is triggered by the available photovoltaic power.
        case automatic
        /// The socket is activated at a certain time every day.
        case time
        /// The socket is not active.
        case off
    }



    /// The trigger parameters, controlling the triggering of a Senec socket according
    /// to the available photovoltaic power.
    public struct AutomaticSocketModeTrigger: Equatable {
        /// The minimum time through which the `minPower` must be freely available for the
        /// socket to be activated.
        public let minTime: Int // TODO: add unit information

        /// The minimum power, which ha to be surpassed for `minTime` for the socket to be activated.
        public let lowerPowerLimit: Int    // TODO: add unit information

        // TODO: add docoumentation according to "mein-senec"-website (not readable on mobile)
        public let upperPowerLimit: Int

        /// The time for which the socket remains activated after its activation.
        public let onTime: Int
    }



    public struct TimeTrigger: Equatable {
        public let hour: Int

        public let minutes: Int
    }



    /// The status of a socket controlled by the Senec System.
    public struct SocketStatus: Equatable {
        /// Whether the socket is activated (`true`) or not (`false`).
        public let powerOn: Bool

        /// The remaining time, during which the socket will be active.
        public let timeRemaining: Int
    }



    /// The mode (forced, off, automatic) in which the socket is currently operated.
    public let mode: SocketMode

    /// The trigger parameters, which are used, if the mode is `.automatic`.
    public let autoTrigger: AutomaticSocketModeTrigger

    /// The trigger parameters, which are used, if the mode is `.time`.
    public let timeTrigger: TimeTrigger

    /// The current status of the socket.
    public let status: SocketStatus
}
