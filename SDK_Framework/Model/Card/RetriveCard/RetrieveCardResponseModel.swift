//
//  File.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Response object for card retrieval request.
public struct RetrieveCardResponseModel: Codable {
        
    /// Indicates whether the request was successful.
    public let status: Bool?
    /// A message providing more information about the request.
    public let message: String?
    /// Additional data related to the card.
    public let data: CardDataModel?

    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    /// Initializes a new `RetrieveCardResponseModel` instance.
    /// - Parameters:
    ///   - status: Indicates whether the request was successful. Defaults to `nil`.
    ///   - message: A message providing more information about the request. Defaults to `nil`.
    ///   - data: Additional data related to the card. Defaults to `nil`.
    public init(status: Bool? = nil, message: String? = nil, data: CardDataModel? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}
