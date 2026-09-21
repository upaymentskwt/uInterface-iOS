//
//  StatusBadge.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

public enum BadgeStyle {
    case success
    case warning
    case error
    case info
    case neutral
    
    var color: Color {
        switch self {
        case .success: return AppTheme.successColor
        case .warning: return AppTheme.warningColor
        case .error: return AppTheme.errorColor
        case .info: return AppTheme.infoColor
        case .neutral: return Color.secondary
        }
    }
    
    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .neutral: return "circle.fill"
        }
    }
}

public struct StatusBadge: View {
    public let title: String
    public let style: BadgeStyle
    public var showIcon: Bool = true
    
    public init(title: String, style: BadgeStyle, showIcon: Bool = true) {
        self.title = title
        self.style = style
        self.showIcon = showIcon
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            if showIcon {
                Image(systemName: style.iconName)
                    .font(.system(size: 11, weight: .bold))
            }
            Text(title)
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(style.color)
        .background(style.color.opacity(0.12))
        .clipShape(Capsule())
    }
}
