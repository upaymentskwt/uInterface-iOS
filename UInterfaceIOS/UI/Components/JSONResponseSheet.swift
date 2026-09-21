//
//  JSONResponseSheet.swift
//  UInterfaceIOS
//
//  Created by Siyahul Haq on 21/09/26.
//

import SwiftUI

public struct JSONResponseSheet: View {
    public let title: String
    public let jsonString: String
    @Environment(\.presentationMode) var presentationMode
    @State private var copied: Bool = false
    
    public init(title: String, jsonString: String) {
        self.title = title
        self.jsonString = jsonString
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    Text(jsonString)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.elevatedBackground)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .padding()
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    ActionButton(
                        title: copied ? "Copied!" : "Copy JSON",
                        icon: copied ? "checkmark" : "doc.on.doc",
                        isSecondary: true
                    ) {
                        UIPasteboard.general.string = jsonString
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            copied = false
                        }
                    }
                    
                    ActionButton(title: "Done", icon: nil) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
