//
//  TokenModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing various tokens used for authentication and identification.
/// This structure includes different types of tokens that may be required for interactions with a system, such as authentication or payment tokens.
public struct TokenModel: Codable {
    
    /// A token used for fast operations or special features.
    public let fastToken: String?

    /// A token associated with credit card transactions.
    public let creditCard: String?

    /// A unique token for identifying the customer.
    public let customerUniqueToken: String?
    
    enum CodingKeys: String, CodingKey {
        case fastToken = "kFast"
        case creditCard
        case customerUniqueToken
    }

    /// Initializes a new instance of `TokenModel`.
    ///
    /// - Parameters:
    ///   - fastToken: An optional token for fast operations.
    ///   - creditCardToken: An optional token associated with credit card transactions.
    ///   - customerUniqueToken: An optional unique token for the customer.
    public init(fastToken: String? = nil, creditCard: String? = nil, customerUniqueToken: String? = nil) {
        self.fastToken = fastToken
        self.creditCard = creditCard
        self.customerUniqueToken = customerUniqueToken
    }
}
