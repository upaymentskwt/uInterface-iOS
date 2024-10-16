//
//  SourceOfFundsInfoModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the source of funds information.
public struct SourceOfFundsInfoModel: Codable {
    
    /// The provided card information.
    public let providedCardInfoModel: ProvidedCardInfoModel?
    /// The type of the source of funds.
    public let fundType: String?
    
    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case providedCardInfoModel = "provided"
        case fundType = "type"
    }
    
    /// Initializes a new instance of `SourceOfFundsInfo`.
    /// - Parameters:
    ///   - providedCardInfo: The provided card information.
    ///   - fundType: The type of the source of funds.
    public init(providedCardInfoModel: ProvidedCardInfoModel? = nil, fundType: String? = nil) {
        self.providedCardInfoModel = providedCardInfoModel
        self.fundType = fundType
    }
}
