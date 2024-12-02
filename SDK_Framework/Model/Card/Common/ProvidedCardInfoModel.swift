//
//  ProvidedCardInfo.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the provided card information.
public struct ProvidedCardInfoModel: Codable {
    
    /// The card associated with this information.
    public let cardTransaction: CardTransactionModel?
    
    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case cardTransaction = "card"
    }
    
    /// Initializes a new instance of `ProvidedCardInfo`.
    /// - Parameter cardTransaction: The card associated with this information.
    public init(cardTransaction: CardTransactionModel? = nil) {
        self.cardTransaction = cardTransaction
    }
}
