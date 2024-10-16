//
//  OrderModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents order details in the payment request.
public struct OrderModel: Codable {
    
    /// Unique identifier for the order.
    public let orderId: String?
    /// Reference number for the order.
    public let reference: String?
    /// Description of the order.
    public let description: String?
    /// Currency used for the order.
    public let currency: String?
    /// Amount of money for the order.
    public let amount: Double?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "id"
        case reference
        case description
        case currency
        case amount
    }
    
    /// Initializes a new instance of `BrowserDetailsModel`.
    /// - Parameters:
    ///   - orderId: Unique identifier for the order.
    ///   - reference: Reference number for the order.
    ///   - description: Description of the order.
    ///   - currency: Currency used for the order.
    ///   - amount: Amount of money for the order.
    public init(orderId: String? = nil, reference: String? = nil, description: String? = nil, currency: String? = nil, amount: Double? = nil) {
        self.orderId = orderId
        self.reference = reference
        self.description = description
        self.currency = currency
        self.amount = amount
    }
}
