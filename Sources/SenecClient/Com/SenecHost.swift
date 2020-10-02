//
//  SenecHost.swift
//  SenecClient
//
//  Created by André Rohrbeck on 26.12.18.
//

import Foundation



public typealias Completion<T> = (Result<T>) -> Void

public typealias Request<T> = (@escaping Completion<T>) -> Void


/// A type representing an individual SenecHost.
///
/// A Senec-operated system is normally connected to the Internet and is thus
/// reachable either directly (in the local networ) or remotely (through the
/// "mein-senec.de" Website.
///
/// The operation mode is of course completely different, but a client is usually
/// always interested in the same things. Thus this protocol defines a
/// client-oriented interface, which can be implement for different connection modes.
/// Additionally this keeps the client interface agnostic of the Senec system and
/// it makes it possible to replace the Senec system by a mock to test the application
/// without actual internet connection.
///
/// As one `SenecHost` is representing exactly one Senec system it must be implemented
/// as a class to enable blocking access to the resource.
///
/// - Author: André Rohrbeck
/// - Copyright: André Rohrbeck © 2018
/// - Date: 2018-12-26
public protocol SenecHost: AnyObject {

    var energyRequestHandler: RequestHandler<SenecEnergyFlow> { get set }
    var socketRequestHandler: RequestHandler<SenecSockets> { get set }
    var statisticRequestHandler: RequestHandler<SenecEnergyStatistic> { get set }

//    var gettingEnergyFlow: Bool {get set}
//
//    var gettingEnergyFlowStopped: Bool {get set}

    /// Initializes a SenecHost for a given `url`.
    init(url: URL)


    // MARK: Getting Information once.
    /// Gets the energy flow once from the `SenecHost`.
    ///
    /// The call is asynchronous and returns with a `completion` handler, which
    /// wraps a
    func getEnergyFlow(completion: @escaping Completion<SenecEnergyFlow>)



    func getSocketSetting(completion: @escaping Completion<SenecSockets>)
}



public extension SenecHost {
    func startGettingEnergyFlow(every seconds: Double, completion: @escaping Completion<SenecEnergyFlow>) {
        energyRequestHandler.startRequest(every: seconds, completion: completion)
    }



    func stopGettingEnergyFlow() {
        energyRequestHandler.stopRequest()
    }



    func startGettingSocketSettings(every seconds: Double, completion: @escaping Completion<SenecSockets>) {
        socketRequestHandler.startRequest(every: seconds, completion: completion)
    }



    func stopGettingSocketSettings() {
        socketRequestHandler.stopRequest()
    }



    func startGettingEnergyStatistic(every seconds: Double, completion: @escaping Completion<SenecEnergyStatistic>) {
        statisticRequestHandler.startRequest(every: seconds, completion: completion)
    }



    func stopGettingEnergyStatistic() {
        statisticRequestHandler.stopRequest()
    }
}



/// A type wrapping the handling of a request to the network, which shall be repeatedly executed.

public final class RequestHandler<T> {
    public var request: Request<T>?

    /// Whether the request is currently executed or not.
    private var requesting = false

    /// Whether the request is cancelled.
    ///
    /// If the request is cancelled, the request isn't executed anymore.
    private var requestCancelled = false



    public func startRequest(every seconds: Double, completion: @escaping Completion<T>) {
        guard let myRequest = request else {
            NSLog("Request function was not yet set."); return
        }
        requestCancelled = false
        requesting = true
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            myRequest {result in
                guard let myself = self else { return }
                DispatchQueue.main.async {
                    myRequest(completion)
                }
                if myself.requestCancelled {
                    myself.requesting = false
                } else {
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + seconds) {[weak self] in
                        self?.startRequest(every: seconds, completion: completion)
                    }
                }
            }
        }
    }


    public func stopRequest() {
        requestCancelled = true
    }
}
