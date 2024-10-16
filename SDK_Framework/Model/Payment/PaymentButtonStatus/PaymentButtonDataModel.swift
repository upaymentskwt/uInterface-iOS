//
//  PaymentButtonDataModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing the status of individual payment buttons.
/// This structure conforms to the `Codable` protocol for JSON encoding and decoding.
public struct PaymentButtonDataModel: Codable {
    
    /// A dictionary where the keys are payment button identifiers (e.g., button names) and the values are booleans indicating whether each button is enabled or disabled.
    public let payButtons: [String: Bool]?
    
    // Coding keys to map the JSON keys with the struct properties
    enum CodingKeys: String, CodingKey {
        case payButtons
    }
    
    /// Initializes a new instance of `PaymentButtonData`.
    /// - Parameter payButtons: A dictionary representing the status of individual payment buttons.
    public init(payButtons: [String: Bool]? = nil) {
        self.payButtons = payButtons
    }
}
