//
//  File.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents additional merchant-specific data related to the payment request.
public struct MerchantMoreInfoModel: Codable {
    
    /// Amount for the extra charge.
    public let amount: Double?
    /// KNET charge amount, if any.
    public let kNetCharge: Double?
    /// Type of KNET charge.
    public let kNetChargeType: String?
    /// Credit card charge amount, if any.
    public let ccCharge: Double?
    /// Type of credit card charge.
    public let ccChargeType: String?
    /// IBAN number associated with the extra merchant data.
    public let iBanNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case amount
        case kNetCharge = "knetCharge"
        case kNetChargeType = "knetChargeType"
        case ccCharge
        case ccChargeType
        case iBanNumber = "ibanNumber"
    }
    
    /// Initializes a new instance of `MerchantMoreInfoModel`.
    /// - Parameters:
    ///   - amount: Amount for the extra charge.
    ///   - knetCharge: KNET charge amount, if any.
    ///   - knetChargeType: Type of KNET charge.
    ///   - ccCharge: Credit card charge amount, if any.
    ///   - ccChargeType: Type of credit card charge.
    ///   - ibanNumber: IBAN number associated with the extra merchant data.
    public init(amount: Double? = nil, knetCharge: Double? = nil, knetChargeType: String? = nil, ccCharge: Double? = nil, ccChargeType: String? = nil, ibanNumber: String? = nil) {
        self.amount = amount
        self.kNetCharge = knetCharge
        self.kNetChargeType = knetChargeType
        self.ccCharge = ccCharge
        self.ccChargeType = ccChargeType
        self.iBanNumber = ibanNumber
    }
}
