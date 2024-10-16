//
//  CustomerTokenResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents the response after generating a token for a customer.
public struct CustomerTokenResponseModel: Codable {
    
    /// A boolean indicating the success or failure of the token generation.
    public var status: Bool?
    /// A message providing additional information about the status.
    public var message: String?
    /// Contains additional data, such as the generated token details.
    public var data: TokenDataModel?
    
    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    public init(status: Bool? = nil, message: String? = nil, data: TokenDataModel? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

/// Contains the data for a generated customer token.
public struct TokenDataModel: Codable {
    
    /// A unique token associated with the customer.
    public var customerUniqueToken: Int?
    
    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case customerUniqueToken
    }
    
    public init(customerUniqueToken: Int? = nil) {
        self.customerUniqueToken = customerUniqueToken
    }
}
