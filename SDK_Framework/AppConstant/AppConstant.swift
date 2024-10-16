//
//  AppConstants.swift
//  uInterfaceSDK
//
//  Created by user on 14/08/24.
//

import Foundation

// MARK: - API Constants
/// Contains constants related to API headers and content types.
public enum APIConstants {
    
    /// Constants related to HTTP headers used in API requests.
    public enum Headers {
        /// Key for the Authorization header used to pass authentication tokens.
        public static let authorization = "Authorization"
        
        /// Key for the Content-Type header used to specify the format of the request body.
        public static let contentType = "Content-Type"
        public static let accept = "accept"
    }
    
    /// Common content types used in the request and response of API calls.
    public enum ContentTypes {
        /// Content type for data in JSON format.
        public static let json = "application/json"
        
        /// Content type for form URL-encoded data, often used in web forms.
        public static let formUrlEncoded = "application/x-www-form-urlencoded"
    }
    
    /// Custom content types that may be used for specialized API requests.
    public enum CustomContentTypes {
        /// Custom content type for JSON data, identical to the standard JSON type.
        public static let customJSON = "application/json"
        
        /// Custom content type for form URL-encoded data. Corrected to match the standard JSON MIME type.
        public static let customFormUrlEncoded = "application/json" // Fixed to match standard MIME type
    }
}

// MARK: - API Types
/// Defines common HTTP method types for making API requests.
enum HTTPMethodType {
    
    /// HTTP POST method, typically used to create resources on the server.
    static let post = "POST"
    
    /// HTTP GET method, typically used to retrieve resources from the server.
    static let get = "GET"
}

// MARK: - API Paths
/// Contains API endpoint paths for various actions like payments, customer management, and refunds.
enum APIPath {
    
    // MARK: Payment-related paths
    /// API path for testing payment functionality.
    static let payment = "test-payment"
    /// API path for live payment requests.
    static let livePaymentRequest = "payment-request"
    /// API path for processing a payment charge.
    static let paymentCharge = "charge"
    
    // MARK: Customer card-related paths
    /// API path for creating a unique customer token.
    static let createCustomerToken = "create-customer-unique-token-sdk"
    /// API path for retrieving saved customer cards.
    static let retrieveCustomerCards = "retrieve-customer-cards"
    /// API path for adding a new customer card.
    static let addCustomerCard = "add-card"
    
    // MARK: Refund-related paths
    /// API path for initiating a refund.
    static let createRefund = "create-refund"
    /// API path for initiating multiple refunds for vendors.
    static let createMultipleRefunds = "create-multivendor-refund"
    /// API path for deleting a refund.
    static let deleteRefund = "delete-refund"
    /// API path for deleting multiple vendor refunds.
    static let deleteMultipleVendorRefunds = "delete-multivendor-refund"
    
    // MARK: Payment status-related paths
    /// API path to check the status of the payment button.
    static let checkPaymentButtonStatus = "check-payment-button-status"
    /// API path to retrieve the status of a payment.
    static let getPaymentStatus = "get-payment-status"
}

// MARK: - Response Statuses
/// Defines possible statuses for API responses.
enum ResponseStatus {
    /// Status indicating that the request was successful.
    static let success = "success"
    
    /// Status indicating that the request failed, with generic error messages.
    static let failure = "errors" // Adjusted to a generic term "failure"
}

// MARK: - Error Codes
/// Defines error codes for various error conditions, using raw string values.
enum ErrorCode: String {
    
    /// Error code indicating that the merchant ID is missing from the request.
    case missingMerchantID = "merchant_id_missing"
    
    /// Error code indicating that the username is missing from the request.
    case missingUsername = "username_missing"
}

// MARK: - HTTP Headers
/// Struct for defining default HTTP headers used in API requests.
struct HTTPHeaders {
    
    /// Default headers used for API requests, including `Accept` and `Content-Type` for JSON data.
    static let defaultHeaders: [String: String] = [
        "Accept": APIConstants.ContentTypes.json,
        "Content-Type": APIConstants.ContentTypes.json
    ]
}

// MARK: - HTTP Methods
/// Enum representing HTTP methods commonly used in network requests.
public enum HTTPMethod: String {
    /// HTTP GET method, typically used for retrieving data.
    case get = "GET"
    /// HTTP POST method, typically used for sending data to the server.
    case post = "POST"
    /// HTTP PUT method, typically used for updating existing resources.
    case put = "PUT"
    /// HTTP DELETE method, typically used for deleting resources on the server.
    case delete = "DELETE"
}

// MARK: - Environment Type
/// Enumeration to define different environments for setting the base URL.
public enum Environment {
    case production
    case sandbox
    case defaultEnvironment
    
    var baseURL: String {
        switch self {
        case .production:
            return "https://apiv2api.upayments.com/api/v1/"
        case .sandbox:
            return "https://sandboxapi.upayments.com/api/v1/"
        case .defaultEnvironment:
            return "https://api.upayments.com/"
        }
    }
}
