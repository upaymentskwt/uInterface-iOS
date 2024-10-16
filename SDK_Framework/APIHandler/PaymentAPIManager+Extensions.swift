//
//  PaymentAPIManager+Extensions.swift
//  uInterfaceSDK
//
//  Created by user on 29/08/24.
//

import Foundation
import UIKit

extension PaymentAPIManager {
    
    /// Configures a URLRequest with the specified HTTP method, authorization token, and body.
    /// - Parameters:
    ///   - request: The URLRequest to be configured.
    ///   - token: The authorization token to be added to the request's headers.
    ///   - method: The HTTP method (GET, POST, etc.) to be set for the request.
    ///   - body: The JSON body to be added to the request. This dictionary will be serialized to JSON data if non-empty.
    func configureRequest(_ request: inout URLRequest, withToken token: String, method: HTTPMethod, body: [String: Any]) {
        
        // Set the Content-Type to JSON
        request.setValue(APIConstants.ContentTypes.json, forHTTPHeaderField: APIConstants.Headers.contentType)
        request.setValue(APIConstants.ContentTypes.json, forHTTPHeaderField: APIConstants.Headers.accept)
        
        if !token.isEmpty {
            // Add the Authorization header using the provided token
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        print("HTTP Header:")
        if let headers = request.allHTTPHeaderFields {
            print("[")
            for (key, value) in headers {
                print("'\(key)': '\(value)'")
            }
            print("]")
        }
        
        // Set the HTTP method
        request.httpMethod = method.rawValue
        print("HTTP Method: \(request.httpMethod ?? "")")
        
        // If the body is not empty, serialize it to JSON and set it as the HTTP body
        if !body.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
                let tmpDict: NSDictionary = body as NSDictionary
                print("HTTP Request Body:" )
                printJson(tmpDict)
            } catch {
                print("Failed to serialize JSON body: \(error.localizedDescription)")
            }
        }
    }
    
    /// Prints the JSON representation of a given NSDictionary.
    /// - Parameters:
    ///   - dic: The dictionary to be converted to JSON and printed.
    ///   This parameter is expected to be a valid NSDictionary that can be serialized into JSON format.
    func printJson(_ dic: NSDictionary) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let jsonString: String = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            print(jsonString)
        }
    }
    
    /// Prints the JSON response data received from an API call.
    /// - Parameters:
    ///   - responseData: The data received from the API response.
    ///   This parameter is expected to be of type `Data`, representing the raw response data that should be in JSON format.
    func printResponseData(responseData: Data, apiName: String) {
        // Try to serialize the data into a JSON object
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                // Convert the JSON object into pretty-printed JSON string
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Response of '\(apiName)':")
                    print(jsonString)
                }
            } else {
                print("The data is not in a valid JSON format.")
            }
        } catch {
            print("Failed to parse JSON response: \(error.localizedDescription)")
        }
    }
    
    /// Handles the response for a payment request, decodes the JSON data, and presents the web view for payment processing if needed.
    /// - Parameters:
    ///   - data: The response data received from the network call, expected to be in JSON format.
    ///   - error: The error encountered during the network call, if any.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - isBackground: A flag indicating whether the web view should be loaded in the background or not.
    ///   - paymentRequestDetails: The payment request model containing details about the payment request.
    ///   - controller: The view controller responsible for presenting the web view if needed.
    ///   - completionHandler: A closure that returns the result of the operation, either success with a `PaymentResult` or failure with a `NetworkError`.
    func handlePaymentResponse(data: Data?, error: Error?, statusCode: Int, isBackground: Bool, paymentRequestDetails: PaymentRequestModel, from controller: UIViewController, strAPIName: String, completionHandler: @escaping (Result<PaymentResult, NetworkError>) -> Void) {
        
        // Handle network error
        if let networkError = error {
            completionHandler(.failure(NetworkError(reason: networkError.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure non-nil response data
        guard let responseData = data else {
            completionHandler(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strAPIName)
            
            // Parse JSON response
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: [.fragmentsAllowed]) as? [String: Any] else {
                completionHandler(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Check the 'status' field in the response
            let isSuccess = jsonResponse["status"] as? Bool ?? false
            if isSuccess {
                // Decode the response into the expected model
                let paymentResponse = try JSONDecoder().decode(PaymentResponseModel.self, from: responseData)
                
                if let data = jsonResponse["data"] as? [String: Any],
                   let transactionData = data["transactionData"] as? [String: Any],
                   let paymentType = transactionData["payment_type"] as? String,
                   paymentType == "card" {
                    presentWebViewController(paymentLink: transactionData["redirect_url"] as? String,
                                             isBackground: isBackground,
                                             paymentRequestDetails: paymentRequestDetails,
                                             from: controller,
                                             completion: completionHandler)
                } else {
                    
                    // Present web view controller if a payment link is provided
                    if let paymentLink = paymentResponse.paymentDetailsModel?.paymentLink {
                        presentWebViewController(paymentLink: paymentLink,
                                                 isBackground: isBackground,
                                                 paymentRequestDetails: paymentRequestDetails,
                                                 from: controller,
                                                 completion: completionHandler)
                    } else {
                        completionHandler(.failure(NetworkError(reason: "Missing payment link", httpStatusCode: statusCode)))
                    }
                }
                

            } else {
                let errorMessage = jsonResponse["message"] as? String ?? "Unknown error"
                completionHandler(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
            }
            
        } catch let err {
            // Handle decoding errors
            completionHandler(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }
    
    /// Handles the response for retrieving a customer unique token, decodes the JSON data, and returns the result through the completion handler.
    /// - Parameters:
    ///   - data: The response data received from the network call, which should be in JSON format.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - error: The error encountered during the network call, if any.
    ///   - completion: A closure that returns the result of the operation, either success with a decoded `CustomerTokenResponseModel` or failure with a `NetworkError`.
    func handleTokenResponse(data: Data?, statusCode: Int, error: Error?, strApiName: String, completion: @escaping (Result<CustomerTokenResponseModel, NetworkError>) -> Void) {
        
        // Handle network error
        if let networkError = error {
            completion(.failure(NetworkError(reason: networkError.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure non-nil response data
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strApiName)
            
            // Parse JSON response
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: [.fragmentsAllowed]) as? [String: Any] else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Check the status in the response
            let isSuccess = jsonResponse["status"] as? Bool ?? false
            if isSuccess {
                // Decode the response into the expected model
                let decodedResponse = try JSONDecoder().decode(CustomerTokenResponseModel.self, from: responseData)
                completion(.success(decodedResponse))
            } else {
                let errorMessage = jsonResponse["message"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
            }
            
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }

    /// Handles the response for retrieving card details, parses the JSON data, and returns the result through the completion handler.
    /// - Parameters:
    ///   - data: The response data received from the network call, which should be in JSON format.
    ///   - error: The error encountered during the network call, if any.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A closure that returns the result of the operation, either success with a parsed `[String: Any]` dictionary or failure with a `NetworkError`.
    func handleCardDetailsResponse(data: Data?, error: Error?, statusCode: Int, strApiName: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Check for any network error
        if let networkError = error {
            completion(.failure(NetworkError(reason: networkError.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that the response data is non-nil
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strApiName)
            
            // Attempt to parse the JSON response
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Check the 'status' field in the response
            let isSuccess = jsonResponse["status"] as? Bool ?? false
            if isSuccess {
                completion(.success(jsonResponse))
            } else {
                let errorMessage = jsonResponse["message"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
            }
            
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }
    
    /// Handles the response for adding card details, parses the data, checks the response status, and presents a web view for card linking if necessary.
    /// - Parameters:
    ///   - isBackground: A flag indicating whether the web view should be loaded in the background or not.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - presentingController: The view controller responsible for presenting the web view.
    ///   - data: The response data received from the network call.
    ///   - error: The error received from the network call, if any.
    ///   - completion: A closure that returns the result of the operation, either success with a JSON response or failure with a NetworkError.
    func handleAddCardResponse(isBackground: Bool, statusCode: Int, presentingController: UIViewController, data: Data?, error: Error?, strApiName: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Check if there is an error
        if let error = error {
            completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure response data exists
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strApiName)
            
            // Parse JSON data
            guard var jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Check the 'status' field in the response
            guard let isSuccess = jsonResponse["status"] as? Bool, isSuccess else {
                let errorMessage = jsonResponse["message"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
                return
            }
            
            // Handle add card link in the response data
            if let dataDictionary = jsonResponse["data"] as? [String: String],
               let addCardURLString = dataDictionary["link"],
               let addCardURL = URL(string: addCardURLString) {
                
                DispatchQueue.main.async {
                    let webViewController = AddCardWebViewController()
                    webViewController.cardAdditionURL = addCardURL
                    webViewController.isBackButtonPressed = isBackground
                    
                    // Completion handler for WebView response
                    webViewController.onCardAdditionCompletion = { paymentResponse in
                        jsonResponse["addCardStatusMessage"] = paymentResponse
                        completion(.success(jsonResponse))
                    }
                    
                    // Present the web view controller
                    presentingController.present(webViewController, animated: true, completion: nil)
                }
            }
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }

    /// Handles the response for fetching refund details.
    /// - Parameters:
    ///   - data: The raw `Data` object received from the server, if any.
    ///   - error: The `Error` object received during the request, if any.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A completion handler that returns a `Result` containing either a `[String: Any]` dictionary with the refund details on success, or a `NetworkError` on failure.
    func handleFetchRefundDetailsResponse(data: Data?, error: Error?, statusCode: Int, strAPIName: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Check for any network error
        if let networkError = error {
            completion(.failure(NetworkError(reason: networkError.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that the response data is non-nil
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strAPIName)
            
            // Attempt to parse the JSON response
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Check for the presence of a 'status' field in the response
            guard let isSuccess = jsonResponse["status"] as? Bool, isSuccess else {
                let errorMessage = jsonResponse["message"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
                return
            }
            
            // Return the parsed JSON response through the completion handler
            completion(.success(jsonResponse))
            
            if isSuccess {
                // Return the parsed JSON response through the completion handler
                completion(.success(jsonResponse))
            }
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }

    /// Handles the response for checking the payment button status, decodes the JSON data, and returns the result through the completion handler.
    /// - Parameters:
    ///   - data: The response data received from the network call.
    ///   - error: The error encountered during the network call, if any.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A closure that returns the result of the operation, either success with a decoded `PaymentButtonStatusModel` or failure with a `NetworkError`.
    func handleCheckPaymentButtonStatusResponse(data: Data?, error: Error?, statusCode: Int, strApiName: String, completion: @escaping (Result<PaymentButtonStatusModel, NetworkError>) -> Void) {
        
        // Check for any network error
        if let networkError = error {
            completion(.failure(NetworkError(reason: networkError.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that the response data is non-nil
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        // Attempt to decode the response data into the PaymentButtonStatusModel
        do {
            self.printResponseData(responseData: responseData, apiName: strApiName)
            
            let decodedResponse = try JSONDecoder().decode(PaymentButtonStatusModel.self, from: responseData)
            completion(.success(decodedResponse))
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }
    
    /// Handles the response from fetching the payment status and returns a result via the completion handler.
    /// - Parameters:
    ///   - data: The raw data returned from the network request.
    ///   - error: An optional error that occurred during the network request.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A closure that takes a `Result` containing either a `PaymentStatusResponseModel` on success or a `NetworkError` on failure.
    func handleFetchPaymentStatusResponse(data: Data?, error: Error?, statusCode: Int, strAPIName: String, completion: @escaping (Result<PaymentStatusResponseModel, NetworkError>) -> Void) {
        
        // Check if an error occurred during the network request
        if let error = error {
            completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that response data exists
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strAPIName)
            
            // Attempt to parse the response data into a JSON object
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                  let isSuccess = jsonResponse["status"] as? Bool else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            if isSuccess {
                // Decode the response data into the PaymentStatusResponseModel if status is true
                let decodedResponse = try JSONDecoder().decode(PaymentStatusResponseModel.self, from: responseData)
                completion(.success(decodedResponse))
            } else {
                // Handle failure scenario when status is false
                let message = jsonResponse["message"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: message, httpStatusCode: statusCode)))
            }
            
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }

    /// Handles the response from fetching multiple refund details and returns a result via the completion handler.
    /// - Parameters:
    ///   - data: The raw data returned from the network request.
    ///   - error: An optional error that occurred during the network request.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A closure that takes a `Result` containing either a `[String: Any]` dictionary on success or a `NetworkError` on failure.
    func handleFetchMultipleRefundDetailsResponse(data: Data?, error: Error?, statusCode: Int, strAPIName: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        // Check if an error occurred during the network request
        if let error = error {
            completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that response data exists
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strAPIName)
            
            // Attempt to parse the response data into a JSON object
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            // Return the JSON response
            completion(.success(jsonResponse))
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }
    
    /// Handles the response for creating an invoice.
    /// - Parameters:
    ///   - data: The raw `Data` object received from the server, if any.
    ///   - error: The `Error` object received during the request, if any.
    ///   - statusCode: An integer representing the HTTP status code returned by the API. This is used to determine the success or failure of the request.
    ///   - completion: A completion handler that returns a `Result` containing either the `InvoiceCreationModel` on success or a `NetworkError` on failure.
    func handleCreateInvoiceResponse(data: Data?, error: Error?, statusCode: Int, strAPIName: String, completion: @escaping (Result<InvoiceCreationModel, NetworkError>) -> Void) {
        
        // Check if an error occurred during the network request
        if let error = error {
            completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: statusCode)))
            return
        }
        
        // Ensure that response data exists
        guard let responseData = data else {
            completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: statusCode)))
            return
        }
        
        do {
            self.printResponseData(responseData: responseData, apiName: strAPIName)
            
            // Attempt to parse the response data into a JSON object
            guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                  let isSuccess = jsonResponse["status"] as? Bool else {
                completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: statusCode)))
                return
            }
            
            if isSuccess {
                // Decode the response into the expected model
                let decodedResponse = try JSONDecoder().decode(InvoiceCreationModel.self, from: responseData)
                completion(.success(decodedResponse))
            } else {
                // Handle failure scenario when status is false
                let errorMessage = jsonResponse["error_msg"] as? String ?? "Unknown error"
                completion(.failure(NetworkError(reason: errorMessage, httpStatusCode: statusCode)))
            }
            
        } catch let err {
            // Handle decoding errors
            completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: statusCode)))
        }
    }

    /// Sends a delete refund request and handles the response, returning a result via the completion handler.
    /// - Parameters:
    ///   - request: The `URLRequest` to be sent.
    ///   - completion: A closure that takes a `Result` containing either a `[String: Any]` dictionary on success or a `NetworkError` on failure.
    func handleDeleteRefundResponse(with request: URLRequest, strAPIName: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                // Print the response status code
                print("API Status Code: \(httpResponse.statusCode)")
                
                // Check if an error occurred during the network request
                if let error = error {
                    completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: httpResponse.statusCode)))
                    return
                }
                
                // Ensure that response data exists
                guard let responseData = data else {
                    completion(.failure(NetworkError(reason: "No response data received", httpStatusCode: httpResponse.statusCode)))
                    return
                }
                
                do {
                    self.printResponseData(responseData: responseData, apiName: strAPIName)
                    
                    // Attempt to parse the response data into a JSON object
                    guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        completion(.failure(NetworkError(reason: "Invalid JSON format", httpStatusCode: httpResponse.statusCode)))
                        return
                    }
                    
                    // Return the JSON response regardless of the status value
                    completion(.success(jsonResponse))
                } catch let err {
                    // Handle decoding errors
                    completion(.failure(NetworkError(reason: err.localizedDescription, httpStatusCode: httpResponse.statusCode)))
                }
            } else {
                // Handle cases where the response is not an HTTPURLResponse
                completion(.failure(NetworkError(reason: "Invalid response received", httpStatusCode: 500)))
            }
        }
        task.resume()
    }

    /// Presents a `PaymentWebViewController` to handle payment interactions through a web view.
    ///
    /// - Parameters:
    ///   - paymentLink: An optional `String` representing the URL of the payment page. This link should be valid and can be converted to a URL. If `nil`, the function will fail with an error.
    ///   - isBackground: A `Bool` flag indicating whether the payment process is running in the background. This can affect how the web view controller is presented.
    ///   - paymentRequestDetails: An optional `PaymentRequestModel` containing detailed information about the payment request. This will be used if available. If `nil`, the function will use `paymentDetails` instead.
    ///   - paymentDetails: An optional `PaymentDetail` containing the details of the payment transaction. This will be used if `paymentRequestDetails` is `nil`.
    ///   - from: The `UIViewController` instance from which the `PaymentWebViewController` should be presented. This controller is used to present the web view controller modally.
    ///   - completion: A closure to be called upon the completion of the payment process. It returns a `Result` type:
    ///     - `.success(PaymentResult)`: Indicates that the payment was completed successfully and contains the result of the payment.
    ///     - `.failure(NetworkError)`: Indicates that there was an error during the payment process and contains details about the error.
    func presentWebViewController(paymentLink: String?, isBackground: Bool, paymentRequestDetails: PaymentRequestModel, from controller: UIViewController, completion: @escaping (Result<PaymentResult, NetworkError>) -> Void) {
        
        // Ensure the payment link is valid and can be converted to a URL
        guard let paymentLink = paymentLink, let url = URL(string: paymentLink) else {
            // If the payment link is invalid, return an error with a message and status code 400
            completion(.failure(NetworkError(reason: "Invalid payment link", httpStatusCode: 400)))
            return
        }
        
        // Present the web view controller on the main thread
        DispatchQueue.main.async {
            // Create an instance of PaymentWebViewController
            let webViewController = PaymentWebViewController()
            
            // Set the payment URL for the web view controller
            webViewController.paymentURL = url
            
            // Set whether the web view controller is presented in the background
            webViewController.didEnterBackground = isBackground
            
            // Assign payment details or request details based on availability
            webViewController.paymentRequestDetails = paymentRequestDetails

            // Assign the completion handler to handle the result of the payment process
            webViewController.onPaymentCompletion = completion
            
            // Hide the navigation bar for the web view controller
            webViewController.navigationController?.isNavigationBarHidden = true
            
            // Present the web view controller modally from the provided controller
            controller.present(webViewController, animated: true)
        }
    }
}
