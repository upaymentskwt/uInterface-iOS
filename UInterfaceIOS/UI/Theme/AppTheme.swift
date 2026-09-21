//
//  AppTheme.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

/// Design system tokens and styling helpers for UPayments Example App.
public enum AppTheme {
    
    // MARK: - Colors
    public static let brandPrimary = Color(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0)
    public static let brandSecondary = Color(red: 90.0/255.0, green: 51.0/255.0, blue: 217.0/255.0)
    public static let brandGradient = LinearGradient(
        colors: [brandPrimary, brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let successColor = Color(red: 0.0/255.0, green: 176.0/255.0, blue: 116.0/255.0)
    public static let errorColor = Color(red: 220.0/255.0, green: 53.0/255.0, blue: 69.0/255.0)
    public static let warningColor = Color(red: 245.0/255.0, green: 158.0/255.0, blue: 11.0/255.0)
    public static let infoColor = Color(red: 14.0/255.0, green: 165.0/255.0, blue: 233.0/255.0)
    
    public static let background = Color(UIColor.systemGroupedBackground)
    public static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    public static let elevatedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    public static let separator = Color(UIColor.separator).opacity(0.4)
    
    // MARK: - Radius
    public static let cornerRadiusSmall: CGFloat = 8
    public static let cornerRadiusMedium: CGFloat = 14
    public static let cornerRadiusLarge: CGFloat = 20
    
    // MARK: - Shadows
    public static let cardShadow = Shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    
    public struct Shadow {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
    }
}

// MARK: - View Modifiers
public struct GlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat = AppTheme.cornerRadiusMedium
    
    public func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.separator, lineWidth: 0.5)
            )
            .shadow(
                color: AppTheme.cardShadow.color,
                radius: AppTheme.cardShadow.radius,
                x: AppTheme.cardShadow.x,
                y: AppTheme.cardShadow.y
            )
    }
}

public extension View {
    func glassCardStyle(cornerRadius: CGFloat = AppTheme.cornerRadiusMedium) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}
