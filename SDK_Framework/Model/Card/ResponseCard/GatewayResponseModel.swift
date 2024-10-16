//
//  GatewayResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a response from the gateway.
public struct GatewayResponseModel: Codable {
    
    /// The gateway code associated with this response.
    public let gatewayCode: String?
    
    /// Coding keys to map the JSON keys to the properties.
    enum CodingKeys: String, CodingKey {
        case gatewayCode
    }
    
    /// Initializes a new instance of `GatewayResponse`.
    /// - Parameter gatewayCode: The gateway code associated with this response.
    public init(gatewayCode: String? = nil) {
        self.gatewayCode = gatewayCode
    }
}
