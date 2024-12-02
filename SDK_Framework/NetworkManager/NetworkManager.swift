//
//  NetworkManager.swift
//  uInterfaceSDK
//
//  Created by user on 21/08/24.
//

import Foundation

/// A utility class responsible for handling network operations.
public class NetworkManager {
    
    /// The authentication token used for making HTTP requests.
    private var token: String?
    
    /// A JSON decoder used to decode JSON responses from HTTP requests.
    private var jsonDecoder: JSONDecoder?
    
    /// Initializes `HTTPUtility` with a token.
    ///
    /// - Parameters:
    ///   - token: Optional token for authorization.
    public init(token: String?) {
        self.token = token
    }
    
    /// Initializes `HTTPUtility` with a token and a custom JSON decoder.
    ///
    /// - Parameters:
    ///   - token: Optional token for authorization.
    ///   - decoder: Optional custom JSON decoder for decoding the response.
    public init(token: String?, decoder: JSONDecoder?) {
        self.token = token
        self.jsonDecoder = decoder
    }
    
    /// Initializes `HTTPUtility` with a custom JSON decoder.
    ///
    /// - Parameters:
    ///   - decoder:   A custom JSON decoder for decoding the response.
    public init(withJsonDecoder decoder: JSONDecoder) {
        self.jsonDecoder = decoder
    }
    
    /// Initializes `HTTPUtility` with no arguments.
    public init() {}
    
    /// Sends an HTTP request and decodes the response.
    ///
    /// - Parameters:
    ///   - url: The URL string for the request.
    ///   - method: The HTTP method to use.
    ///   - requestBody: Optional data to send with the request.
    ///   - responseType: The expected type of the response.
    ///   - completion: Completion handler returning either a success with the decoded response or a failure with a `NetworkError`.
    public func sendRequest<T: Decodable>(to url: String, using method: HTTPMethod, withBody requestBody: Data? = nil, expecting responseType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        // Ensure the base URL is valid
        guard URL(string: url) != nil else {
            return
        }
        
        var finalURL = url
        
        // Handle .get method with potential query parameters
        if method == .get {
            if let body = requestBody,
               let encodedString = String(data: body, encoding: .utf8),
               let percentEncodedString = encodedString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                finalURL += percentEncodedString
            } else if requestBody != nil {
                debugPrint("Failed to decode the body data using UTF-8 encoding.")
                return
            }
        }
        
        // Ensure the final URL is valid
        guard let finalURLObject = URL(string: finalURL) else {
            return
        }
        
        // Choose the appropriate request method
        switch method {
        case .get:
            self.fetchData(from: finalURLObject, responseType: responseType, completion: completion)
        case .post, .put, .delete:
            guard let requestBody = requestBody else {
                return
            }
            self.sendData(to: finalURLObject, withBody: requestBody, method: method, responseType: responseType, completion: completion)
        }
    }

    // MARK: - Private Helper Functions
    
    /// A method that creates a `JSONDecoder` instance with a default ISO8601 date decoding strategy if no decoder has been provided.
    ///
    /// - Returns: A configured `JSONDecoder` instance.
    private func createJSONDecoder() -> JSONDecoder {
        let decoder = self.jsonDecoder ?? JSONDecoder()
        if self.jsonDecoder == nil {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }

    /// A method that creates a `URLRequest` object with the specified HTTP method and body,
    /// and adds an authorization token to the request headers if available.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method to be used (e.g., GET, POST).
    ///   - body: The body of the request as `Data`, typically used for non-GET methods.
    ///
    /// - Returns: A configured `URLRequest` object.
    private func createURLRequest(for url: URL, withMethod method: HTTPMethod, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let token = token {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        if method != .get {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        return request
    }

    /// Decodes a given `Data` object into a specified type conforming to `Decodable`.
    ///
    /// - Parameters:
    ///   - data: The raw `Data` object to decode.
    ///   - responseType: The expected type to decode the data into, conforming to `Decodable`.
    ///
    /// - Returns: An optional decoded object of the specified type. If decoding fails, returns `nil`.
    private func decodeResponse<T: Decodable>(from data: Data, as responseType: T.Type) -> T? {
        do {
            return try self.createJSONDecoder().decode(responseType, from: data)
        } catch {
            debugPrint("Decoding error: \(error)")
            return nil
        }
    }

    /// Executes the provided network request and decodes the response into the specified type.
    /// Handles errors related to network communication and decoding failures.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` object to be executed.
    ///   - responseType: The expected type to decode the response into, conforming to `Decodable`.
    ///   - completion: A completion handler that returns a `Result` containing either the decoded object or a `NetworkError`.
    private func performRequest<T: Decodable>(with request: URLRequest, decoding responseType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let error = error {
                completion(.failure(NetworkError(reason: error.localizedDescription, httpStatusCode: statusCode)))
                return
            }
            
            if let data = data, !data.isEmpty {
                self.printJSONData(data)
                
                if let decodedResponse = self.decodeResponse(from: data, as: responseType) {
                    completion(.success(decodedResponse))
                } else {
                    completion(.failure(NetworkError(reason: "Decoding error", httpStatusCode: statusCode)))
                }
            } else {
                completion(.failure(NetworkError(reason: "No data", httpStatusCode: statusCode)))
            }
        }.resume()
    }

    // MARK: - HTTP Request Methods

    /// Fetches data from the specified URL and decodes the response into the specified type.
    /// Executes a GET request.
    ///
    /// - Parameters:
    ///   - url: The URL from which data is fetched.
    ///   - responseType: The type to decode the response into, conforming to `Decodable`.
    ///   - completion: A completion handler that returns a `Result` containing either the decoded object or a `NetworkError`.
    private func fetchData<T: Decodable>(from url: URL, responseType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        let request = self.createURLRequest(for: url, withMethod: .get, body: nil)
        self.performRequest(with: request, decoding: responseType, completion: completion)
    }

    /// Sends data to the specified URL using the given HTTP method, and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - url: The URL to which data is sent.
    ///   - body: The body of the request, typically encoded as JSON.
    ///   - method: The HTTP method to be used (e.g., POST, PUT).
    ///   - responseType: The type to decode the response into, conforming to `Decodable`.
    ///   - completion: A completion handler that returns a `Result` containing either the decoded object or a `NetworkError`.
    private func sendData<T: Decodable>(to url: URL, withBody body: Data?, method: HTTPMethod, responseType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        let request = self.createURLRequest(for: url, withMethod: method, body: body)
        self.performRequest(with: request, decoding: responseType, completion: completion)
    }
    
    // MARK: - Debugging Helpers
    
    /// Prints data in JSON format for debugging purposes.
    private func printJSONData(_ data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            debugPrint("Response Data: \(jsonObject)")
        } catch {
            debugPrint("Error serializing JSON: \(error)")
        }
    }
}
