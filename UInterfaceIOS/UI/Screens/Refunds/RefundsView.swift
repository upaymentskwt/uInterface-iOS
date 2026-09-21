//
//  RefundsView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct RefundsView: View {
    @StateObject private var viewModel = RefundsViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Mode Picker
                    Picker("Refund Mode", selection: $viewModel.selectedMode) {
                        ForEach(RefundMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    switch viewModel.selectedMode {
                    case .single:
                        singleRefundSection
                    case .multiVendor:
                        multiVendorSection
                    case .delete:
                        deleteSection
                    }
                    
                    // Action Button
                    ActionButton(
                        title: buttonTitle,
                        icon: "arrow.uturn.backward.circle.fill",
                        isLoading: viewModel.isSubmitting
                    ) {
                        viewModel.executeAction()
                    }
                    
                    // Result Card
                    if let result = viewModel.resultMessage {
                        GlassCard(title: "Refund Status", icon: "info.circle.fill") {
                            Text(result)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Refunds")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.selectedMode.rawValue),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var buttonTitle: String {
        switch viewModel.selectedMode {
        case .single: return "Submit Single Refund"
        case .multiVendor: return "Submit Multi-Vendor Refund"
        case .delete: return "Cancel Pending Refund"
        }
    }
    
    private var singleRefundSection: some View {
        GlassCard(title: "Single Refund Details", icon: "person.crop.circle") {
            VStack(spacing: 12) {
                FormInputField(label: "Order ID", placeholder: "ORD_12345", text: $viewModel.orderId)
                FormInputField(label: "Refund Amount", placeholder: "2.50", text: $viewModel.amount, keyboardType: .decimalPad)
                FormInputField(label: "Customer Name", placeholder: "Customer Name", text: $viewModel.customerName)
                FormInputField(label: "Customer Email", placeholder: "customer@example.com", text: $viewModel.customerEmail, keyboardType: .emailAddress)
                FormInputField(label: "Reference", placeholder: "REFUND_REF", text: $viewModel.reference)
            }
        }
    }
    
    private var multiVendorSection: some View {
        VStack(spacing: 16) {
            GlassCard(title: "Vendor 1 Details", icon: "storefront") {
                VStack(spacing: 12) {
                    FormInputField(label: "Amount (KD)", placeholder: "1", text: $viewModel.vendor1Amount, keyboardType: .numberPad)
                    FormInputField(label: "IBAN Number", placeholder: "KW00...", text: $viewModel.vendor1IBAN)
                }
            }
            
            GlassCard(title: "Vendor 2 Details", icon: "storefront") {
                VStack(spacing: 12) {
                    FormInputField(label: "Amount (KD)", placeholder: "1", text: $viewModel.vendor2Amount, keyboardType: .numberPad)
                    FormInputField(label: "IBAN Number", placeholder: "KW00...", text: $viewModel.vendor2IBAN)
                }
            }
        }
    }
    
    private var deleteSection: some View {
        GlassCard(title: "Cancel Refund Request", icon: "trash.fill") {
            FormInputField(
                label: "Order ID to Cancel",
                placeholder: "Order ID of pending refund",
                text: $viewModel.deleteOrderId
            )
        }
    }
}
