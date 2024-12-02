//
//  CardDataModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// The main card data received in the response.
public struct CardDataModel: Codable {
    
    /// Array of the data related to cards
    public let customerCardsInfo: [CardInfoModel]?

    enum CodingKeys: String, CodingKey {
        case customerCardsInfo = "customerCards"
    }

    /// Initializes a new `CardDataModel` instance.
    /// - Parameters:
    ///   - customerCards: Array of customer cards available for the transaction.
    public init(customerCardsInfo: [CardInfoModel]? = nil) {
        self.customerCardsInfo = customerCardsInfo
    }
}
