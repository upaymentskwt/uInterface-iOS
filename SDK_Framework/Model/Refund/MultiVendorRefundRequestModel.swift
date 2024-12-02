//
//  MultiVendorRefundRequestModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a request for a refund across multiple vendors.
/// This structure is used to encapsulate all necessary data when initiating a multi-vendor refund request.
public struct MultiVendorRefundRequest: Codable {
    
    /// More details related to each merchant involved in the refund.
    /// This array can be empty or nil if there are no additional details.
    public let merchantMoreDetailModel: [MerchantMoreDetailsModel]?
    
    enum CodingKeys: String, CodingKey {
        case merchantMoreDetailModel = "extraMerchantData"
    }
}

/// Represents additional data for a merchant involved in a refund.
/// This structure is used to hold details such as charges and IBAN numbers specific to a merchant.
public struct MerchantMoreDetailsModel: Codable {
    
    /// The amount to be refunded for this merchant.
    public let amount: Int?
    
    /// The charge amount associated with KNET transactions.
    public let kNetCharge: Int?
    
    /// The type of charge applied to the KNET transaction. It could be a percentage, fixed amount, etc.
    public let kNetChargeType: String?
    
    /// The charge amount associated with Credit Card transactions.
    public let ccCharge: Int?
    
    /// The type of charge applied to the Credit Card transaction. It could be a percentage, fixed amount, etc.
    public let ccChargeType: String?
    
    /// The IBAN number where the refund will be credited.
    public let iBanNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case kNetCharge = "knetCharge"
        case kNetChargeType = "knetChargeType"
        case ccCharge = "ccCharge"
        case ccChargeType = "ccChargeType"
        case iBanNumber = "ibanNumber"
    }
}
