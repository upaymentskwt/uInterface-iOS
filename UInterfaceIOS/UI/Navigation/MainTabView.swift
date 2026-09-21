//
//  MainTabView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

public struct MainTabView: View {
    @ObservedObject private var config = AppConfiguration.shared
    
    public init() {}
    
    public var body: some View {
        TabView {
            CheckoutView()
                .tabItem {
                    Label("Checkout", systemImage: "cart.fill")
                }
            
            CardManagementView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
            
            AutoDeductView()
                .tabItem {
                    Label("Auto-Deduct", systemImage: "arrow.triangle.2.circlepath")
                }
            
            InvoicingView()
                .tabItem {
                    Label("Invoices", systemImage: "doc.text.fill")
                }
            
            RefundsView()
                .tabItem {
                    Label("Refunds", systemImage: "arrow.uturn.backward.circle.fill")
                }
            
            StatusCheckView()
                .tabItem {
                    Label("Status", systemImage: "magnifyingglass.circle.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(AppTheme.brandPrimary)
        .onAppear {
            config.initializeSDK()
        }
    }
}
