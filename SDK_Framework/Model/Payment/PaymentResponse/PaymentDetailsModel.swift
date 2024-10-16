//
//  PaymentDetailsModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A structure representing detailed information about a payment.
public struct PaymentDetailsModel: Codable {
    
    /// The URL link for completing or tracking the payment.
    public var paymentLink: String?
    
    /// The unique tracking ID for the payment.
    public var trackingId: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentLink = "link"
        case trackingId = "trackId"
    }
    
    /// Initializes a new instance of `PaymentDetailsModel`.
    /// - Parameters:
    ///   - paymentLink: The URL link for completing or tracking the payment.
    ///   - trackingId: The unique tracking ID for the payment.
    public init(paymentLink: String? = nil, trackingId: String? = nil) {
        self.paymentLink = paymentLink
        self.trackingId = trackingId
    }
}
