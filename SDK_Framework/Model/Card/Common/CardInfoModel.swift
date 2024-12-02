//
//  File.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the information related to a card transaction or storage.
public struct CardInfoModel: Codable {

    /// The unique identifier for the repository.
    public let repositoryID: String?

    /// The response object containing transaction or validation details.
    public let response: GatewayResponseModel?

    /// The result of the card processing or validation.
    public let result: String?

    /// The source of funds used in the transaction.
    public let sourceOfFunds: SourceOfFundsInfoModel?

    /// The current status of the card or transaction.
    public let status: String?

    /// The token representing the card for security and processing.
    public let token: String?

    /// The usage details or purpose of the card.
    public let usage: CardUsageInfoModel?

    /// The strategy used for verifying the card or transaction.
    public let verificationStrategy: String?

    /// Initializes a new instance of `CardInfo`.
    ///
    /// - Parameters:
    ///   - repositoryID: The unique identifier for the repository.
    ///   - response: The response object containing transaction or validation details.
    ///   - result: The result of the card processing or validation.
    ///   - sourceOfFunds: The source of funds used in the transaction.
    ///   - status: The current status of the card or transaction.
    ///   - token: The token representing the card for security and processing.
    ///   - usage: The usage details or purpose of the card.
    ///   - verificationStrategy: The strategy used for verifying the card or transaction.
    public init(repositoryID: String? = nil, response: GatewayResponseModel? = nil, result: String? = nil, sourceOfFunds: SourceOfFundsInfoModel? = nil, status: String? = nil, token: String? = nil, usage: CardUsageInfoModel? = nil, verificationStrategy: String? = nil) {
        self.repositoryID = repositoryID
        self.response = response
        self.result = result
        self.sourceOfFunds = sourceOfFunds
        self.status = status
        self.token = token
        self.usage = usage
        self.verificationStrategy = verificationStrategy
    }

    enum CodingKeys: String, CodingKey {
        case repositoryID = "repositoryId"
        case response
        case result
        case sourceOfFunds
        case status
        case token
        case usage
        case verificationStrategy
    }
}
