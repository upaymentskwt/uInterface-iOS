//
//  AutoDeductViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public final class AutoDeductViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var cardToken: String = ""
    @Published public var amount: String = "0.01"
    @Published public var currency: String = "KWD"
    @Published public var orderDescription: String = "Auto Deduct Subscription"
    @Published public var customerName: String = "John Doe"
    @Published public var customerEmail: String = "john@example.com"
    @Published public var customerMobile: String = "94771608"
    
    @Published public var isProcessing: Bool = false
    @Published public var responseJSON: String? = nil
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    @Published public var showJSONSheet: Bool = false
    
    // MARK: - Actions
    public func executeAutoDeduct() {
        guard !cardToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.alertMessage = "Please enter or select a valid Card Token."
            self.showAlert = true
            return
        }
        
        let config = AppConfiguration.shared
        self.isProcessing = true
        
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let order = AutoDeductOrderModel(
            orderId: "AD_ORD_\(timestamp)",
            reference: "REF_\(timestamp)",
            description: orderDescription,
            currency: currency,
            amount: amount
        )
        
        let customer = AutoDeductCustomerModel(
            name: customerName,
            email: customerEmail,
            mobile: customerMobile,
            uniqueToken: Int(config.customerUniqueToken) ?? 9904917679
        )
        
        let card = AutoDeductCardModel(token: cardToken)
        let reference = AutoDeductReferenceModel(referenceId: "REF_\(timestamp)")
        
        let request = AutoDeductRequestModel(
            order: order,
            language: "en",
            reference: reference,
            customer: customer,
            card: card
        )
        
        UPayments.shared.autoDeduct(request: request, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isProcessing = false
                switch result {
                case .success(let responseDict):
                    let message = responseDict["message"] as? String ?? "Auto-deduct completed successfully"
                    if let data = try? JSONSerialization.data(withJSONObject: responseDict, options: .prettyPrinted),
                       let prettyString = String(data: data, encoding: .utf8) {
                        self.responseJSON = prettyString
                    } else {
                        self.responseJSON = "\(responseDict)"
                    }
                    self.alertMessage = message
                    self.showAlert = true
                case .failure(let error):
                    self.responseJSON = "Error: \(error.localizedDescription)"
                    self.alertMessage = "Auto-deduct failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}
