//
//  CheckoutViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public final class CheckoutViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var isSingleProduct: Bool = true
    @Published public var customerName: String = "John Doe"
    @Published public var customerEmail: String = "john@example.com"
    @Published public var customerMobile: String = "96594771608"
    @Published public var currency: String = "KWD"
    @Published public var selectedPaymentSource: String = "cc"
    
    @Published public var isProcessing: Bool = false
    @Published public var lastResult: PaymentResult? = nil
    @Published public var lastNetworkError: NetworkError? = nil
    @Published public var showResultSheet: Bool = false
    
    public let availableSources: [(id: String, name: String)] = [
        ("cc", "Credit / Debit Card"),
        ("knet", "KNET"),
        ("apple-pay", "Apple Pay"),
        ("samsung-pay", "Samsung Pay")
    ]
    
    public var currentProducts: [ProductModel] {
        if isSingleProduct {
            return [
                ProductModel(name: "Single Espresso", description: "Premium Espresso", price: 2.5, quantity: 1.0)
            ]
        } else {
            return [
                ProductModel(name: "Single Espresso", description: "Premium Espresso", price: 2.5, quantity: 1.0),
                ProductModel(name: "Butter Croissant", description: "French Croissant", price: 1.5, quantity: 2.0)
            ]
        }
    }
    
    public var totalAmount: Double {
        currentProducts.reduce(0.0) { $0 + (($1.price ?? 0.0) * ($1.quantity ?? 1.0)) }
    }
    
    // MARK: - Actions
    public func initiatePayment() {
        guard let topVC = WindowHelper.topMostViewController else {
            self.lastNetworkError = NetworkError(reason: "Could not locate active presentation view controller.", httpStatusCode: 500)
            self.showResultSheet = true
            return
        }
        
        let config = AppConfiguration.shared
        self.isProcessing = true
        self.lastNetworkError = nil
        self.lastResult = nil
        
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let order = OrderModel(
            orderId: "ORD_\(timestamp)",
            reference: "REF_\(timestamp)",
            description: isSingleProduct ? "Single Product Checkout" : "Multi-Product Checkout",
            currency: currency,
            amount: totalAmount
        )
        
        let customer = CustomerModel(
            uniqueID: config.customerUniqueToken,
            name: customerName,
            email: customerEmail,
            mobile: customerMobile
        )
        
        var gatewayModel: PaymentGatewayModel? = nil
        if config.isWhiteLabel {
            gatewayModel = PaymentGatewayModel(src: selectedPaymentSource)
        }
        
        let paymentRequest = PaymentRequestModel(
            products: currentProducts,
            sessionID: UUID().uuidString,
            isTest: !config.isProduction,
            order: order,
            paymentGateway: gatewayModel,
            isWhitelabeled: config.isWhiteLabel,
            customer: customer,
            returnURL: "https://upayments.com/en/success",
            cancelURL: "https://upayments.com/en/cancel",
            notificationURL: "https://upayments.com/en/notification"
        )
        
        UPayments.shared.processPayment(
            request: paymentRequest,
            from: topVC,
            isBackground: false,
            apiKey: config.apiKey
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isProcessing = false
                switch result {
                case .success(let paymentResult):
                    self.lastResult = paymentResult
                    self.lastNetworkError = nil
                    self.showResultSheet = true
                case .failure(let error):
                    self.lastResult = nil
                    self.lastNetworkError = error
                    self.showResultSheet = true
                }
            }
        }
    }
}
