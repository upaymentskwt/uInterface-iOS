//
//  CheckoutView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Mode Selector (Single vs Multi Product)
                    Picker("Order Type", selection: $viewModel.isSingleProduct) {
                        Text("Single Item").tag(true)
                        Text("Multiple Items").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Cart Summary Card
                    GlassCard(title: "Order Summary", icon: "cart.fill") {
                        VStack(spacing: 12) {
                            ForEach(viewModel.currentProducts, id: \.name) { product in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(product.name ?? "Product")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Qty: \(Int(product.quantity ?? 1.0))")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(String(format: "%.3f %@", (product.price ?? 0.0) * Double(product.quantity ?? 1.0), viewModel.currency))
                                        .font(.system(size: 14, weight: .bold))
                                }
                                if product.name != viewModel.currentProducts.last?.name {
                                    Divider()
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total Amount")
                                    .font(.system(size: 15, weight: .bold))
                                Spacer()
                                Text(String(format: "%.3f %@", viewModel.totalAmount, viewModel.currency))
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(AppTheme.brandPrimary)
                            }
                        }
                    }
                    
                    // Payment Method (White Label)
                    if config.isWhiteLabel {
                        GlassCard(title: "Payment Channel", icon: "creditcard.fill") {
                            Picker("Source", selection: $viewModel.selectedPaymentSource) {
                                ForEach(viewModel.availableSources, id: \.id) { source in
                                    Text(source.name).tag(source.id)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    // Customer Details Card
                    GlassCard(title: "Customer Details", icon: "person.fill") {
                        VStack(spacing: 12) {
                            FormInputField(label: "Full Name", placeholder: "Customer Name", text: $viewModel.customerName)
                            FormInputField(label: "Email Address", placeholder: "customer@example.com", text: $viewModel.customerEmail, keyboardType: .emailAddress)
                            FormInputField(label: "Mobile Number", placeholder: "965XXXXXXXX", text: $viewModel.customerMobile, keyboardType: .phonePad)
                        }
                    }
                    
                    // Live Error Banner (if any)
                    if let error = viewModel.lastNetworkError {
                        ErrorDetailView(error: error) {
                            viewModel.lastNetworkError = nil
                        }
                    }
                    
                    // Checkout Button
                    ActionButton(
                        title: String(format: "Pay Now • %.3f %@", viewModel.totalAmount, viewModel.currency),
                        icon: "lock.fill",
                        isLoading: viewModel.isProcessing
                    ) {
                        viewModel.initiatePayment()
                    }
                    .padding(.top, 6)
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Checkout Demo")
            .sheet(isPresented: $viewModel.showResultSheet) {
                resultView
            }
        }
    }
    
    // Result Inspection Modal
    private var resultView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let result = viewModel.lastResult {
                        GlassCard(title: "Payment Result", icon: "checkmark.circle.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Status")
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    StatusBadge(title: result.message, style: (result.transactionDetails.result == "CAPTURED" || result.transactionDetails.result == "SUCCESS") ? .success : .info)
                                }
                                
                                Divider()
                                
                                resultRow(title: "Payment ID", value: result.transactionDetails.paymentID ?? "N/A")
                                resultRow(title: "Transaction ID", value: result.transactionDetails.transactionID ?? "N/A")
                                resultRow(title: "Result Code", value: result.transactionDetails.result ?? "N/A")
                                resultRow(title: "Reference ID", value: result.transactionDetails.reference ?? "N/A")
                                resultRow(title: "Track ID", value: result.transactionDetails.trackingID ?? "N/A")
                                resultRow(title: "Post Date", value: result.transactionDetails.postingDate ?? "N/A")
                            }
                        }
                    } else if let error = viewModel.lastNetworkError {
                        ErrorDetailView(error: error)
                    }
                    
                    ActionButton(title: "Dismiss", isSecondary: true) {
                        viewModel.showResultSheet = false
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Transaction Outcome")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.showResultSheet = false
                    }
                }
            }
        }
    }
    
    private func resultRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .lineLimit(1)
        }
    }
}
