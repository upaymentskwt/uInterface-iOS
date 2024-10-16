//
//  InvoiceCreationModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents the response from an API call to create an invoice.
public struct InvoiceCreationModel: Codable {
    
    /// Indicates whether the request was successful.
    let isSuccess: Bool?
    /// Contains a message from the server about the request status.
    let message: String?
    /// Contains details about the invoice creation.
    let details: InvoiceCreationDetailsModel?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "status"
        case message = "message"
        case details = "data"
    }
}
