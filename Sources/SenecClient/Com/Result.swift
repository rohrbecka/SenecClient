//
//  Result.swift
//  SenecClient
//
//  Created by André Rohrbeck on 28.12.18.
//

import Foundation


/// A wrapper for a result status, which can either be a `failure` wrapping an `Error`
/// or a `success` wrapping a `Value`.
public enum Result<Value> {
    /// The operation, which generated the `Result` failed with the given `Error`.
    case failure (Error)

    /// The operation, which generated the `Result` was successful and returned the `Value`.
    case success (Value)
}



extension Result where Value == Data {
    public func decode<T: Decodable>() -> Result<T> {
        let decoder = JSONDecoder()
        switch self {
        case .failure(let error):
            return Result<T>.failure(error)
        case .success(let data):
            if let newValue = try? decoder.decode(T.self, from: data) {
                return Result<T>.success(newValue)
            } else {
                return Result<T>.failure((NSError(domain: "", code: -1, userInfo: nil)))
            }
        }
    }
}
