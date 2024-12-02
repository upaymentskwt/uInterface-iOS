//
//  PaymentTransactionModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents the details of a transaction.
public struct PaymentTransactionModel: Codable {
    
    /// The unique identifier for the order.
    public let orderId: String?
    /// The identifier for the refund associated with the order, if any.
    public let refundOrderId: String?
    /// The unique identifier for the payment transaction.
    public let paymentId: String?
    /// The result status of the transaction (e.g., "Success", "Failed").
    public let result: String?
    /// The tracking identifier for the transaction, useful for following up with the payment provider.
    public let trackId: String?
    /// The date and time when the transaction was processed, typically in ISO 8601 format.
    public let transactionDate: String?
    /// Indicates whether the customer's card information is saved for future transactions.
    public let isSaveCard: Bool?
    /// Specifies if the transaction was initiated from a plugin (e.g., a payment plugin in an e-commerce platform).
    public let fromPlugin: Bool?
    /// Details about the products involved in the transaction, usually serialized as a JSON string.
    public let productDetails: String?
    /// A reference string provided by the merchant for tracking purposes.
    public let reference: String?
    /// The total price of the transaction in the currency specified by `currencyType`.
    public let totalPrice: String?
    /// The type of currency used for the transaction (e.g., "USD", "KWD").
    public let currencyType: String?
    /// The current status of the transaction (e.g., "Pending", "Completed").
    public let status: String?
    /// The session identifier used to maintain the state of the transaction.
    public let sessionId: String?
    /// The URL to redirect the user to if the transaction encounters an error.
    public let errorUrl: String?
    /// The URL to redirect the user to upon successful completion of the transaction.
    public let successUrl: String?
    /// The URL to redirect the user to after the transaction process is completed, regardless of success or failure.
    public let redirectUrl: String?
    /// The URL where the server sends notifications (webhooks) about the transaction status.
    public let notifyUrl: String?
    /// Indicates whether the `notifyUrl` was called by the payment provider.
    public let notifyUrlCalled: Bool?
    /// The response received from the payment provider after the `notifyUrl` was called.
    public let notifyUrlResponse: String?
    /// Specifies whether the transaction is whitelabeled, meaning it is branded under the merchant's identity.
    public let whitelabeled: Bool?
    /// The unique identifier for the customer making the transaction.
    public let customerId: Int?
    /// A unique identifier associated with the customer, often used for tracking across multiple platforms.
    public let customerUniqueId: String?
    /// The order identifier requested by the merchant, which may differ from `orderId`.
    public let merchantRequestedOrderId: String?
    /// Additional data related to other merchants involved in the transaction, usually serialized as a JSON string.
    public let extraMerchantsData: String?
    /// The total amount paid in a currency other than KWD (Kuwaiti Dinar), if applicable.
    public let totalPaidNonKwd: String?
    /// Indicates whether the payment was made using KNET (a Kuwaiti payment system).
    public let isPaidFromKnet: Bool?
    /// Indicates whether the payment was made using a credit card.
    public let isPaidFromCc: Bool?
    /// Indicates whether the payment was made through the National Bank of Kuwait (NBK).
    public let isFromNbk: Bool?
    /// Any extra data provided by the customer at the time of the transaction, often serialized as a JSON string.
    public let customerExtraData: String?
    /// The date and time when the transaction record was created, typically in ISO 8601 format.
    public let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case refundOrderId = "refund_order_id"
        case paymentId = "payment_id"
        case result = "result"
        case trackId = "track_id"
        case transactionDate = "transaction_date"
        case isSaveCard = "is_save_card"
        case fromPlugin = "from_plugin"
        case productDetails = "product_details"
        case reference = "reference"
        case totalPrice = "total_price"
        case currencyType = "currency_type"
        case status = "status"
        case sessionId = "session_id"
        case errorUrl = "error_url"
        case successUrl = "success_url"
        case redirectUrl = "redirect_url"
        case notifyUrl = "notify_url"
        case notifyUrlCalled = "notify_url_called"
        case notifyUrlResponse = "notify_url_response"
        case whitelabeled = "whitelabled"
        case customerId = "customer_id"
        case customerUniqueId = "customer_unq_id"
        case merchantRequestedOrderId = "merchant_requested_order_id"
        case extraMerchantsData = "extra_merchants_data"
        case totalPaidNonKwd = "total_paid_non_kwd"
        case isPaidFromKnet = "is_paid_from_knet"
        case isPaidFromCc = "is_paid_from_cc"
        case isFromNbk = "is_from_nbk"
        case customerExtraData = "customer_extra_data"
        case createdAt = "created_at"
    }
    
    /// Initializes a new instance of `PaymentTransactionModel`.
    /// - Parameters for all transaction details.
    public init(orderId: String? = nil, refundOrderId: String? = nil, paymentId: String? = nil, result: String? = nil, trackId: String? = nil, transactionDate: String? = nil, isSaveCard: Bool? = nil, fromPlugin: Bool? = nil, productDetails: String? = nil, reference: String? = nil, totalPrice: String? = nil, currencyType: String? = nil, status: String? = nil, sessionId: String? = nil, errorUrl: String? = nil, successUrl: String? = nil, redirectUrl: String? = nil, notifyUrl: String? = nil, notifyUrlCalled: Bool? = nil, notifyUrlResponse: String? = nil, whitelabeled: Bool? = nil, customerId: Int? = nil, customerUniqueId: String? = nil, merchantRequestedOrderId: String? = nil, extraMerchantsData: String? = nil, totalPaidNonKwd: String? = nil, isPaidFromKnet: Bool? = nil, isPaidFromCc: Bool? = nil, isFromNbk: Bool? = nil, customerExtraData: String? = nil, createdAt: String? = nil) {
        self.orderId = orderId
        self.refundOrderId = refundOrderId
        self.paymentId = paymentId
        self.result = result
        self.trackId = trackId
        self.transactionDate = transactionDate
        self.isSaveCard = isSaveCard
        self.fromPlugin = fromPlugin
        self.productDetails = productDetails
        self.reference = reference
        self.totalPrice = totalPrice
        self.currencyType = currencyType
        self.status = status
        self.sessionId = sessionId
        self.errorUrl = errorUrl
        self.successUrl = successUrl
        self.redirectUrl = redirectUrl
        self.notifyUrl = notifyUrl
        self.notifyUrlCalled = notifyUrlCalled
        self.notifyUrlResponse = notifyUrlResponse
        self.whitelabeled = whitelabeled
        self.customerId = customerId
        self.customerUniqueId = customerUniqueId
        self.merchantRequestedOrderId = merchantRequestedOrderId
        self.extraMerchantsData = extraMerchantsData
        self.totalPaidNonKwd = totalPaidNonKwd
        self.isPaidFromKnet = isPaidFromKnet
        self.isPaidFromCc = isPaidFromCc
        self.isFromNbk = isFromNbk
        self.customerExtraData = customerExtraData
        self.createdAt = createdAt
    }
}
