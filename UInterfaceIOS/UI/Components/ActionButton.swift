//
//  ActionButton.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

public struct ActionButton: View {
    public let title: String
    public let icon: String?
    public let isLoading: Bool
    public let isSecondary: Bool
    public let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isSecondary: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isSecondary = isSecondary
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: isSecondary ? AppTheme.brandPrimary : .white))
                        .scaleEffect(0.9)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundColor(isSecondary ? AppTheme.brandPrimary : .white)
            .background(
                Group {
                    if isSecondary {
                        Color.clear
                    } else {
                        AppTheme.brandGradient
                    }
                }
            )
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                    .stroke(isSecondary ? AppTheme.brandPrimary.opacity(0.4) : Color.clear, lineWidth: 1.5)
            )
            .shadow(
                color: isSecondary ? Color.clear : AppTheme.brandPrimary.opacity(0.25),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.75 : 1.0)
    }
}
