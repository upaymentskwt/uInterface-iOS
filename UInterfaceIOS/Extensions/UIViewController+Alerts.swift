//
//  UIViewController+Alerts.swift
//  UInterfaceIOS
//
//  Created by user on 11/09/24.
//

// UIViewController+Alerts.swift
import UIKit

extension UIViewController {
    
    /// Displays an alert with a specified status and response message.
    /// - Parameters:
    ///   - status: The title of the alert.
    ///   - responseMessage: The message to be displayed in the alert. It can be any type that can be converted to a string.
    func displayAlert(status: String, responseMessage: Any) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: status, message: "\(responseMessage)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


