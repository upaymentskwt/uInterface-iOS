//
//  RefundRequestModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing the request details for initiating a refund.
public struct RefundRequestModel: Codable {
    
    /// The unique identifier for the order.
    public var orderId: String?
    
    /// The total price of the order, in cents.
    public var totalPrice: Double?
    
    /// The first name of the customer requesting the refund.
    public var customerFirstName: String?
    
    /// The email address of the customer.
    public var customerEmail: String?
    
    /// The mobile number of the customer.
    public var customerMobileNumber: String?
    
    /// A reference code for tracking the refund request.
    public var reference: String?
    
    /// The URL to be notified upon refund completion.
    public var notifyUrl: String?
    
    /// Initializes a new `RefundRequestModel` instance with optional parameters.
    public init(orderId: String? = nil, totalPrice: Double? = nil, customerFirstName: String? = nil, customerEmail: String? = nil, customerMobileNumber: String? = nil, reference: String? = nil, notifyUrl: String? = nil) {
        self.orderId = orderId
        self.totalPrice = totalPrice
        self.customerFirstName = customerFirstName
        self.customerEmail = customerEmail
        self.customerMobileNumber = customerMobileNumber
        self.reference = reference
        self.notifyUrl = notifyUrl
    }
}
