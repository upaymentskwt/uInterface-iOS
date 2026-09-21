//
//  StatusCheckView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct StatusCheckView: View {
    @StateObject private var viewModel = StatusCheckViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Tracking ID Card
                    GlassCard(title: "Track Transaction", icon: "magnifyingglass.circle.fill") {
                        FormInputField(
                            label: "Tracking ID",
                            placeholder: "Enter transaction tracking ID",
                            text: $viewModel.trackingID
                        )
                        
                        ActionButton(
                            title: "Fetch Payment Status",
                            icon: "arrow.triangle.2.circlepath",
                            isLoading: viewModel.isCheckingStatus
                        ) {
                            viewModel.checkPaymentStatus()
                        }
                    }
                    
                    // Payment Status Results
                    if let statusResponse = viewModel.paymentStatusResponse {
                        GlassCard(title: "Payment Details", icon: "doc.plaintext.fill") {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("API Status:")
                                        .font(.system(size: 13, weight: .medium))
                                    Spacer()
                                    StatusBadge(
                                        title: (statusResponse.status ?? false) ? "Success" : "Failed",
                                        style: (statusResponse.status ?? false) ? .success : .error
                                    )
                                }
                                
                                Divider()
                                
                                statusRow(title: "Message", value: statusResponse.message ?? "N/A")
                                
                                if let trans = statusResponse.data?.transaction {
                                    statusRow(title: "Order ID", value: trans.orderId ?? "N/A")
                                    statusRow(title: "Currency", value: trans.currencyType ?? "N/A")
                                    statusRow(title: "Result", value: trans.result ?? "N/A")
                                    statusRow(title: "Payment ID", value: trans.paymentId ?? "N/A")
                                    statusRow(title: "Total Price", value: trans.totalPrice ?? "N/A")
                                    statusRow(title: "Track ID", value: trans.trackId ?? "N/A")
                                }
                            }
                        }
                    }
                    
                    // Button Status Diagnostics
                    GlassCard(title: "Payment Channel Diagnostics", icon: "slider.horizontal.3") {
                        Text("Query which payment buttons (KNET, CC, Apple Pay, etc.) are currently enabled for this merchant account.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        
                        ActionButton(
                            title: "Check Channel Availability",
                            icon: "checkmark.shield",
                            isLoading: viewModel.isCheckingButtons,
                            isSecondary: true
                        ) {
                            viewModel.checkButtonStatus()
                        }
                        
                        if !viewModel.availableButtons.isEmpty {
                            Divider()
                            Text("Enabled Channels:")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.availableButtons, id: \.self) { btn in
                                        StatusBadge(title: btn, style: .info, showIcon: false)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Diagnostics")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Status"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func statusRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
        }
    }
}
