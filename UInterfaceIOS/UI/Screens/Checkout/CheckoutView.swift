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
                    
                    // Items & Pricing Card
                    GlassCard(title: "Order Items & Pricing", icon: "cart.fill") {
                        VStack(spacing: 16) {
                            ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, item in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Item #\(index + 1)")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(AppTheme.brandPrimary)
                                        Spacer()
                                        Text(String(format: "Subtotal: %.3f %@", item.itemTotal, viewModel.currency))
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(AppTheme.brandPrimary)
                                        
                                        if viewModel.products.count > 1 {
                                            Button(action: { viewModel.removeItem(at: index) }) {
                                                Image(systemName: "trash.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.red.opacity(0.8))
                                            }
                                            .padding(.leading, 6)
                                        }
                                    }
                                    
                                    FormInputField(
                                        label: "Item Name",
                                        placeholder: "e.g. Single Espresso",
                                        text: $viewModel.products[index].name
                                    )
                                    
                                    HStack(spacing: 10) {
                                        FormInputField(
                                            label: "Unit Price (\(viewModel.currency))",
                                            placeholder: "0.000",
                                            text: $viewModel.products[index].priceText,
                                            keyboardType: .decimalPad
                                        )
                                        
                                        FormInputField(
                                            label: "Qty",
                                            placeholder: "1",
                                            text: $viewModel.products[index].quantityText,
                                            keyboardType: .numberPad
                                        )
                                        .frame(width: 80)
                                    }
                                }
                                
                                if index < viewModel.products.count - 1 {
                                    Divider()
                                        .padding(.vertical, 4)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Button(action: { viewModel.addItem() }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Item")
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppTheme.brandPrimary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Total Order Amount")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.3f %@", viewModel.totalAmount, viewModel.currency))
                                        .font(.system(size: 18, weight: .heavy))
                                        .foregroundColor(AppTheme.brandPrimary)
                                }
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
                    
                    // Checkout Button
                    if viewModel.selectedPaymentSource == "apple-pay" {
                        Button(action: {
                            viewModel.initiatePayment()
                        }) {
                            HStack(spacing: 8) {
                                if viewModel.isProcessing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "applelogo")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Pay with Apple Pay • " + String(format: "%.3f %@", viewModel.totalAmount, viewModel.currency))
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                        }
                        .disabled(viewModel.isProcessing)
                        .padding(.top, 6)
                    } else {
                        ActionButton(
                            title: String(format: "Pay Now • %.3f %@", viewModel.totalAmount, viewModel.currency),
                            icon: "lock.fill",
                            isLoading: viewModel.isProcessing
                        ) {
                            viewModel.initiatePayment()
                        }
                        .padding(.top, 6)
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
                    
                    // Last Transaction Outcome Card
                    if let result = viewModel.lastResult {
                        GlassCard(title: "Transaction Outcome", icon: "creditcard.circle.fill") {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Status")
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    StatusBadge(
                                        title: result.message,
                                        style: (result.transactionDetails.result == "CAPTURED" || result.transactionDetails.result == "SUCCESS") ? .success : ((result.transactionDetails.result == "CANCELED" || result.transactionDetails.result == "CANCELLED") ? .warning : .error)
                                    )
                                }
                                
                                if let resultStr = result.transactionDetails.result, !resultStr.isEmpty {
                                    HStack {
                                        Text("Result Code:")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(resultStr)
                                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    }
                                }
                                
                                Button(action: { viewModel.showResultSheet = true }) {
                                    HStack {
                                        Text("View Full Details")
                                            .font(.system(size: 13, weight: .semibold))
                                        Image(systemName: "arrow.up.right.square")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(AppTheme.brandPrimary)
                                }
                            }
                        }
                    }
                    

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
                                    StatusBadge(title: result.message, style: (result.transactionDetails.result == "CAPTURED" || result.transactionDetails.result == "SUCCESS") ? .success : (result.transactionDetails.result == "CANCELED" ? .warning : .error))
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
