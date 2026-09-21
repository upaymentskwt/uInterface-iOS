//
//  CardManagementView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct CardManagementView: View {
    @StateObject private var viewModel = CardManagementViewModel()
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Profile Header Card
                    GlassCard(title: "Customer Tokenization", icon: "person.badge.shield.checkmark") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Customer Token:")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(config.customerUniqueToken)
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                            }
                            
                            HStack(spacing: 12) {
                                ActionButton(
                                    title: "Generate Token",
                                    icon: "arrow.triangle.2.circlepath",
                                    isLoading: viewModel.isGeneratingToken,
                                    isSecondary: true
                                ) {
                                    viewModel.createCustomerToken()
                                }
                                
                                ActionButton(
                                    title: "Save New Card",
                                    icon: "plus.creditcard",
                                    isLoading: viewModel.isAddingCard
                                ) {
                                    viewModel.addCard()
                                }
                            }
                        }
                    }
                    
                    // In-depth Error Banner
                    if let error = viewModel.lastNetworkError {
                        ErrorDetailView(error: error) {
                            viewModel.lastNetworkError = nil
                        }
                    }
                    
                    // Operation Status Banner
                    if let alertMsg = viewModel.alertMessage, !viewModel.showAlert {
                        GlassCard(title: "Card Status", icon: "info.circle.fill") {
                            HStack {
                                Text(alertMsg)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button("Dismiss") {
                                    viewModel.alertMessage = nil
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(AppTheme.brandPrimary)
                            }
                        }
                    }
                    
                    // Saved Cards Section
                    HStack {
                        Text("Saved Payment Methods")
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                        Button(action: viewModel.fetchSavedCards) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 12, weight: .bold))
                                Text("Refresh")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(AppTheme.brandPrimary)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.brandPrimary))
                            Text("Fetching saved cards...")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else if viewModel.savedCards.isEmpty && viewModel.lastNetworkError == nil {
                        VStack(spacing: 12) {
                            Image(systemName: "creditcard")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary.opacity(0.5))
                            Text("No saved cards found")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("Tap 'Save New Card' above to tokenize a card.")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(Array(viewModel.savedCards.enumerated()), id: \.offset) { _, card in
                            cardView(for: card)
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Cards")
            .onAppear {
                viewModel.fetchSavedCards()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Card Operation"),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Render an elegant credit card tile
    private func cardView(for card: CardInfoModel) -> some View {
        let cardTx = card.sourceOfFunds?.providedCardInfoModel?.cardTransaction
        let brand = cardTx?.brandName?.uppercased() ?? (card.sourceOfFunds?.fundType?.uppercased() ?? "CARD")
        let cardNumber = cardTx?.cardNumber ?? "•••• •••• •••• ••••"
        let expiry = cardTx?.expiryDate ?? "MM/YY"
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(brand)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.85))
                Spacer()
                Image(systemName: "wave.3.forward")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
            }
            
            Spacer()
            
            Text(cardNumber)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .tracking(2)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("CARD TOKEN")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    Text(card.token ?? "N/A")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("EXPIRES")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    Text(expiry)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(18)
        .frame(height: 160)
        .background(
            LinearGradient(
                colors: [Color(red: 30/255, green: 34/255, blue: 54/255), Color(red: 48/255, green: 22/255, blue: 140/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.cornerRadiusLarge)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)
    }
}
