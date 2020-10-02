//
//  Requestable.swift
//  SenecClient
//
//  Created by André Rohrbeck on 21.10.18.
//

import Foundation



/// A protocol which should be implemented by value tyoes, which can be requested
/// from a Senec system.
public protocol Requestable {

    /// The URL request, which can be used to get the desired value.
    ///
    /// The request is expected to return (in case of success) the
    /// JSON data of the result
    static func request (url: URL) -> URLRequest
}
