//
//  PaymentStatusDataModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Contains detailed data related to the payment status.
public struct PaymentStatusDataModel: Codable {
    
    /// Information about the specific transaction.
    public let transaction: PaymentTransactionModel?
    
    enum CodingKeys: String, CodingKey {
        case transaction
    }
    
    /// Initializes a new instance of `PaymentStatusDataModel`.
    /// - Parameter transaction: The transaction details.
    public init(transaction: PaymentTransactionModel? = nil) {
        self.transaction = transaction
    }
}
