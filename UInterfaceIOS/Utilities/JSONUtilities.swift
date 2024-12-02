//
//  JSONUtilities.swift
//  UInterfaceIOS
//
//  Created by user on 11/09/24.
//

// JSONUtilities.swift
import Foundation

/// Utility methods for handling JSON encoding and decoding.
struct JSONUtilities {
    
    /// Encodes a model to a pretty-printed JSON string and prints it.
        /// - Parameter model: The model to encode. Must conform to `Codable`.
    static func printModelAsJSON<T: Codable>(_ model: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(model)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            debugPrint("Failed to encode model to JSON: \(error)")
        }
    }

    /// Converts a dictionary to a pretty-printed JSON string.
    /// - Parameter dictionary: The dictionary to convert.
    /// - Returns: A JSON string representation of the dictionary, or `nil` if an error occurs.
    static func convertDictionaryToJSONString(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            debugPrint("Error converting dictionary to JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

