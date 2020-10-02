//
//  LocalSenecHost.swift
//  SenecClient
//
//  Created by André Rohrbeck on 26.12.18.
//

import Foundation

/// A Senec Host, which is reachable in the local area network.
///
/// - Author: André Rohrbeck
/// - Copyright: André Rohrbeck © 2018
/// - Date: 2018-12-26
public class LocalSenecHost: SenecHost {
    public var energyRequestHandler: RequestHandler<SenecEnergyFlow>

    public var socketRequestHandler: RequestHandler<SenecSockets>

    public var statisticRequestHandler: RequestHandler<SenecEnergyStatistic>

    public var gettingEnergyFlow: Bool = false

    public var gettingEnergyFlowStopped: Bool = false

    public private (set) var host: URL


    private var session: URLSession


    public required init(url: URL) {
        host = url
        session = URLSession(configuration: .default)
        energyRequestHandler = RequestHandler<SenecEnergyFlow>()
        socketRequestHandler = RequestHandler<SenecSockets>()
        statisticRequestHandler = RequestHandler<SenecEnergyStatistic>()
        energyRequestHandler.request = getEnergyFlow
        socketRequestHandler.request = getSocketSetting
        statisticRequestHandler.request = getEnergyStatistic
    }



    public func getEnergyFlow(completion: @escaping Completion<SenecEnergyFlow>) {
        let cgiURL = host.appendingPathComponent("lala.cgi")
        let request = SenecEnergyFlow.request(url: cgiURL)
        let task = session.task(with: request) { result in
            DispatchQueue.main.async {
                completion(result.decode())
            }
        }
        task.resume()
    }



    public func getSocketSetting(completion: @escaping Completion<SenecSockets>) {
        let cgiURL = host.appendingPathComponent("lala.cgi")
        let request = SenecSockets.request(url: cgiURL)
        let task = session.task(with: request) { result in
            DispatchQueue.main.async {
                completion(result.decode())
            }
        }
        task.resume()
    }



    public func getEnergyStatistic(completion: @escaping Completion<SenecEnergyStatistic>) {
        let cgiURL = host.appendingPathComponent("lala.cgi")
        let request = SenecEnergyStatistic.request(url: cgiURL)
        let task = session.task(with: request) { result in
            DispatchQueue.main.async {
                completion(result.decode())
            }
        }
        task.resume()
    }
}



public extension URLSession {
    func task(with request: URLRequest, completionHandler: @escaping Completion<Data> ) -> URLSessionDataTask {
        let task = dataTask(with: request) {data, response, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                } else {
                    completionHandler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
            }
            let result = Result<Data>.success(data)
            completionHandler(result)
        }
        return task
    }
}
