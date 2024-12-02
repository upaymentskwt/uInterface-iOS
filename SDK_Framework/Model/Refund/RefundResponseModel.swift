//
//  RefundResponseModel.swift
//  uInterfaceSDK
//
//  Created by user on 20/08/24.
//

import Foundation

/// A model representing the response received after a refund request.
public struct RefundResponseModel: Codable {
    
    /// Indicates whether the refund request was successful.
    public var status: Bool?
    
    /// A message providing additional information about the refund request status.
    public var message: String?
    
    /// Additional data related to the refund response, such as error codes.
    public var data: RefundResponseDetailsModel?
    
    /// Initializes a new `RefundResponse` instance with optional parameters.
    public init(status: Bool? = nil, message: String? = nil, data: RefundResponseDetailsModel? = nil) {
        self.status = status
        self.message = message
        self.data = data
    }
}

/// A model representing additional details included in the refund response.
public struct RefundResponseDetailsModel: Codable {
    
    /// A code indicating the specific error, if any, that occurred during the refund process.
    public var errorCode: String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
    }
    
    /// Initializes a new `RefundResponseDetails` instance with an optional error code.
    public init(errorCode: String? = nil) {
        self.errorCode = errorCode
    }
}
