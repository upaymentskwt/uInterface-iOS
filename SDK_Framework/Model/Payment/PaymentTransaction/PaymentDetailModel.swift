//
//  PaymentDetailModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// Represents a payment request with various parameters required for processing transactions.
public struct PaymentDetail: Encodable {
    
    /// Merchant ID for identifying the merchant in the payment system.
    public var merchantID: String?
    
    /// Username for authenticating the merchant's account.
    public var userName: String?
    
    /// Password for authenticating the merchant's account.
    public var password: String?
    
    /// API key for accessing the payment system's APIs securely.
    public var apiKey: String?
    
    /// Unique order identifier for the transaction.
    public var orderID: String?
    
    /// Total price of the order.
    public var totalPrice: String?
    
    /// Currency code (e.g., USD, EUR) used for the transaction.
    public var currencyCode: String?
    
    /// Indicates if the payment is being processed in test mode.
    public var testMode: String?
    
    /// URL to which the user will be redirected upon successful payment.
    public var successURL: String?
    
    /// URL to which the user will be redirected if payment fails.
    public var errorURL: String?
    
    /// Full name of the customer making the payment.
    public var customerFullName: String?
    
    /// Email address of the customer.
    public var customerEmail: String?
    
    /// Mobile number of the customer.
    public var customerMobile: String?
    
    /// Title of the product being purchased.
    public var productTitle: String?
    
    /// Name of the product being purchased.
    public var productName: String?
    
    /// Price of the product being purchased.
    public var productPrice: String?
    
    /// Quantity of the product being purchased.
    public var productQuantity: String?
    
    /// Reference code or identifier for the transaction.
    public var reference: String?
    
    /// URL where notifications related to the payment will be sent.
    public var notifyURL: String?
    
    /// Indicates if the payment request is white-labeled (custom branding).
    public var isWhiteLabeled: Bool?
    
    public init(merchantID: String? = nil, userName: String? = nil, password: String? = nil, apiKey: String? = nil, orderID: String? = nil, totalPrice: String? = nil, currencyCode: String? = nil, testMode: String? = nil, successURL: String? = nil, errorURL: String? = nil, customerFullName: String? = nil, customerEmail: String? = nil, customerMobile: String? = nil, productTitle: String? = nil, productName: String? = nil, productPrice: String? = nil, productQuantity: String? = nil, reference: String? = nil, notifyURL: String? = nil) {
        self.merchantID = merchantID
        self.userName = userName
        self.password = password
        self.apiKey = apiKey
        self.orderID = orderID
        self.totalPrice = totalPrice
        self.currencyCode = currencyCode
        self.testMode = testMode
        self.successURL = successURL
        self.errorURL = errorURL
        self.customerFullName = customerFullName
        self.customerEmail = customerEmail
        self.customerMobile = customerMobile
        self.productTitle = productTitle
        self.productName = productName
        self.productPrice = productPrice
        self.productQuantity = productQuantity
        self.reference = reference
        self.notifyURL = notifyURL
    }
    
    /// Coding keys to map the properties to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case merchantID = "merchant_id"
        case userName = "username"
        case password = "password"
        case apiKey = "api_key"
        case orderID = "order_id"
        case totalPrice = "total_price"
        case currencyCode = "CurrencyCode"
        case testMode = "test_mode"
        case successURL = "success_url"
        case errorURL = "error_url"
        case customerFullName = "CstFName"
        case customerEmail = "CstEmail"
        case customerMobile = "CstMobile"
        case productTitle = "ProductTitle"
        case productName = "ProductName"
        case productPrice = "ProductPrice"
        case productQuantity = "ProductQty"
        case reference = "Reference"
        case isWhiteLabeled = "whiteLabeled"
    }
}
