//
//  File.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a request to add a new card to the system.
public struct CardRequestModel: Codable {
    
    /// The card details to be added.
    public var cardDetails: CardDetailsModel?
    /// A unique token associated with the customer.
    public var customerUniqueToken: Int?

    enum CodingKeys: String, CodingKey {
        case cardDetails = "card"
        case customerUniqueToken = "customerUniqueToken"
    }

    /// Initializes a new `AddCardRequestModel` instance.
    /// - Parameters:
    ///   - card: The card details to be added. Defaults to `nil`.
    ///   - customerUniqueToken: A unique token associated with the customer. Defaults to `nil`.
    public init(cardDetails: CardDetailsModel? = nil, customerUniqueToken: Int? = nil) {
        self.cardDetails = cardDetails
        self.customerUniqueToken = customerUniqueToken
    }
}
