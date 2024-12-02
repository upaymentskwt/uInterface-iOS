//
//  ApprovedKeysModel.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

/// A structure that holds a list of approved keys for validation or access control.
/// - Note: This structure contains static keys that should not be modified.
public struct ApprovedKeysModel {
    
    /// An array of approved keys for specific operations.
    /// - Usage: These keys can be used for authentication or verification purposes within the application.
    public static let approvedKeys: [String] = ["12345", "asdfge"]
}
