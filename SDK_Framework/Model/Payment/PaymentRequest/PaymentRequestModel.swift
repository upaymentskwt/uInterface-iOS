//
//  PaymentRequestModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// Represents a request for creating a payment, including all necessary details and options.
public struct PaymentRequestModel: Codable {
    
    /// List of products associated with the payment request.
    public let products: [ProductModel]?
    /// Additional merchant-specific data for the payment request.
    public let merchantsMoreInfo: [MerchantMoreInfoModel]?
    /// Unique session identifier for tracking the payment request.
    public let sessionID: String?
    /// Indicates whether the request is for testing purposes.
    public let isTest: Bool?
    /// Order details related to the payment request.
    public let order: OrderModel?
    /// Information about the payment gateway being used.
    public let paymentGateway: PaymentGatewayModel?
    /// Type of notification to be sent.
    public let notificationType: String?
    /// Preferred language for the notification or payment interface.
    public let language: String?
    /// Indicates whether to save the payment card for future use.
    public let isSaveCard: Bool?
    /// Indicates whether the request is whitelabeled.
    public let isWhitelabeled: Bool?
    /// Tokens related to the payment request for security or identification.
    public let tokens: TokenModel?
    /// Reference details associated with the payment request.
    public let reference: ReferenceModel?
    /// Customer details related to the payment request.
    public let customer: CustomerModel?
    /// Plugin information associated with the payment request.
    public let plugin: PluginModel?
    /// Extra data related to the customer, if any.
    public let customerExtraData: String?
    /// URL to which the user should be redirected after a successful payment.
    public let returnURL: String?
    /// URL to which the user should be redirected if the payment is canceled.
    public let cancelURL: String?
    /// URL to which notifications about the payment status will be sent.
    public let notificationURL: String?
    /// Device information related to the payment request.
    public let device: DeviceModel?

    enum CodingKeys: String, CodingKey {
        case products
        case sessionID = "sessionId"
        case isTest
        case order
        case paymentGateway
        case notificationType
        case language
        case isSaveCard
        case isWhitelabeled = "is_whitelabeled"
        case tokens
        case reference
        case customer
        case plugin
        case customerExtraData
        case returnURL = "returnUrl"
        case cancelURL = "cancelUrl"
        case notificationURL = "notificationUrl"
        case device
        case merchantsMoreInfo = "extraMerchantData"
    }

    /// Initializes a new instance of `PaymentRequestModel`.
    /// - Parameters:
    ///   - products: List of products associated with the payment request.
    ///   - merchantsMoreInfo: Additional merchant-specific data for the payment request.
    ///   - sessionID: Unique session identifier for tracking the payment request.
    ///   - isTest: Indicates whether the request is for testing purposes.
    ///   - order: Order details related to the payment request.
    ///   - paymentGateway: Information about the payment gateway being used.
    ///   - notificationType: Type of notification to be sent.
    ///   - language: Preferred language for the notification or payment interface.
    ///   - isSaveCard:  Indicates whether to save the payment card for future use.
    ///   - isWhitelabeled: Indicates whether the request is whitelabeled.
    ///   - tokens: Tokens related to the payment request for security or identification.
    ///   - reference: Reference details associated with the payment request.
    ///   - customer: Customer details related to the payment request.
    ///   - plugin: Plugin information associated with the payment request.
    ///   - customerExtraData: Extra data related to the customer, if any.
    ///   - returnURL: URL to which the user should be redirected after a successful payment.
    ///   - cancelURL: URL to which the user should be redirected if the payment is canceled.
    ///   - notificationURL: URL to which notifications about the payment status will be sent.
    ///   - device: Device information related to the payment request.
    public init(products: [ProductModel]? = nil, merchantsMoreInfo: [MerchantMoreInfoModel]? = nil, sessionID: String? = nil, isTest: Bool? = nil, order: OrderModel? = nil, paymentGateway: PaymentGatewayModel? = nil, notificationType: String? = nil, language: String? = nil, isSaveCard: Bool? = nil, isWhitelabeled: Bool? = nil, tokens: TokenModel? = nil, reference: ReferenceModel? = nil, customer: CustomerModel? = nil, plugin: PluginModel? = nil, customerExtraData: String? = nil, returnURL: String? = nil, cancelURL: String? = nil, notificationURL: String? = nil, device: DeviceModel? = nil) {
        self.products = products
        self.merchantsMoreInfo = merchantsMoreInfo
        self.sessionID = sessionID
        self.isTest = isTest
        self.order = order
        self.paymentGateway = paymentGateway
        self.notificationType = notificationType
        self.language = language
        self.isSaveCard = isSaveCard
        self.isWhitelabeled = isWhitelabeled
        self.tokens = tokens
        self.reference = reference
        self.customer = customer
        self.plugin = plugin
        self.customerExtraData = customerExtraData
        self.returnURL = returnURL
        self.cancelURL = cancelURL
        self.notificationURL = notificationURL
        self.device = device
    }
}
