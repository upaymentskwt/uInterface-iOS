//
//  PaymentCard.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a card that can be used for payments, such as a credit or debit card.
/// This class stores essential information about the card including its number, expiration date, brand, and optionally the card issuer.
public class PaymentCardModel: NSObject, Codable {

    /// The card number. It is usually a string of digits.
    final public let number: String
    
    /// The card's expiration month as a two-digit string (e.g., "03" for March).
    final public let expiryMonth: String
    
    /// The card's expiration year as a four-digit string (e.g., "2024").
    final public let expiryYear: String
    
    /// The brand of the card (e.g., Visa, Mastercard).
    final public let brand: String
    
    /// The issuer of the card, such as a bank or financial institution. This is optional.
    final public let issuer: String?

    /// Initializes a new `PaymentCard` instance with the provided card details.
    /// - Parameters:
    ///   - cardNumber: The card number as a string.
    ///   - expirationMonth: The two-digit expiration month as a string.
    ///   - expirationYear: The four-digit expiration year as a string.
    ///   - brand: The brand of the card (e.g., Visa).
    ///   - issuer: The optional issuer of the card.
    public init(cardNumber: String, expirationMonth: String, expirationYear: String, brandName: String, issuer: String? = nil) {
        self.number = cardNumber
        self.expiryMonth = expirationMonth
        self.expiryYear = expirationYear
        self.brand = brandName
        self.issuer = issuer
    }
}
