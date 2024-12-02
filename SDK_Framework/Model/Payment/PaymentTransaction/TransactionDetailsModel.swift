//
//  TransactionDetailsModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents the details of a transaction in the payment system.
public struct TransactionDetails: Codable {
    
    /// A unique reference string for the transaction.
    var reference: String?
    
    /// The ID associated with the transaction.
    var transactionID: String?
    
    /// The type of payment used, e.g., "Credit Card", "PayPal".
    var paymentType: String?
    
    /// The ID of the receipt generated for the transaction.
    var receiptID: String?
    
    /// The ID assigned by the UPAY system for the order.
//    var upayOrderID: String?
    
    /// The ID of the order associated with the transaction.
    var orderID: String?
    
    /// The UDF of the order associated with the transaction.
    var transactionUDF: String?
    
    /// The ID of the requested order, if applicable.
    var requestedOrderID: String?
    
    /// The authorization code provided by the payment gateway.
    var authorizationCode: String?
    
    /// The date when the transaction was posted.
    var postingDate: String?
    
    /// The result of the transaction, e.g., "Success", "Failed".
    var result: String?
    
    /// The ID used to track the transaction within the system.
    var trackingID: String?
    
    /// The ID of the payment within the payment system.
    var paymentID: String?
    
    /// The ID associated with a refund request for the transaction.
    var refundOrderID: String?

    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case reference = "ref"
        case transactionID = "tran_id"
        case paymentType = "payment_type"
        case receiptID = "receipt_id"
//        case upayOrderID = "upay_order_id"
        case orderID = "order_id"
        case transactionUDF = "trn_udf"
        case requestedOrderID = "requested_order_id"
        case authorizationCode = "auth"
        case postingDate = "post_date"
        case result = "result"
        case trackingID = "track_id"
        case paymentID = "payment_id"
        case refundOrderID = "refund_order_id"
    }
    
    init() {
        reference = ""
        transactionID = ""
        paymentType = ""
        receiptID = ""
//        upayOrderID = ""
        orderID = ""
        transactionUDF = ""
        requestedOrderID = ""
        authorizationCode = ""
        postingDate = ""
        result = ""
        trackingID = ""
        paymentID = ""
        refundOrderID = ""
    }
}

/// Represents the result of a payment operation.
public struct PaymentResult: Codable {
    
    /// A message describing the payment outcome.
    public var message: String = ""
    
    /// Details about the transaction associated with the payment.
    public var transactionDetails: TransactionDetails = TransactionDetails()
    
    enum CodingKeys: String, CodingKey {
        case message
        case transactionDetails = "transectionDetails"
    }
}
