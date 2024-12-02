//
//  CustomerModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a customer involved in the payment request.
public struct CustomerModel: Codable {

    /// Unique identifier for the customer.
    public let uniqueID: String?
    /// Name of the customer.
    public let customerName: String?
    /// Email address of the customer.
    public let customerEmail: String?
    /// Mobile number of the customer.
    public let customerMobile: String?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "uniqueId"
        case customerName = "name"
        case customerEmail = "email"
        case customerMobile = "mobile"
    }

    /// Initializes a new instance of `CustomerModel`.
    /// - Parameters:
    ///   - uniqueID: Unique identifier for the customer.
    ///   - customerName: Name of the customer.
    ///   - customerEmail: Email address of the customer.
    ///   - customerMobile: Mobile number of the customer.
    public init(uniqueID: String? = nil, name: String? = nil, email: String? = nil, mobile: String? = nil) {
        self.uniqueID = uniqueID
        self.customerName = name
        self.customerEmail = email
        self.customerMobile = mobile
    }
}
