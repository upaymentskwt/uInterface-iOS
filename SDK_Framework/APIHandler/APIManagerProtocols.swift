//
//  APIManagerProtocols.swift
//  uInterfaceSDK
//
//  Created by user on 29/08/24.
//

import Foundation
import UIKit

// MARK: - Protocol: PaymentStoreUseCase
/// Defines the contract for all payment-related API calls
public protocol PaymentStoreUseCase: UseCase {
    
    /// Makes a POST call for create payment
    func createPayment(isBackground: Bool, token: String, paymentRequestDetails: PaymentRequestModel, controller: UIViewController, completionHandler: @escaping (Result<PaymentResult, NetworkError>) -> Void)
    
    /// Creates a customer unique token with a POST call
    func createCustomerToken(token: String, customerTokenRequestDetail: CustomerTokenRequestModel, controller: UIViewController, completionHandler: @escaping (Result<CustomerTokenResponseModel, NetworkError>) -> Void)
    
    /// Retrieves customer card details
    func fetchCardDetails(token: String, cardRequestDetails: TokenDataModel, controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Adds a new card to the customer's account
    func addCardDetails(isBackground: Bool, token: String, cardRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Retrieves refund details
    func fetchRefundDetails(token: String, refundRequest: RefundRequestModel, controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Checks payment button status
    func checkPaymentButtonStatus(token: String, controller: UIViewController, completionHandler: @escaping (Result<PaymentButtonStatusModel, NetworkError>) -> Void)
    
    /// Retrieves payment status
    func fetchPaymentStatus(headerToken: String, trackingID: String, controller: UIViewController, completionHandler: @escaping (Result<PaymentStatusResponseModel, NetworkError>) -> Void)
    
    /// Retrieves multiple refund details
    func fetchMultipleRefundDetails(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Creates an invoice
    func createInvoice(headerToken: String, invoiceRequest: [String: Any], controller: UIViewController, completion: @escaping (Result<InvoiceCreationModel, NetworkError>) -> Void)
    
    /// Deletes a refund request
    func deleteRefund(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Deletes a multi-vendor refund request
    func deleteMultiVendorRefund(headerToken: String, refundRequest: [String: Any], controller: UIViewController, completionHandler: @escaping (Result<[String: Any], NetworkError>) -> Void)
    
    /// Changes the base URL between production and sandbox
    func setBaseURL(environment: Environment)
}
