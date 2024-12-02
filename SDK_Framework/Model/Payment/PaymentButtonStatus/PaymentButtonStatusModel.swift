//
//  PaymentButtonStatusModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// A response model that represents the status of payment buttons.
/// This structure conforms to the `Codable` protocol, allowing it to be easily encoded and decoded from JSON data.
public struct PaymentButtonStatusModel: Codable {
    
    /// A boolean indicating the overall status of the payment buttons (e.g., whether the buttons are enabled or disabled).
    public let status: Bool?
    
    /// A message providing additional information about the status of the payment buttons.
    public let message: String?
    
    /// Data containing the status of individual payment buttons.
    public let paymentButtonData: PaymentButtonDataModel?
    
    // Coding keys to map the JSON keys with the struct properties
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case paymentButtonData = "data"
    }
    
    /// Initializes a new instance of `PaymentButtonStatusResponse`.
    /// - Parameters:
    ///   - status: The overall status of the payment buttons.
    ///   - message: A message providing additional information.
    ///   - data: Data containing the status of individual payment buttons.
    public init(status: Bool? = nil, message: String? = nil, paymentButtonData: PaymentButtonDataModel? = nil) {
        self.status = status
        self.message = message
        self.paymentButtonData = paymentButtonData
    }
}
