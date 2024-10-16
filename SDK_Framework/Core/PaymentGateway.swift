//
//  PaymentGateway.swift
//  uInterfaceSDK
//
//  Created by user on 22/08/24.
//

import Foundation

/// A protocol that defines the payment store use case.
public protocol PaymentGateway {
    var paymentStoreUseCase: PaymentStoreUseCase { get }
}

/// Implementation of the PaymentGateway protocol.
public class PaymentGatewayImplementation: PaymentGateway {
    
    // Singleton instance of the PaymentGateway
    private static var sharedGateway = PaymentGatewayImplementation()
    
    /// Shared instance of the PaymentGateway protocol
    public static var shared: PaymentGateway {
        sharedGateway
    }
    
    /// Provides the payment store use case.
    public var paymentStoreUseCase: PaymentStoreUseCase {
        return PaymentAPIManager()
    }
}
