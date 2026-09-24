//
//  SettingsViewModel.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import Combine
import uInterfaceSDK

public final class SettingsViewModel: ObservableObject {
    
    @ObservedObject public var config: AppConfiguration = .shared
    
    @Published public var customKeyInput: String = ""
    @Published public var customSecretKeyInput: String = ""
    @Published public var customerTokenInput: String = ""
    @Published public var isWhiteLabel: Bool = true
    @Published public var selectedEnvironment: AppEnvironmentOption = .sandbox
    
    // Apple Pay Configuration Inputs
    @Published public var appleMerchantIdInput: String = ""
    @Published public var applePayCountryCodeInput: String = ""
    @Published public var applePayMerchantNameInput: String = ""
    @Published public var requiresActiveCardsInput: Bool = false
    
    @Published public var alertMessage: String? = nil
    @Published public var showAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public var isApplePaySupported: Bool {
        ApplePayProcessor(configuration: config.currentApplePayConfiguration).canMakePayments()
    }
    
    public var isApplePayActiveWithCards: Bool {
        ApplePayProcessor(configuration: config.currentApplePayConfiguration).canMakePaymentsWithActiveCards()
    }
    
    public init() {
        self.customKeyInput = config.apiKey
        self.customSecretKeyInput = config.secretKey
        self.customerTokenInput = config.customerUniqueToken
        self.isWhiteLabel = config.isWhiteLabel
        self.selectedEnvironment = config.environmentOption
        self.appleMerchantIdInput = config.appleMerchantId
        self.applePayCountryCodeInput = config.applePayCountryCode
        self.applePayMerchantNameInput = config.applePayMerchantName
        self.requiresActiveCardsInput = config.applePayRequiresActiveCards
        
        // Sync with config changes
        config.$apiKey
            .sink { [weak self] newKey in
                self?.customKeyInput = newKey
            }
            .store(in: &cancellables)
        
        config.$secretKey
            .sink { [weak self] newSecret in
                self?.customSecretKeyInput = newSecret
            }
            .store(in: &cancellables)
            
        config.$isWhiteLabel
            .sink { [weak self] isWL in
                self?.isWhiteLabel = isWL
            }
            .store(in: &cancellables)
            
        config.$environmentOption
            .sink { [weak self] env in
                self?.selectedEnvironment = env
            }
            .store(in: &cancellables)
            
        config.$appleMerchantId
            .sink { [weak self] id in
                self?.appleMerchantIdInput = id
            }
            .store(in: &cancellables)
            
        config.$applePayCountryCode
            .sink { [weak self] code in
                self?.applePayCountryCodeInput = code
            }
            .store(in: &cancellables)
            
        config.$applePayMerchantName
            .sink { [weak self] name in
                self?.applePayMerchantNameInput = name
            }
            .store(in: &cancellables)

        config.$applePayRequiresActiveCards
            .sink { [weak self] req in
                self?.requiresActiveCardsInput = req
            }
            .store(in: &cancellables)
    }
    
    public func applyPreset(isWhiteLabel: Bool) {
        if isWhiteLabel {
            config.applyWhiteLabelPreset()
        } else {
            config.applyStandardPreset()
        }
        self.customKeyInput = config.apiKey
        self.customSecretKeyInput = config.secretKey
        self.isWhiteLabel = config.isWhiteLabel
        self.selectedEnvironment = config.environmentOption
        
        reinitialize()
    }
    
    public func saveAndInitialize() {
        config.apiKey = customKeyInput
        config.secretKey = customSecretKeyInput
        config.customerUniqueToken = customerTokenInput
        config.isWhiteLabel = isWhiteLabel
        config.environmentOption = selectedEnvironment
        let resolvedMerchantId = appleMerchantIdInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppConfiguration.defaultAppleMerchantId : appleMerchantIdInput
        config.appleMerchantId = resolvedMerchantId
        config.applePayCountryCode = applePayCountryCodeInput
        config.applePayMerchantName = applePayMerchantNameInput
        config.applePayRequiresActiveCards = requiresActiveCardsInput
        
        reinitialize()
    }
    
    public func reinitialize() {
        config.initializeSDK { [weak self] success in
            guard let self = self else { return }
            if success {
                self.alertMessage = "SDK successfully configured & credentials resolved!"
            } else {
                self.alertMessage = self.config.initErrorMessage ?? "Initialization failed"
            }
            self.showAlert = true
        }
    }
}
