//
//  AutoDeductView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct AutoDeductView: View {
    @StateObject private var viewModel = AutoDeductViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header card
                    GlassCard(title: "Recurring Billing", icon: "arrow.triangle.2.circlepath.circle.fill") {
                        Text("Auto-deduct allows backend or background charging of a previously tokenized customer card without prompting for 3D Secure or web views.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    // Card Token Input
                    GlassCard(title: "Card Token", icon: "creditcard.and.123") {
                        FormInputField(
                            label: "Saved Card Token",
                            placeholder: "Enter card token (from Cards tab)",
                            text: $viewModel.cardToken
                        )
                    }
                    
                    // Charge Amount & Order Details
                    GlassCard(title: "Charge Parameters", icon: "banknote.fill") {
                        HStack(spacing: 12) {
                            FormInputField(
                                label: "Amount",
                                placeholder: "0.01",
                                text: $viewModel.amount,
                                keyboardType: .decimalPad
                            )
                            
                            FormInputField(
                                label: "Currency",
                                placeholder: "KWD",
                                text: $viewModel.currency
                            )
                            .frame(width: 100)
                        }
                        
                        FormInputField(
                            label: "Description",
                            placeholder: "Charge memo",
                            text: $viewModel.orderDescription
                        )
                    }
                    
                    // Customer Details
                    GlassCard(title: "Customer Metadata", icon: "person.text.rectangle.fill") {
                        VStack(spacing: 12) {
                            FormInputField(label: "Name", placeholder: "Full Name", text: $viewModel.customerName)
                            FormInputField(label: "Email", placeholder: "Email", text: $viewModel.customerEmail, keyboardType: .emailAddress)
                            FormInputField(label: "Mobile", placeholder: "Mobile Number", text: $viewModel.customerMobile, keyboardType: .phonePad)
                        }
                    }
                    
                    // Execute Button
                    ActionButton(
                        title: "Execute Auto-Deduct",
                        icon: "bolt.fill",
                        isLoading: viewModel.isProcessing
                    ) {
                        viewModel.executeAutoDeduct()
                    }
                    
                    // View raw JSON button if available
                    if let json = viewModel.responseJSON {
                        ActionButton(
                            title: "Inspect Last Response JSON",
                            icon: "curlybraces",
                            isSecondary: true
                        ) {
                            viewModel.showJSONSheet = true
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Auto-Deduct")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Auto-Deduct Result"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $viewModel.showJSONSheet) {
                if let json = viewModel.responseJSON {
                    JSONResponseSheet(title: "Auto-Deduct Response", jsonString: json)
                }
            }
        }
    }
}
