//
//  CheckoutViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct EditableProductItem: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var description: String
    public var priceText: String
    public var quantityText: String
    
    public init(id: String, name: String, description: String, priceText: String, quantityText: String) {
        self.id = id
        self.name = name
        self.description = description
        self.priceText = priceText
        self.quantityText = quantityText
    }
    
    public var price: Double {
        Double(priceText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
    }
    
    public var quantity: Double {
        Double(quantityText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1.0
    }
    
    public var itemTotal: Double {
        price * quantity
    }
    
    public func toProductModel() -> ProductModel {
        ProductModel(
            name: name,
            description: description,
            price: price,
            quantity: quantity
        )
    }
}

public final class CheckoutViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var isSingleProduct: Bool = true {
        didSet {
            resetProductsForMode()
        }
    }
    
    @Published public var products: [EditableProductItem] = []
    
    @Published public var customerName: String = "John Doe"
    @Published public var customerEmail: String = "john@example.com"
    @Published public var customerMobile: String = "96594771608"
    @Published public var currency: String = "KWD"
    @Published public var selectedPaymentSource: String = "apple-pay"
    
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
    
    public init() {
        resetProductsForMode()
    }
    
    public func resetProductsForMode() {
        if isSingleProduct {
            products = [
                EditableProductItem(id: "1", name: "Single Espresso", description: "Premium Espresso", priceText: "2.500", quantityText: "1")
            ]
        } else {
            products = [
                EditableProductItem(id: "1", name: "Single Espresso", description: "Premium Espresso", priceText: "2.500", quantityText: "1"),
                EditableProductItem(id: "2", name: "Butter Croissant", description: "French Croissant", priceText: "1.500", quantityText: "2")
            ]
        }
    }
    
    public func addItem() {
        let newIndex = products.count + 1
        products.append(
            EditableProductItem(id: UUID().uuidString, name: "Item #\(newIndex)", description: "Custom Product Item", priceText: "1.000", quantityText: "1")
        )
    }
    
    public func removeItem(at index: Int) {
        guard products.indices.contains(index), products.count > 1 else { return }
        products.remove(at: index)
    }
    
    public var totalAmount: Double {
        products.reduce(0.0) { $0 + $1.itemTotal }
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
        
        let tokenDetail = TokenModel(
            fastToken: "",
            creditCard: "",
            customerUniqueToken: config.customerUniqueToken
        )
        
        let referenceDetail = ReferenceModel(referenceId: "REF_\(timestamp)")
        
        let browserDetails = BrowserDetailsModel(
            screenWidth: "1920",
            screenHeight: "1080",
            colorDepth: "24",
            javaEnabled: "true",
            language: "en"
        )
        let deviceDetail = DeviceModel(
            browser: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15",
            browserDetails: browserDetails
        )
        
        let effectiveProducts = products.map { $0.toProductModel() }
        
        let paymentRequest = PaymentRequestModel(
            products: effectiveProducts,
            sessionID: nil,
            isTest: !config.isProduction,
            order: order,
            paymentGateway: gatewayModel,
            notificationType: "all",
            language: "en",
            isSaveCard: false,
            isWhitelabeled: config.isWhiteLabel,
            tokens: tokenDetail,
            reference: referenceDetail,
            customer: customer,
            customerExtraData: "iOS Checkout",
            returnURL: "https://upayments.com/en/success",
            cancelURL: "https://upayments.com/en/cancel",
            notificationURL: "https://upayments.com/en/notification",
            device: deviceDetail
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.showResultSheet = true
                    }
                case .failure(let error):
                    self.lastResult = nil
                    self.lastNetworkError = error
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.showResultSheet = true
                    }
                }
            }
        }
    }
}
