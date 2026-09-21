//
//  StatusCheckViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public final class StatusCheckViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var trackingID: String = "20221010125525515728"
    @Published public var isCheckingStatus: Bool = false
    @Published public var isCheckingButtons: Bool = false
    
    @Published public var paymentStatusResponse: PaymentStatusResponseModel? = nil
    @Published public var availableButtons: [String] = []
    @Published public var lastNetworkError: NetworkError? = nil
    
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    
    // MARK: - Actions
    public func checkPaymentStatus() {
        guard !trackingID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.lastNetworkError = NetworkError(reason: "Please enter a tracking ID.", httpStatusCode: 400)
            return
        }
        
        let config = AppConfiguration.shared
        self.isCheckingStatus = true
        self.lastNetworkError = nil
        
        UPayments.shared.fetchPaymentStatus(trackingID: trackingID, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isCheckingStatus = false
                switch result {
                case .success(let response):
                    self.paymentStatusResponse = response
                    self.lastNetworkError = nil
                    self.alertMessage = response.message ?? "Status check complete"
                    self.showAlert = true
                case .failure(let error):
                    self.paymentStatusResponse = nil
                    self.lastNetworkError = error
                }
            }
        }
    }
    
    public func checkButtonStatus() {
        let config = AppConfiguration.shared
        self.isCheckingButtons = true
        self.lastNetworkError = nil
        
        UPayments.shared.checkPaymentButtonStatus(apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isCheckingButtons = false
                switch result {
                case .success(let response):
                    let buttonDict = response.paymentButtonData?.payButtons ?? [:]
                    let buttonList = buttonDict.map { pair in "\(pair.key): \(pair.value ? "Enabled" : "Disabled")" }.sorted()
                    self.availableButtons = buttonList
                    self.lastNetworkError = nil
                    self.alertMessage = "Available Buttons: \(buttonList.joined(separator: ", "))"
                    self.showAlert = true
                case .failure(let error):
                    self.availableButtons = []
                    self.lastNetworkError = error
                }
            }
        }
    }
}
