//
//  FormInputField.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

public struct FormInputField: View {
    public let label: String
    public let placeholder: String
    @Binding public var text: String
    public var keyboardType: UIKeyboardType = .default
    public var prefix: String? = nil
    
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        prefix: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.prefix = prefix
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                if let prefix = prefix {
                    Text(prefix)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.brandPrimary)
                }
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 15))
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary.opacity(0.6))
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(AppTheme.elevatedBackground)
            .cornerRadius(AppTheme.cornerRadiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                    .stroke(AppTheme.separator, lineWidth: 0.8)
            )
        }
    }
}
