//
//  InvoicingView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct InvoicingView: View {
    @StateObject private var viewModel = InvoicingViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header Card
                    GlassCard(title: "Invoice Generation", icon: "doc.text.fill") {
                        Text("Create payment invoices dynamically and receive shareable checkout URLs for your customers.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    // Invoice Details
                    GlassCard(title: "Invoice Amount & Info", icon: "creditcard.fill") {
                        HStack(spacing: 12) {
                            FormInputField(
                                label: "Total Price",
                                placeholder: "25.00",
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
                            placeholder: "Description of invoice items",
                            text: $viewModel.orderDescription
                        )
                    }
                    
                    // Customer Details
                    GlassCard(title: "Recipient Information", icon: "person.fill") {
                        VStack(spacing: 12) {
                            FormInputField(label: "Customer Name", placeholder: "Full Name", text: $viewModel.customerName)
                            FormInputField(label: "Customer Email", placeholder: "Email", text: $viewModel.customerEmail, keyboardType: .emailAddress)
                            FormInputField(label: "Mobile Number", placeholder: "Phone with country code", text: $viewModel.customerMobile, keyboardType: .phonePad)
                        }
                    }
                    
                    // Create Button
                    ActionButton(
                        title: "Generate Invoice",
                        icon: "paperplane.fill",
                        isLoading: viewModel.isGenerating
                    ) {
                        viewModel.createInvoice()
                    }
                    
                    // Display created invoice link if available
                    if let invoice = viewModel.createdInvoice {
                        GlassCard(title: "Invoice Generated", icon: "checkmark.seal.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                StatusBadge(
                                    title: (invoice.isSuccess ?? false) ? "Created Successfully" : "Status Pending",
                                    style: (invoice.isSuccess ?? false) ? .success : .warning
                                )
                                
                                if let url = invoice.details?.invoiceUrl, let invoiceURL = URL(string: url) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Payment Link:")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondary)
                                        
                                        Link(destination: invoiceURL) {
                                            HStack {
                                                Text(url)
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundColor(AppTheme.brandPrimary)
                                                    .lineLimit(1)
                                                    .truncationMode(.middle)
                                                Image(systemName: "arrow.up.right.square")
                                                    .font(.system(size: 13))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Invoicing")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Invoice"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
