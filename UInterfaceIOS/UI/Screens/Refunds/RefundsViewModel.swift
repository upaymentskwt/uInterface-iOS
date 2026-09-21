//
//  RefundsViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public enum RefundMode: String, CaseIterable {
    case single = "Single Refund"
    case multiVendor = "Multi-Vendor"
    case delete = "Cancel Refund"
}

public final class RefundsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var selectedMode: RefundMode = .single
    @Published public var orderId: String = "ORD_12345"
    @Published public var amount: String = "2.50"
    @Published public var customerName: String = "Sara"
    @Published public var customerEmail: String = "sara@example.com"
    @Published public var reference: String = "REFUND_001"
    
    // Multi-Vendor details
    @Published public var vendor1Amount: String = "1"
    @Published public var vendor1IBAN: String = "KW91KFHO0000000000051010173254"
    @Published public var vendor2Amount: String = "1"
    @Published public var vendor2IBAN: String = "KW91KFHO0000000000051010173254"
    
    // Delete refund fields
    @Published public var deleteOrderId: String = ""
    
    @Published public var isSubmitting: Bool = false
    @Published public var resultMessage: String? = nil
    @Published public var lastNetworkError: NetworkError? = nil
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    
    // MARK: - Actions
    public func executeAction() {
        switch selectedMode {
        case .single:
            executeSingleRefund()
        case .multiVendor:
            executeMultiVendorRefund()
        case .delete:
            executeDeleteRefund()
        }
    }
    
    private func executeSingleRefund() {
        let config = AppConfiguration.shared
        self.isSubmitting = true
        self.lastNetworkError = nil
        
        let request = RefundRequestModel(
            orderId: orderId,
            totalPrice: Double(amount) ?? 0.0,
            customerFirstName: customerName,
            customerEmail: customerEmail,
            reference: reference
        )
        
        UPayments.shared.createRefund(request: request, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                switch result {
                case .success(let response):
                    let msg = response.message ?? "Single refund submitted"
                    self.alertMessage = msg
                    self.resultMessage = "Status: \(response.status ?? false)\nMessage: \(msg)"
                    self.lastNetworkError = nil
                    self.showAlert = true
                case .failure(let error):
                    self.lastNetworkError = error
                    self.resultMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func executeMultiVendorRefund() {
        let config = AppConfiguration.shared
        self.isSubmitting = true
        self.lastNetworkError = nil
        
        let v1 = MerchantMoreDetailsModel(
            amount: Int(vendor1Amount) ?? 1,
            kNetCharge: 1,
            iBanNumber: vendor1IBAN
        )
        let v2 = MerchantMoreDetailsModel(
            amount: Int(vendor2Amount) ?? 1,
            kNetCharge: 1,
            iBanNumber: vendor2IBAN
        )
        
        let request = MultiVendorRefundRequest(merchantMoreDetailModel: [v1, v2])
        
        UPayments.shared.createMultiVendorRefund(request: request, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                switch result {
                case .success(let response):
                    let msg = response.message ?? "Multi-vendor refund submitted"
                    self.alertMessage = msg
                    self.resultMessage = "Status: \(response.status ?? false)\nMessage: \(msg)"
                    self.lastNetworkError = nil
                    self.showAlert = true
                case .failure(let error):
                    self.lastNetworkError = error
                    self.resultMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func executeDeleteRefund() {
        let config = AppConfiguration.shared
        self.isSubmitting = true
        self.lastNetworkError = nil
        
        let payload: [String: Any] = [
            "order_id": deleteOrderId.isEmpty ? orderId : deleteOrderId
        ]
        
        UPayments.shared.deleteRefund(request: payload, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                switch result {
                case .success(let responseDict):
                    let msg = responseDict["message"] as? String ?? "Refund cancelled successfully"
                    self.alertMessage = msg
                    self.resultMessage = "\(responseDict)"
                    self.lastNetworkError = nil
                    self.showAlert = true
                case .failure(let error):
                    self.lastNetworkError = error
                    self.resultMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
