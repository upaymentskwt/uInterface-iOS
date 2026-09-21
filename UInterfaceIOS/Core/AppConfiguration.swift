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
    case defaultEnv = "Default (Live)"
    case custom = "Custom"
    
    public var id: String { rawValue }
    
    public func toSDKEnvironment(customURL: String = "") -> Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .production:
            return .production
        case .defaultEnv:
            return .defaultEnvironment
        case .custom:
            return .custom(baseURL: customURL.isEmpty ? "https://sandboxapi.upayments.com/api/v1/" : customURL)
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
    
    // MARK: - Storage Keys
    private let customerTokenKey = "com.upayments.example.customerUniqueToken"
    private let apiKeyStorageKey = "com.upayments.example.apiKey"
    private let secretKeyStorageKey = "com.upayments.example.secretKey"
    private let isWhiteLabelStorageKey = "com.upayments.example.isWhiteLabel"
    private let environmentStorageKey = "com.upayments.example.environmentOption"
    private let customURLStorageKey = "com.upayments.example.customBaseURL"
    
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
    
    @Published public var customBaseURL: String {
        didSet {
            UserDefaults.standard.set(customBaseURL, forKey: customURLStorageKey)
        }
    }
    
    @Published public var customerUniqueToken: String {
        didSet {
            UserDefaults.standard.set(customerUniqueToken, forKey: customerTokenKey)
        }
    }
    
    @Published public var isInitialized: Bool = false
    @Published public var isInitializing: Bool = false
    @Published public var resolvedSecretKey: String? = nil
    @Published public var initErrorMessage: String? = nil
    @Published public var lastNetworkError: NetworkError? = nil
    
    // MARK: - Computed Properties
    public var currentEnvironment: Environment {
        environmentOption.toSDKEnvironment(customURL: customBaseURL)
    }
    
    public var isProduction: Bool {
        environmentOption == .production
    }
    
    // MARK: - Initializer
    private init() {
        let savedIsWhiteLabel = UserDefaults.standard.object(forKey: isWhiteLabelStorageKey) as? Bool ?? true
        let defaultKey = savedIsWhiteLabel ? Self.defaultWhiteLabelKey : Self.defaultSandboxKey
        let savedKey = UserDefaults.standard.string(forKey: apiKeyStorageKey) ?? defaultKey
        let savedSecretKey = UserDefaults.standard.string(forKey: secretKeyStorageKey) ?? ""
        let savedEnvRaw = UserDefaults.standard.string(forKey: environmentStorageKey) ?? AppEnvironmentOption.sandbox.rawValue
        let savedEnv = AppEnvironmentOption(rawValue: savedEnvRaw) ?? .sandbox
        let savedCustomURL = UserDefaults.standard.string(forKey: customURLStorageKey) ?? "https://sandboxapi.upayments.com/api/v1/"
        let savedCustomerToken = UserDefaults.standard.string(forKey: customerTokenKey) ?? "1234567890845"
        
        self.isWhiteLabel = savedIsWhiteLabel
        self.apiKey = savedKey
        self.secretKey = savedSecretKey
        self.environmentOption = savedEnv
        self.customBaseURL = savedCustomURL
        self.customerUniqueToken = savedCustomerToken
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
    /// Configures and initializes the UPayments SDK with the currently set token, environment, and whitelabel options.
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
