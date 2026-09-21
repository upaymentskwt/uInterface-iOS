//
//  InvoicingViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public final class InvoicingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var customerName: String = "Ahmed Al-Mansoor"
    @Published public var customerEmail: String = "ahmed@example.com"
    @Published public var customerMobile: String = "96598765432"
    @Published public var amount: String = "25.00"
    @Published public var currency: String = "KWD"
    @Published public var orderDescription: String = "Consulting Invoice"
    
    @Published public var isGenerating: Bool = false
    @Published public var createdInvoice: InvoiceCreatedModel? = nil
    @Published public var lastNetworkError: NetworkError? = nil
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    
    // MARK: - Actions
    public func createInvoice() {
        let config = AppConfiguration.shared
        self.isGenerating = true
        self.lastNetworkError = nil
        
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let customer = CustomerModel(
            uniqueID: config.customerUniqueToken,
            name: customerName,
            email: customerEmail,
            mobile: customerMobile
        )
        
        let order = OrderModel(
            orderId: "INV_\(timestamp)",
            reference: "REF_\(timestamp)",
            description: orderDescription,
            currency: currency,
            amount: Double(amount) ?? 25.0
        )
        
        let invoicePayload: [String: Any] = [
            "customer": customer.toDictionary(),
            "order": order.toDictionary(),
            "paymentGateway": PaymentGatewayModel(src: "create-invoice").toDictionary(),
            "reference": ReferenceModel(referenceId: "REF_\(timestamp)").toDictionary(),
            "isTest": !config.isProduction,
            "returnUrl": "https://upayments.com/en/success",
            "cancelUrl": "https://upayments.com/en/cancel",
            "notificationUrl": "https://upayments.com/en/notification"
        ]
        
        UPayments.shared.createInvoice(request: invoicePayload, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isGenerating = false
                switch result {
                case .success(let invoice):
                    self.createdInvoice = invoice
                    self.lastNetworkError = nil
                    self.alertMessage = invoice.message ?? "Invoice created successfully"
                    self.showAlert = true
                case .failure(let error):
                    self.createdInvoice = nil
                    self.lastNetworkError = error
                }
            }
        }
    }
}
