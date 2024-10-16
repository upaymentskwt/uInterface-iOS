//
//  CardDataResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents data that contains card information.
public struct CardDataResponseModel: Codable {
    
    /// The card data associated with this response.
    public let cardInfo: CardInfoModel?
    
    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case cardInfo = "cardData"
    }
    
    /// Initializes a new instance of `CardDataResponse`.
    /// - Parameter cardData: The card data associated with this response.
    public init(cardInfo: CardInfoModel? = nil) {
        self.cardInfo = cardInfo
    }
}
