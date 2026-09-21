//
//  SettingsView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - SDK Live Status
                    GlassCard(title: "SDK Runtime Status", icon: "shield.checkerboard") {
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Authentication & Gateway")
                                        .font(.system(size: 15, weight: .semibold))
                                    Text(config.isInitialized ? "Active & Ready" : (config.initErrorMessage ?? "Not Initialized"))
                                        .font(.system(size: 13))
                                        .foregroundColor(config.isInitialized ? .secondary : AppTheme.errorColor)
                                }
                                Spacer()
                                StatusBadge(
                                    title: config.isInitialized ? "Ready" : (config.isInitializing ? "Initializing" : "Unverified"),
                                    style: config.isInitialized ? .success : (config.isInitializing ? .warning : .error)
                                )
                            }
                            
                            Divider()
                            
                            // Environment & Mode Badges
                            HStack(spacing: 8) {
                                Label(config.environmentOption.rawValue, systemImage: "globe")
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.12))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                                
                                Label(config.isWhiteLabel ? "White-Label" : "Standard", systemImage: config.isWhiteLabel ? "tag.fill" : "cube.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.purple.opacity(0.12))
                                    .foregroundColor(.purple)
                                    .cornerRadius(6)
                                
                                Spacer()
                            }
                            
                            if let secret = config.resolvedSecretKey {
                                Divider()
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("HMAC Secret Key")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Text(secret)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(AppTheme.brandPrimary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                            }
                            
                            if let error = config.lastNetworkError {
                                Divider()
                                ErrorDetailView(error: error) {
                                    config.lastNetworkError = nil
                                }
                            }
                        }
                    }
                    
                    // MARK: - Integration Mode & Quick Presets
                    GlassCard(title: "Integration Mode & Presets", icon: "slider.horizontal.3") {
                        VStack(spacing: 14) {
                            Toggle("White-Label Mode", isOn: $viewModel.isWhiteLabel)
                                .font(.system(size: 14, weight: .medium))
                                .tint(AppTheme.brandPrimary)
                            
                            Text("Quick Presets:")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    viewModel.applyPreset(isWhiteLabel: true)
                                }) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                        Text("White-Label Sandbox")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.brandPrimary.opacity(0.12))
                                    .foregroundColor(AppTheme.brandPrimary)
                                    .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    viewModel.applyPreset(isWhiteLabel: false)
                                }) {
                                    HStack {
                                        Image(systemName: "cube")
                                        Text("Standard Sandbox")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .foregroundColor(.primary)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Target Environment Selection
                    GlassCard(title: "Target Environment", icon: "globe") {
                        VStack(spacing: 12) {
                            Picker("Environment", selection: $viewModel.selectedEnvironment) {
                                ForEach(AppEnvironmentOption.allCases) { env in
                                    Text(env.rawValue).tag(env)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if viewModel.selectedEnvironment == .custom {
                                FormInputField(
                                    label: "Custom API Base URL",
                                    placeholder: "https://custom-gateway.upayments.com/api/v1/",
                                    text: $viewModel.customURLInput,
                                    keyboardType: .URL
                                )
                            }
                            
                            Text("Base URL: \(viewModel.selectedEnvironment.toSDKEnvironment(customURL: viewModel.customURLInput).baseURL)")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    // MARK: - API Credentials Configuration
                    GlassCard(title: "API Credentials", icon: "key.fill") {
                        VStack(spacing: 14) {
                            FormInputField(
                                label: "API Key / Token",
                                placeholder: "Enter merchant API Key",
                                text: $viewModel.customKeyInput
                            )
                            
                            FormInputField(
                                label: "HMAC Secret Key (Optional)",
                                placeholder: "Leave empty to auto-resolve from server",
                                text: $viewModel.customSecretKeyInput
                            )
                        }
                    }
                    
                    // MARK: - Customer Identifier
                    GlassCard(title: "Customer Tokenization", icon: "person.crop.circle.badge.checkmark") {
                        FormInputField(
                            label: "Customer Unique Identifier",
                            placeholder: "e.g. 1234567890845",
                            text: $viewModel.customerTokenInput,
                            keyboardType: .numberPad
                        )
                    }
                    
                    // MARK: - Save & Apply Action
                    ActionButton(
                        title: "Save & Initialize SDK",
                        icon: "bolt.fill",
                        isLoading: config.isInitializing
                    ) {
                        viewModel.saveAndInitialize()
                    }
                    
                    // Footer Info
                    VStack(spacing: 6) {
                        Text("uInterfaceSDK v1.0.4 • Clean Architecture")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("Active Endpoint: \(config.currentEnvironment.baseURL)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(.secondary.opacity(0.8))
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("SDK Settings")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("SDK Configuration"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
