//
//  PaymentResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A response structure representing the result of a payment operation.
public struct PaymentResponseModel: Codable {
    
    /// Indicates whether the payment operation was successful.
    public var isSuccess: Bool?
    
    /// A message providing additional information about the payment status.
    public var statusMessage: String?
    
    /// Detailed data related to the payment, including payment link and tracking information.
    public var paymentDetailsModel: PaymentDetailsModel?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "status"
        case statusMessage = "message"
        case paymentDetailsModel = "data"
    }
    
    /// Initializes a new instance of `PaymentResponseModel`.
    /// - Parameters:
    ///   - isSuccess: Indicates the success of the payment operation.
    ///   - statusMessage: Provides additional information about the payment status.
    ///   - paymentDetailsModel: Contains the detailed payment information.
    public init(isSuccess: Bool? = nil, statusMessage: String? = nil, paymentDetailsModel: PaymentDetailsModel? = nil) {
        self.isSuccess = isSuccess
        self.statusMessage = statusMessage
        self.paymentDetailsModel = paymentDetailsModel
    }
}
