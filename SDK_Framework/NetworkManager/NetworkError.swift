//
//  NetworkError.swift
//  uInterfaceSDK
//
//  Created by user on 21/08/24.
//

import Foundation

/// Represents a network error, containing the reason and the HTTP status code.
public struct NetworkError: Error {
    public let reason: String?
    public let httpStatusCode: Int?
    
    /// Initializes a `NetworkError`.
    ///
    /// - Parameters:
    ///   - reason: Optional string describing the reason for the error.
    ///   - httpStatusCode: Optional HTTP status code related to the error.
    public init(reason: String? = nil, httpStatusCode: Int? = nil) {
        self.reason = reason
        self.httpStatusCode = httpStatusCode
    }
}
