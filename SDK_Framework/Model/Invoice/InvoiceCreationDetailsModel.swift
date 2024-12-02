//
//  InvoiceCreationDetailsModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

// Contains details about the invoice creation process.
public struct InvoiceCreationDetailsModel: Codable {
    
    /// Indicates if an SMS notification was sent.
    let isSmsSent: Bool?
    /// Indicates if an email notification was sent.
    let isEmailSent: Bool?
    /// Indicates if a link was provided.
    let isLinkProvided: Bool?
    /// The URL related to the invoice.
    let invoiceUrl: String?

    enum CodingKeys: String, CodingKey {
        case isSmsSent = "sms"
        case isEmailSent = "email"
        case isLinkProvided = "link"
        case invoiceUrl = "url"
    }
}
