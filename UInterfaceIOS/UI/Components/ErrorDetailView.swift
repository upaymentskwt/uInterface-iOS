//
//  ErrorDetailView.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI
import uInterfaceSDK

/// A dedicated in-depth error presentation component displaying status codes,
/// field validation details, and raw server response payloads.
public struct ErrorDetailView: View {
    public let error: NetworkError?
    public let fallbackMessage: String?
    public let onDismiss: (() -> Void)?
    
    @State private var isCopied: Bool = false
    @State private var isShowingRawJSON: Bool = false
    
    public init(
        error: NetworkError?,
        fallbackMessage: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.error = error
        self.fallbackMessage = fallbackMessage
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Header with icon and status code
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.errorColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Operation Failed")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if let code = error?.httpStatusCode {
                        Text("HTTP Status Code: \(code)")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(AppTheme.errorColor)
                    }
                }
                
                Spacer()
                
                if let onDismiss = onDismiss {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Primary Reason
            let primaryMessage = error?.reason ?? fallbackMessage ?? "An unknown network error occurred."
            Text(primaryMessage)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            
            // Sub-details / Field Validation Failures
            if let details = error?.errorDetails, !details.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Validation & Error Details:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    ForEach(details, id: \.self) { item in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.errorColor)
                            Text(item)
                                .font(.system(size: 13))
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            
            // Raw Response Body
            if let raw = error?.rawResponseBody, !raw.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingRawJSON.toggle()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: isShowingRawJSON ? "chevron.down" : "chevron.right")
                                    .font(.system(size: 11, weight: .bold))
                                Text(isShowingRawJSON ? "Hide Raw Response Payload" : "View Raw Response Payload")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundColor(AppTheme.brandPrimary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            UIPasteboard.general.string = raw
                            isCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCopied = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                Text(isCopied ? "Copied" : "Copy")
                            }
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(isCopied ? .green : .secondary)
                        }
                    }
                    
                    if isShowingRawJSON {
                        ScrollView(.horizontal, showsIndicators: true) {
                            Text(raw)
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(Color.black.opacity(0.08))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.errorColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppTheme.errorColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
