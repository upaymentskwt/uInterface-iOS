//
//  PaymentGatewayModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents information about the payment gateway used in the request.
public struct PaymentGatewayModel: Codable {
    
    /// Source or identifier of the payment gateway.
    public let src: String?

    public init(src: String? = nil) {
        self.src = src
    }
}
