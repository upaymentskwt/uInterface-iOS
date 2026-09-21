//
//  GlassCard.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

public struct GlassCard<Content: View>: View {
    public let title: String?
    public let icon: String?
    public let content: Content
    
    public init(title: String? = nil, icon: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let title = title {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(AppTheme.brandPrimary)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                Divider()
                    .background(AppTheme.separator)
            }
            content
        }
        .padding(16)
        .glassCardStyle()
    }
}
