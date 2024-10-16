//
//  Encodable+JSON.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

extension Encodable {
    /// Converts an `Encodable` object to a dictionary with JSON representation.
    /// - Returns: A dictionary containing the JSON representation of the object, or an empty dictionary if encoding fails.
    public func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self)
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return jsonObject
            }
        } catch {
            debugPrint("Failed to encode object to JSON: \(error)")
        }
        
        return [:]
    }
}
