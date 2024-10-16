//
//  CardUsageInfoModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the usage information for the card.
public struct CardUsageInfoModel: Codable {
    
    /// The last date the card information was updated.
    public let lastUpdated: String?
    /// The last person who updated the card information.
    public let lastUpdatedBy: String?
    /// The last date the card was used.
    public let lastUsed: String?
    
    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case lastUpdated
        case lastUpdatedBy
        case lastUsed
    }
    
    /// Initializes a new instance of `CardUsageInfo`.
    /// - Parameters:
    ///   - lastUpdatedDate: The last date the card information was updated.
    ///   - lastUpdatedBy: The last person who updated the card information.
    ///   - lastUsed: The last date the card was used.
    public init(lastUpdated: String? = nil, lastUpdatedBy: String? = nil, lastUsed: String? = nil) {
        self.lastUpdated = lastUpdated
        self.lastUpdatedBy = lastUpdatedBy
        self.lastUsed = lastUsed
    }
}
