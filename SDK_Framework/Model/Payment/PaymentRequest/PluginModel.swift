//
//  PluginModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing a plugin with an optional source URL.
/// This structure is used to define a plugin, including its source URL from where it can be loaded or accessed.
public struct PluginModel: Codable {
    
    /// The URL or path to the source of the plugin.
    public var sourceURL: String?

    private enum CodingKeys: String, CodingKey {
        case sourceURL = "src"
    }

    /// Initializes a new instance of `Plugin`.
    ///
    /// - Parameter 
    ///   - sourceURL: An optional URL or path to the plugin's source.
    public init(sourceURL: String? = nil) {
        self.sourceURL = sourceURL
    }
}
