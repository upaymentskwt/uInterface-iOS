//
//  ReferenceModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing a reference with an optional identifier.
/// This structure is used to hold a unique identifier that may be used to refer to an object or resource.
public struct ReferenceModel: Codable {
    
    /// The unique identifier for the reference.
    public let referenceId: String?
    
    enum CodingKeys: String, CodingKey {
        case referenceId = "id"
    }

    /// Initializes a new instance of `ReferenceModel`.
    /// - Parameter 
    ///   - uniqueID: An optional unique identifier for the reference.
    public init(referenceId: String? = nil) {
        self.referenceId = referenceId
    }
}
