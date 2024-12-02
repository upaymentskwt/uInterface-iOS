//
//  APIManager.swift
//  uInterfaceSDK
//
//  Created by user on 21/08/24.
//

import Foundation
import WebKit

public var baseURL: String = ""

// MARK: - Class: PaymentAPIManager
/// Implements the payment-related API calls defined in the `PaymentStoreUseCase` protocol
public class PaymentAPIManager: NSObject, PaymentStoreUseCase {
    
    // MARK: - Properties
//    private var baseURL: String = ""
    
    // MARK: - Initialization
    public override init() {}
    
    // MARK: - Methods
    /// Sets the base URL based on the provided environment.
    /// - Parameters:
    ///   - environment: The environment for which the base URL should be set.
    public func setBaseURL(environment: Environment) {
        baseURL = environment.baseURL
    }
    
    // MARK: - API Methods
    
    /// Initiates the payment process using the provided payment request details.
    /// - Parameters:
    ///   - isBackground: A boolean indicating if the payment process is initiated from the background.
    ///   - token: The authentication token used for the request.
    ///   - paymentRequestDetails: The model containing payment request details.
    ///   - controller: The view controller from which the payment process is initiated.
    ///   - completionHandler: A closure that takes a `Result` containing either a `PaymentResult` on success or a `NetworkError` on failure.
    public func createPayment(isBackground: Bool, token: String, paymentRequestDetails: PaymentRequestModel, controller: UIViewController, completionHandler: @escaping (Result<PaymentResult, NetworkError>) -> Void) {
        
        // Construct the payment URL
        guard let url = URL(string: baseURL + APIPath.paymentCharge) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        print("<=================================== '\(APIPath.paymentCharge)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the provided details
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .post, body: paymentRequestDetails.toDictionary())
        
        // Create a URLSession data task to process the payment request
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in

            // Ensure a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle the payment response
                self?.handlePaymentResponse(data: data, error: error, statusCode: httpResponse.statusCode, isBackground: isBackground, paymentRequestDetails: paymentRequestDetails, from: controller, strAPIName: APIPath.paymentCharge, completionHandler: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Initiates the process to create a unique customer token and handles the response.
    /// - Parameters:
    ///   - token: The authentication token used for the request.
    ///   - customerTokenRequestDetail: The model containing the details required to create the customer token.
    ///   - controller: The view controller from which the request is initiated.
    ///   - completionHandler: A closure that takes a `Result` containing either a `CustomerTokenResponseModel` on success or a `NetworkError` on failure.
    public func createCustomerToken(token: String, customerTokenRequestDetail: CustomerTokenRequestModel, controller: UIViewController, completionHandler: @escaping (Result<CustomerTokenResponseModel, NetworkError>) -> Void) {
        
        // Construct the URL for creating a customer token
        guard let url = URL(string: baseURL + APIPath.createCustomerToken) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        print("<=================================== '\(APIPath.createCustomerToken)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the provided details
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .post, body: customerTokenRequestDetail.toDictionary())
        
        // Create a URLSession data task to send the request
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            
            // Ensure a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle the token response
                self?.handleTokenResponse(data: data, statusCode: httpResponse.statusCode, error: error, strApiName: APIPath.createCustomerToken, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Fetches the details of a card using the provided token and request details.
    /// - Parameters:
    ///   - token: The authentication token required for the request.
    ///   - cardRequestDetails: The `TokenDataModel` containing the necessary data to fetch card details.
    ///   - controller: The `UIViewController` instance that is invoking this method, typically used for presenting UI or handling user interaction.
    ///   - completionHandler: A completion handler that returns a `Result` containing either a `[String: Any]` dictionary with the card details on success, or a `NetworkError` on failure.
    public func fetchCardDetails(token: String, cardRequestDetails: TokenDataModel, controller: UIViewController, completionHandler: @escaping(Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        guard let url = URL(string: baseURL + APIPath.retrieveCustomerCards) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.retrieveCustomerCards)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .post, body: cardRequestDetails.toDictionary())
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in

            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle fetch card details response
                self?.handleCardDetailsResponse(data: data, error: error, statusCode: httpResponse.statusCode, strApiName: APIPath.retrieveCustomerCards, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Adds card details to the server.
    /// - Parameters:
    ///   - isBackground: A boolean indicating if the action is performed in the background.
    ///   - token: The authorization token required for the request.
    ///   - cardRequest: A dictionary containing card request details.
    ///   - controller: The view controller from which the request is initiated.
    ///   - completionHandler: A closure that returns a `Result` containing a dictionary on success or a `NetworkError` on failure.
    public func addCardDetails(isBackground: Bool, token: String, cardRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        guard let url = URL(string: baseURL + APIPath.addCustomerCard) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.addCustomerCard)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .post, body: cardRequest)

        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle add card details response
                self?.handleAddCardResponse(isBackground: isBackground, statusCode: httpResponse.statusCode, presentingController: controller, data: data, error: error, strApiName: APIPath.addCustomerCard, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Fetches the details of a refund using the provided token and request details.
    /// - Parameters:
    ///   - token: The authentication token required for the request.
    ///   - refundRequest: The `RefundRequestModel` containing the necessary data to fetch refund details.
    ///   - controller: The `UIViewController` instance that is invoking this method, typically used for presenting UI or handling user interaction.
    ///   - completionHandler: A completion handler that returns a `Result` containing either a `[String: Any]` dictionary with the refund details on success, or a `NetworkError` on failure.
    public func fetchRefundDetails(token: String, refundRequest: RefundRequestModel, controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        guard let url = URL(string: baseURL + APIPath.createRefund) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.createRefund)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .post, body: refundRequest.toDictionary())
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle fetch refund details response
                self?.handleFetchRefundDetailsResponse(data: data, error: error, statusCode: httpResponse.statusCode, strAPIName: APIPath.createRefund, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Checks the status of the payment button.
    /// - Parameters:
    ///   - token: The authorization token required for the request.
    ///   - controller: The view controller from which the request is initiated.
    ///   - completionHandler: A closure that returns a `Result` containing `PaymentButtonStatusModel` on success or a `NetworkError` on failure.
    public func checkPaymentButtonStatus(token: String, controller: UIViewController, completionHandler: @escaping (Result<PaymentButtonStatusModel, NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        guard let url = URL(string: baseURL + APIPath.checkPaymentButtonStatus) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.checkPaymentButtonStatus)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: token, method: .get, body: [:])
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle check payment button status response
                self?.handleCheckPaymentButtonStatusResponse(data: data, error: error, statusCode: httpResponse.statusCode, strApiName: APIPath.checkPaymentButtonStatus, completion: completionHandler)
                
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Fetches the payment status based on a tracking ID.
    /// - Parameters:
    ///   - headerToken: The authorization token for the API call.
    ///   - trackingID: The tracking ID for the payment.
    ///   - controller: The view controller initiating the API call.
    ///   - completion: Completion handler returning the payment status response or error.
    public func fetchPaymentStatus(headerToken: String, trackingID: String, controller: UIViewController, completionHandler: @escaping (Result<PaymentStatusResponseModel, NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        let urlString = baseURL + APIPath.getPaymentStatus + "/" + trackingID
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.getPaymentStatus)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: headerToken, method: .get, body: [:])
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle fetch payment status response
                self?.handleFetchPaymentStatusResponse(data: data, error: error, statusCode: httpResponse.statusCode, strAPIName: APIPath.getPaymentStatus, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Fetches multiple refund details.
    /// - Parameters:
    ///   - headerToken: The authorization token for the API call.
    ///   - refundRequest: The refund request payload.
    ///   - controller: The view controller initiating the API call.
    ///   - completionHandler: Completion handler returning the refund details or error.
    public func fetchMultipleRefundDetails(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        let urlString = baseURL + APIPath.createMultipleRefunds
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.createMultipleRefunds)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: headerToken, method: .post, body: refundRequest)
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle fetch multiple refund details response
                self?.handleFetchMultipleRefundDetailsResponse(data: data, error: error, statusCode: httpResponse.statusCode, strAPIName: APIPath.createMultipleRefunds, completion: completionHandler)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completionHandler(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Creates an invoice using the provided request details in a dictionary format.
    /// - Parameters:
    ///   - headerToken: The authentication token required for the request.
    ///   - invoiceRequest: A `[String: Any]` dictionary containing the invoice details to be created.
    ///   - controller: The `UIViewController` instance that is invoking this method, typically used for presenting UI or handling user interaction.
    ///   - completion: A completion handler that returns a `Result` containing either the `InvoiceCreationModel` on success or a `NetworkError` on failure.
    public func createInvoice(headerToken: String, invoiceRequest: [String: Any], controller: UIViewController, completion: @escaping (Result<InvoiceCreationModel, NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        let urlString = baseURL + APIPath.paymentCharge
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.paymentCharge)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: headerToken, method: .post, body: invoiceRequest)
        
        // Create a data task to send the request and handle the response
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Handle create invoice response
                self?.handleCreateInvoiceResponse(data: data, error: error, statusCode: httpResponse.statusCode, strAPIName: APIPath.paymentCharge, completion: completion)
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completion(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }.resume()
    }

    /// Deletes a refund request from the server.
    /// - Parameters:
    ///   - token: The authorization token required for the request.
    ///   - refundRequest: A dictionary containing refund request details.
    ///   - controller: The view controller from which the request is initiated.
    ///   - completionHandler: A closure that returns a `Result` containing a dictionary on success or a `NetworkError` on failure.
    public func deleteRefund(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        let urlString = baseURL + APIPath.deleteRefund
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.deleteRefund)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: headerToken, method: .post, body: refundRequest)
        
        // Handle the response from the delete refund request
        self.handleDeleteRefundResponse(with: request, strAPIName: APIPath.deleteRefund, completion: completionHandler)
    }

    /// Deletes a multi-vendor refund request from the server.
    /// - Parameters:
    ///   - token: The authorization token required for the request.
    ///   - refundRequest: A dictionary containing refund request details.
    ///   - controller: The view controller from which the request is initiated.
    ///   - completionHandler: A closure that returns a `Result` containing a dictionary on success or a `NetworkError` on failure.
    public func deleteMultiVendorRefund(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Construct the URL from base URL and API path
        let urlString = baseURL + APIPath.deleteMultipleVendorRefunds
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkError(reason: "Invalid URL", httpStatusCode: 400)))
            return
        }
        
        print("<=================================== '\(APIPath.deleteMultipleVendorRefunds)' ===================================>")
        print("API URL: \(url)")
        
        // Configure the URLRequest with the appropriate method and body
        var request = URLRequest(url: url)
        self.configureRequest(&request, withToken: headerToken, method: .post, body: refundRequest)
        
        // Handle the response from the delete refund request
        self.handleDeleteRefundResponse(with: request, strAPIName: APIPath.deleteMultipleVendorRefunds, completion: completionHandler)
    }
}
