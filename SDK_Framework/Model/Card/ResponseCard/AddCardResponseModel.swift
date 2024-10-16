//
//  AddCardResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the response received after adding a card.
public struct AddCardResponseModel: Codable {
    
    /// Indicates whether the request was successful.
    public let status: Bool?
    /// A message providing more information about the request.
    public let message: String?
    /// Additional data related to the card.
    public let cardDataResponse: CardDataResponseModel?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case cardDataResponse = "data"
    }
    
    /// Initializes a new `AddCardResponse` instance.
    /// - Parameters:
    ///   - status: Indicates whether the request was successful. Defaults to `nil`.
    ///   - message: A message providing more information about the request. Defaults to `nil`.
    ///   - data: Additional data related to the card. Defaults to `nil`.
    public init(status: Bool? = nil, message: String? = nil, cardDataResponse: CardDataResponseModel? = nil) {
        self.status = status
        self.message = message
        self.cardDataResponse = cardDataResponse
    }
}
