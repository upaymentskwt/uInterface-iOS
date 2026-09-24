//
//  AppConfiguration.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import Foundation
import Combine
import uInterfaceSDK

/// Represents selectable environments in the example application.
public enum AppEnvironmentOption: String, CaseIterable, Identifiable {
    case sandbox = "Sandbox"
    case production = "Production"
    
    public var id: String { rawValue }
    
    public func toSDKEnvironment(customURL: String = "") -> Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .production:
            return .production
        }
    }
}

/// Global observable configuration managing environment, credentials, and SDK state.
public final class AppConfiguration: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = AppConfiguration()
    
    // MARK: - Default Presets
    public static let defaultWhiteLabelKey = "oxxnDz0ES48qyaT96f8VG6YYyFr0krk2akJI7LH5"
    public static let defaultSandboxKey = "jtest123"
    public static let defaultAppleMerchantId = "merchant.utechnologies.apple.native"
    public static let defaultAppleCountryCode = "KW"
    public static let defaultAppleMerchantName = "UPayments Store"
    
    // MARK: - Storage Keys
    private let customerTokenKey = "com.upayments.example.customerUniqueToken"
    private let apiKeyStorageKey = "com.upayments.example.apiKey"
    private let secretKeyStorageKey = "com.upayments.example.secretKey"
    private let isWhiteLabelStorageKey = "com.upayments.example.isWhiteLabel"
    private let environmentStorageKey = "com.upayments.example.environmentOption"
    private let appleMerchantIdStorageKey = "com.upayments.example.appleMerchantId"
    private let applePayCountryCodeStorageKey = "com.upayments.example.applePayCountryCode"
    private let applePayMerchantNameStorageKey = "com.upayments.example.applePayMerchantName"
    private let applePayRequiresActiveCardsStorageKey = "com.upayments.example.applePayRequiresActiveCards"
    
    // MARK: - Published Properties
    @Published public var apiKey: String {
        didSet {
            UserDefaults.standard.set(apiKey, forKey: apiKeyStorageKey)
        }
    }
    
    @Published public var secretKey: String {
        didSet {
            UserDefaults.standard.set(secretKey, forKey: secretKeyStorageKey)
        }
    }
    
    @Published public var isWhiteLabel: Bool {
        didSet {
            UserDefaults.standard.set(isWhiteLabel, forKey: isWhiteLabelStorageKey)
        }
    }
    
    @Published public var environmentOption: AppEnvironmentOption {
        didSet {
            UserDefaults.standard.set(environmentOption.rawValue, forKey: environmentStorageKey)
        }
    }
    
    @Published public var customerUniqueToken: String {
        didSet {
            UserDefaults.standard.set(customerUniqueToken, forKey: customerTokenKey)
        }
    }
    
    @Published public var appleMerchantId: String {
        didSet {
            UserDefaults.standard.set(appleMerchantId, forKey: appleMerchantIdStorageKey)
        }
    }
    
    @Published public var applePayCountryCode: String {
        didSet {
            UserDefaults.standard.set(applePayCountryCode, forKey: applePayCountryCodeStorageKey)
        }
    }
    
    @Published public var applePayMerchantName: String {
        didSet {
            UserDefaults.standard.set(applePayMerchantName, forKey: applePayMerchantNameStorageKey)
        }
    }

    @Published public var applePayRequiresActiveCards: Bool {
        didSet {
            UserDefaults.standard.set(applePayRequiresActiveCards, forKey: applePayRequiresActiveCardsStorageKey)
        }
    }
    
    @Published public var isInitialized: Bool = false
    @Published public var isInitializing: Bool = false
    @Published public var resolvedSecretKey: String? = nil
    @Published public var initErrorMessage: String? = nil
    @Published public var lastNetworkError: NetworkError? = nil
    
    // MARK: - Computed Properties
    public var currentEnvironment: Environment {
        environmentOption.toSDKEnvironment()
    }
    
    public var isProduction: Bool {
        environmentOption == .production
    }
    
    public var currentApplePayConfiguration: ApplePayConfiguration {
        let merchantId = appleMerchantId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Self.defaultAppleMerchantId : appleMerchantId
        let country = applePayCountryCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Self.defaultAppleCountryCode : applePayCountryCode
        let name = applePayMerchantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Self.defaultAppleMerchantName : applePayMerchantName
        return ApplePayConfiguration(
            merchantIdentifier: merchantId,
            countryCode: country,
            supportedNetworks: [.visa, .masterCard],
            merchantCapabilities: [.capability3DS],
            merchantName: name,
            requiresActiveCards: applePayRequiresActiveCards
        )
    }
    
    // MARK: - Initializer
    private init() {
        let savedIsWhiteLabel = UserDefaults.standard.object(forKey: isWhiteLabelStorageKey) as? Bool ?? true
        let defaultKey = savedIsWhiteLabel ? Self.defaultWhiteLabelKey : Self.defaultSandboxKey
        let savedKey = UserDefaults.standard.string(forKey: apiKeyStorageKey) ?? defaultKey
        let savedSecretKey = UserDefaults.standard.string(forKey: secretKeyStorageKey) ?? ""
        let savedEnvRaw = UserDefaults.standard.string(forKey: environmentStorageKey) ?? AppEnvironmentOption.sandbox.rawValue
        let savedEnv = AppEnvironmentOption(rawValue: savedEnvRaw) ?? .sandbox
        let savedCustomerToken = UserDefaults.standard.string(forKey: customerTokenKey) ?? "1234567890845"
        var savedAppleMerchantId = UserDefaults.standard.string(forKey: appleMerchantIdStorageKey) ?? Self.defaultAppleMerchantId
        if savedAppleMerchantId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || savedAppleMerchantId == "merchant.com.upayments.test" {
            savedAppleMerchantId = Self.defaultAppleMerchantId
            UserDefaults.standard.set(savedAppleMerchantId, forKey: appleMerchantIdStorageKey)
        }
        let savedAppleCountry = UserDefaults.standard.string(forKey: applePayCountryCodeStorageKey) ?? Self.defaultAppleCountryCode
        let savedAppleMerchantName = UserDefaults.standard.string(forKey: applePayMerchantNameStorageKey) ?? Self.defaultAppleMerchantName
        let savedRequiresActive = UserDefaults.standard.bool(forKey: applePayRequiresActiveCardsStorageKey)
        
        self.isWhiteLabel = savedIsWhiteLabel
        self.apiKey = savedKey
        self.secretKey = savedSecretKey
        self.environmentOption = savedEnv
        self.customerUniqueToken = savedCustomerToken
        self.appleMerchantId = savedAppleMerchantId
        self.applePayCountryCode = savedAppleCountry
        self.applePayMerchantName = savedAppleMerchantName
        self.applePayRequiresActiveCards = savedRequiresActive
    }
    
    // MARK: - Preset Helpers
    public func applyWhiteLabelPreset() {
        self.isWhiteLabel = true
        self.apiKey = Self.defaultWhiteLabelKey
        self.secretKey = ""
        self.environmentOption = .sandbox
    }
    
    public func applyStandardPreset() {
        self.isWhiteLabel = false
        self.apiKey = Self.defaultSandboxKey
        self.secretKey = ""
        self.environmentOption = .sandbox
    }
    
    // MARK: - Actions
    /// Configures and initializes the UPayments SDK with the currently set token, environment, whitelabel, and Apple Pay options.
    public func initializeSDK(completion: ((Bool) -> Void)? = nil) {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            self.initErrorMessage = "API Key cannot be empty"
            self.lastNetworkError = NetworkError(reason: "API Key cannot be empty", httpStatusCode: 400)
            self.isInitialized = false
            completion?(false)
            return
        }
        
        self.isInitializing = true
        self.initErrorMessage = nil
        self.lastNetworkError = nil
        
        let trimmedSecret = secretKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let secretParam = trimmedSecret.isEmpty ? nil : trimmedSecret
        
        // Configure native Apple Pay companion options
        UPayments.shared.configureApplePay(currentApplePayConfiguration)
        
        UPayments.configure(
            apiKey: trimmedKey,
            secretKey: secretParam,
            environment: currentEnvironment,
            isWhitelabeled: isWhiteLabel
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isInitializing = false
                switch result {
                case .success(let secret):
                    self.isInitialized = true
                    self.resolvedSecretKey = secret.isEmpty ? "Direct / None required" : secret
                    self.initErrorMessage = nil
                    self.lastNetworkError = nil
                    completion?(true)
                case .failure(let error):
                    self.isInitialized = false
                    self.resolvedSecretKey = nil
                    self.lastNetworkError = error
                    self.initErrorMessage = error.localizedDescription
                    completion?(false)
                }
            }
        }
    }
}
