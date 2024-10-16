//
//  PaymentStatusModels.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the response received after checking the payment status.
public struct PaymentStatusResponseModel: Codable {
    
    /// Indicates whether the payment was successful.
    public let status: Bool?
    /// A message providing additional details about the payment status.
    public let message: String?
    /// Contains detailed data related to the payment status.
    public let data: PaymentStatusDataModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    /// Initializes a new instance of `PaymentStatusResponseModel`.
    /// - Parameters:
    ///   - status: The status of the payment.
    ///   - message: Additional message about the payment.
    ///   - data: Detailed data related to the payment.
    public init(status: Bool? = nil, message: String? = nil, data: PaymentStatusDataModel? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}
