//
//  File.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the expiry date of a card.
public struct CardExpiryDetailsModel: Codable {
    
    /// The month when the card expires (e.g., "08" for August).
    public var month: String?
    /// The year when the card expires (e.g., "2024").
    public var year: String?

    enum CodingKeys: String, CodingKey {
        case month
        case year
    }

    /// Initializes a new `CardExpiryDetailsModel` instance.
    /// - Parameters:
    ///   - month: The month of expiry. Defaults to `nil`.
    ///   - year: The year of expiry. Defaults to `nil`.
    public init(month: String? = nil, year: String? = nil) {
        self.month = month
        self.year = year
    }
}
