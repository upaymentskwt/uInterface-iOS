//
//  CardManagementViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public final class CardManagementViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var savedCards: [CardInfoModel] = []
    @Published public var isLoading: Bool = false
    @Published public var isAddingCard: Bool = false
    @Published public var isGeneratingToken: Bool = false
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    
    // MARK: - Actions
    
    /// Generates a customer unique token for the current customer identifier.
    public func createCustomerToken() {
        let config = AppConfiguration.shared
        self.isGeneratingToken = true
        
        let request = CustomerTokenRequestModel(customerUniqueToken: config.customerUniqueToken)
        UPayments.shared.createCustomerToken(request: request, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isGeneratingToken = false
                switch result {
                case .success(let response):
                    let tokenValue = response.data?.customerUniqueToken
                    self.alertMessage = "Customer token created successfully: \(tokenValue ?? 0)"
                    self.showAlert = true
                    self.fetchSavedCards()
                case .failure(let error):
                    self.alertMessage = "Token generation failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    /// Presents the Add Card web modal to tokenize a card.
    public func addCard() {
        guard let topVC = WindowHelper.topMostViewController else {
            self.alertMessage = "Could not locate active presentation view controller."
            self.showAlert = true
            return
        }
        
        let config = AppConfiguration.shared
        self.isAddingCard = true
        
        let cardPayload: [String: Any] = [
            "customerUniqueToken": config.customerUniqueToken
        ]
        
        UPayments.shared.addCard(
            cardRequest: cardPayload,
            from: topVC,
            apiKey: config.apiKey
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isAddingCard = false
                switch result {
                case .success(let response):
                    let statusMsg = response["addCardStatusMessage"] as? String ?? "Card processed successfully"
                    self.alertMessage = statusMsg
                    self.showAlert = true
                    self.fetchSavedCards()
                case .failure(let error):
                    self.alertMessage = "Add card failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    /// Fetches all stored customer cards.
    public func fetchSavedCards() {
        let config = AppConfiguration.shared
        self.isLoading = true
        
        let tokenInt = Int(config.customerUniqueToken) ?? 123456789
        let request = TokenDataModel(customerUniqueToken: tokenInt)
        UPayments.shared.fetchCustomerCards(request: request, apiKey: config.apiKey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.savedCards = response.data?.customerCardsInfo ?? []
                case .failure(let error):
                    self.savedCards = []
                    self.alertMessage = "Failed to load cards: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}
