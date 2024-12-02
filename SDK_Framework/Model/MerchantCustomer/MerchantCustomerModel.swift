//
//  MerchantCustomerModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents the relationship between a merchant and a customer.
public struct MerchantCustomerModel: Codable {
    
    /// A unique identifier for the merchant customer.
    public var merchantCustomerID: String?
    
    /// The identifier for the merchant.
    public var merchantID: Int?
    
    /// The date and time when the record was last updated.
    public var updatedAt: String?
    
    /// The date and time when the record was created.
    public var createdAt: String?
    
    /// A unique identifier for this record.
    public var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case merchantCustomerID = "merchant_customer_id"
        case merchantID = "merchant_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
