//
//  CardDetailsModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the card details for adding a card.
public struct CardDetailsModel: Codable {
    
    /// The card number.
    public var cardNumber: String?
    /// The expiry details of the card.
    public var cardExpiryDetails: CardExpiryDetailsModel?
    /// The card's security code.
    public var securityCode: String?
    /// The name on the card.
    public var nameOnCard: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "number"
        case cardExpiryDetails = "expiry"
        case securityCode = "securityCode"
        case nameOnCard = "nameOnCard"
    }

    /// Initializes a new `CardDetailsModel` instance.
    /// - Parameters:
    ///   - cardNumber: The card number. Defaults to `nil`.
    ///   - expiryDetails: The expiry details of the card. Defaults to `nil`.
    ///   - securityCode: The card's security code. Defaults to `nil`.
    ///   - nameOnCard: The name on the card. Defaults to `nil`.
    public init(cardNumber: String? = nil, expiryDetails: CardExpiryDetailsModel? = nil, securityCode: String? = nil, nameOnCard: String? = nil) {
        self.cardNumber = cardNumber
        self.cardExpiryDetails = expiryDetails
        self.securityCode = securityCode
        self.nameOnCard = nameOnCard
    }
}
