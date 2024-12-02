//
//  CardTransactionModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the details of a card.
public struct CardTransactionModel: Codable {
    
    /// The brand of the card (e.g., "Visa").
    public let brandName: String?
    /// The expiry date of the card.
    public let expiryDate: String?
    /// The funding method of the card (e.g., "credit").
    public let fundingMethod: String?
    /// The card number.
    public let cardNumber: String?
    /// The scheme of the card (e.g., "Visa").
    public let cardScheme: String?

    enum CodingKeys: String, CodingKey {
        case brandName = "brand"
        case expiryDate = "expiry"
        case fundingMethod = "fundingMethod"
        case cardNumber = "number"
        case cardScheme = "scheme"
    }

    /// Initializes a new `CardTransactionModel` instance.
    /// - Parameters:
    ///   - brandName: The brand of the card. Defaults to `nil`.
    ///   - expiryDate: The expiry date of the card. Defaults to `nil`.
    ///   - fundingMethod: The funding method of the card. Defaults to `nil`.
    ///   - cardNumber: The card number. Defaults to `nil`.
    ///   - cardScheme: The scheme of the card. Defaults to `nil`.
    public init(brand: String? = nil, expiry: String? = nil, fundingMethod: String? = nil, number: String? = nil, scheme: String? = nil) {
        self.brandName = brand
        self.expiryDate = expiry
        self.fundingMethod = fundingMethod
        self.cardNumber = number
        self.cardScheme = scheme
    }
}
