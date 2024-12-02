//
//  CustomerTokenRequestModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents a request to generate a token for a customer.
public struct CustomerTokenRequestModel: Codable {
    
    /// A unique token associated with the customer, used for authentication or identification.
    public var customerUniqueToken: String?
    
    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case customerUniqueToken
    }
    
    public init(customerUniqueToken: String? = nil) {
        self.customerUniqueToken = customerUniqueToken
    }
}
