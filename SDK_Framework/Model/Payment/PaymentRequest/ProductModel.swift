//
//  ProductModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a product included in the payment request.
public struct ProductModel: Codable {
    
    /// Name of the product.
    public let name: String?
    /// Description of the product.
    public let description: String?
    /// Price of the product.
    public let price: Double?
    /// Quantity of the product.
    public let quantity: Double?

    /// Initializes a new instance of `ProductModel`.
    /// - Parameters:
    ///   - name: Name of the product.
    ///   - description: Description of the product.
    ///   - price: Price of the product.
    ///   - quantity: Quantity of the product.
    public init(name: String? = nil, description: String? = nil, price: Double? = nil, quantity: Double? = nil) {
        self.name = name
        self.description = description
        self.price = price
        self.quantity = quantity
    }
}
