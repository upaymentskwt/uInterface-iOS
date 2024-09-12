//
//  ViewController.swift
//  UInterfaceIOS
//
//  Created by user on 11/09/24.
//

import UIKit
import DropDown
import uInterfaceSDK

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var dropDownContainerView: UIView!
    @IBOutlet weak var btnWhiteListIP: UIButton!
    @IBOutlet weak var btnNonWhiteListIP: UIButton!
    
    // MARK: - Properties
    let objPaymentAPIManager = PaymentAPIManager()
    
    var customerUniqueID = ""
    var sourceValue = ""
    var arrPaymentOptions = [String]()
    var arrUserEnteredRefundData = [[String:String]]()
    var orderID = ""
    var apiToken = ""
    var singleDeleteOrderID = ""
    var singleRefundOrderID = ""
    
    var multiDeleteRefundInvoiceID = ""
    var multiDeleteOrderID = ""
    var multiDeleteRefundARN = ""
    var multiDeleteRefundOrderID = ""
    
    var whiteListStatus = ""
    var apiType = ""
    var customerUniqueNumber = ""
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set customer unique identifier
        self.customerUniqueNumber = "1234567890844"
        
        // Hide dropdown container view by default
        dropDownContainerView.isHidden = true
        
        // Configure navigation bar appearance
        self.setupNavigationBarAppearance()
        
        // Configure button appearance
        self.setupButtonAppearance()
        
        // Assign API token for Sandbox environment
        apiToken = "jtest123" // For Sandbox
        // apiToken = "e66a94d579cf75fba327ff716ad68c53aae11528" // For Production (uncomment for production use)
        
        // Set the payment source value to KNET
        self.sourceValue = "knet"
        
        // Populate refund data with user-entered values (amount to refund and IBAN number)
        self.arrUserEnteredRefundData = [
            ["amountToRefund": "1", "ibanNumber": "KW91KFHO0000000000051010173254"],
            ["amountToRefund": "1", "ibanNumber": "KW91KFHO0000000000051010173254"]
        ]
        
        // Fetch customer unique number from the server or database
        self.createNewCustomerToken()
        
        // Check and update the status of buttons based on conditions
        self.checkPaymentButtonStatus()
    }
    
    // MARK: - Private Methods
    /// Sets up the appearance of the navigation bar.
    private func setupNavigationBarAppearance() {
        self.navigationController?.setStatusBar(backgroundColor: UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0))
        navigationController?.navigationBar.isHidden = true
    }
    
    /// Sets up the appearance of the whitelist and non-whitelist buttons.
    private func setupButtonAppearance() {
        self.btnNonWhiteListIP.backgroundColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.btnNonWhiteListIP.setTitleColor(.white, for: .normal)
        
        self.btnWhiteListIP.backgroundColor = .white
        self.btnWhiteListIP.setTitleColor(UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0), for: .normal)
        self.btnWhiteListIP.layer.borderColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0).cgColor
        self.btnWhiteListIP.layer.borderWidth = 1
    }
    
    //MARK: - IBAction Methods
    // Action for selecting Non-White Label API (e.g., Sandbox Environment)
    @IBAction func didTapSelectNonWhiteLabelAPI(_ sender: Any) {
        // Set background color and text color for Non-White Label button
        self.btnNonWhiteListIP.backgroundColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.btnNonWhiteListIP.setTitleColor(UIColor.white, for: .normal)
        
        // Reset background and text color for White Label button
        self.btnWhiteListIP.backgroundColor = UIColor.white
        self.btnWhiteListIP.setTitleColor(UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0), for: .normal)
        
        // Set border color and width for White Label button
        self.btnWhiteListIP.layer.borderColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0).cgColor
        self.btnWhiteListIP.layer.borderWidth = 1
        
        // Assign API token for Non-White Label environment (e.g., Sandbox)
        self.apiToken = "jtest123"
        
        // Set whiteListStatus to Non-White Label selected
        self.whiteListStatus = "1"
    }

    // Action for selecting White Label API (e.g., Production Environment)
    @IBAction func didTapSelectWhiteLabelAPI(_ sender: Any) {
        // Set background color and text color for White Label button
        self.btnWhiteListIP.backgroundColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.btnWhiteListIP.setTitleColor(UIColor.white, for: .normal)
        
        // Reset background and text color for Non-White Label button
        self.btnNonWhiteListIP.backgroundColor = UIColor.white
        self.btnNonWhiteListIP.setTitleColor(UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0), for: .normal)
        
        // Set border color and width for Non-White Label button
        self.btnNonWhiteListIP.layer.borderColor = UIColor(red: 56.0/255.0, green: 22.0/255.0, blue: 176.0/255.0, alpha: 1.0).cgColor
        self.btnNonWhiteListIP.layer.borderWidth = 1
        
        // Assign API token for White Label environment (e.g., Production)
        self.apiToken = "e66a94d579cf75fba327ff716ad68c53aae11528"
        
        // Set whiteListStatus to White Label selected
        self.whiteListStatus = "2"
    }

    // Action for purchasing a single product using Charge API
    @IBAction func didTapChargeAPIBuySingleProduct(_ sender: Any) {
        if self.whiteListStatus == "2" {
            // If White Label API is selected, set API type and show payment options
            self.apiType = "1"
            self.showPaymentTypeDropdown()
        } else {
            // Otherwise, proceed to charge for a single product
            self.initiateSingleProductPayment()
        }
    }

    // Action for purchasing multiple products using Charge API
    @IBAction func didTapChargeAPIBuyMultipleProducts(_ sender: Any) {
        if self.whiteListStatus == "2" {
            // If White Label API is selected, set API type and show payment options
            self.apiType = "2"
            self.showPaymentTypeDropdown()
        } else {
            // Otherwise, proceed to charge for multiple products
            self.processPaymentForMultipleProducts()
        }
    }

    // Action for creating an invoice
    @IBAction func didTapCreateInvoice(_ sender: Any) {
        // Trigger the invoice generation process
        self.generateInvoice()
    }

    // Action for initiating a single product refund
    @IBAction func didTapSingleRefund(_ sender: Any) {
        // Handle refund request for a single product
        self.handleRefund()
    }

    // Action for initiating multiple products refund
    @IBAction func didTapMultiRefund(_ sender: Any) {
        // Handle refund request for multiple products
        self.handleRefund()
    }

    // Action for deleting a single product refund request
    @IBAction func didTapSingleDeleteRefund(_ sender: Any) {
        // Handle deletion of a single product refund
        self.deleteSingleRefund()
    }

    // Action for deleting multiple product refund requests
    @IBAction func didTapMultiDeleteRefund(_ sender: Any) {
        // Handle deletion of multiple product refunds
        self.deleteMultiRefunds()
    }

    // Action for adding a new card to the user account
    @IBAction func didTapAddCard(_ sender: Any) {
        // Handle the process for adding a new card
        self.addCard()
    }

    // Action for retrieving saved cards from the user account
    @IBAction func didTapRetrieveCard(_ sender: Any) {
        // Handle the process for fetching saved cards
        self.fetchCardDetails()
    }

    //MARK: - API Calls Method
    // Function to check the status of payment buttons based on the provided API token
    func checkPaymentButtonStatus() {
        self.objPaymentAPIManager.checkPaymentButtonStatus(token: self.apiToken, controller: self, completionHandler: { (result) in
            switch result {
            case .success(let response):
                // Safely unwrap and retrieve payment button data
                guard let payButtonData = response.paymentButtonData?.payButtons else {
                    return
                }
                // Clear previous payment options
                self.arrPaymentOptions.removeAll()
                // Loop through payment button data and add valid options to array
                for (key, value) in payButtonData {
                    if value == true {
                        self.arrPaymentOptions.append(key)
                    }
                }
                // Log the available payment options
                debugPrint(self.arrPaymentOptions)
            
            case .failure(let error):
                // Show alert with error status and message
                self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
            }
        })
    }

    // Function to check the payment status for a specific tracking ID
    func checkPaymentStatus() {
        self.objPaymentAPIManager.fetchPaymentStatus(headerToken: self.apiToken, trackingID: "202305505718076761984557261163", controller: self, completionHandler: { (result) in
            switch result {
            case .success(let response):
                // Log the payment status response
                debugPrint("Response: ")
                JSONUtilities.printModelAsJSON(response)
                // Show an alert with the status and message from the response
                self.displayAlert(status: response.message ?? "", responseMessage: response)
            
            case .failure(let error):
                // Log the error and show an alert with error status and message
                debugPrint(error.localizedDescription)
                self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
            }
        })
    }
    
    // Initiates a payment process for a single product purchase.
    func initiateSingleProductPayment() {
        
        // Create product details for the payment
        let productDetail = ProductModel(
            name: "Logitech K380",
            description: "Logitech K380 / Easy-Switch for Upto 3 Devices, Slim Bluetooth Tablet Keyboard",
            price: 1,
            quantity: 1
        )
        
        // Add product details to the products array
        var products = [ProductModel]()
        products.append(productDetail)
        
        // Create order details for the payment
        let orderDetail = OrderModel(
            orderId: "202210101255255144669",
            reference: "11111991",
            description: "Purchase order received for Logitech K380 Keyboard",
            currency: "KWD",
            amount: 0.100
        )
        
        // Create payment gateway details
        let paymentGatewayDetail = PaymentGatewayModel(src: "knet")
        
        // Create token details for the payment
        let tokenDetail = TokenModel(
            fastToken: "",
            creditCardToken: "",
            customerUniqueToken: self.customerUniqueID
        )
        
        // Create reference details
        let referenceDetail = ReferenceModel(referenceId: "202210101202210101")
        
        // Create customer details
        let customerDetail = CustomerModel(
            uniqueID: "2129879kjbljg767881",
            name: "Jhon Smithe",
            email: "jhon.smith@upayments.com",
            mobile: "+96512345678"
        )
        
        // Create plugin details
        let pluginDetail = PluginModel(sourceURL: "magento")
        
        // Create browser details
        let browserDetails = BrowserDetailsModel(
            screenWidth: "1920",
            screenHeight: "1080",
            colorDepth: "24",
            javaEnabled: "true",
            language: "en"
        )
        
        // Create device details
        let deviceDetail = DeviceModel(
            browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0",
            browserDetails: browserDetails
        )
        
        // Create payment request details model
        let paymentRequestDetails = PaymentRequestModel(
            products: products,
            isTest: true,
            order: orderDetail,
            paymentGateway: paymentGatewayDetail,
            notificationType: "all",
            language: "en",
            isSaveCard: false,
            isWhitelabeled: true,
            tokens: tokenDetail,
            reference: referenceDetail,
            customer: customerDetail,
            plugin: pluginDetail,
            customerExtraData: "test data",
            returnURL: "https://upayments.com/en/",
            cancelURL: "https://www.error.com",
            notificationURL: "https://webhook.site/ce503866-6bb3-4c58-a2f2-a0fa028f10ea",
            device: deviceDetail
        )
        
        // Log the payment request details for debugging
        JSONUtilities.printModelAsJSON(paymentRequestDetails)
        
        // Process the payment request
        self.objPaymentAPIManager.processPayment(isBackground: true, token: self.apiToken, paymentRequestDetails: paymentRequestDetails, controller: self, completionHandler: { result in
                switch result {
                case .success(let response):
                    // Log the payment response for debugging
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(response)
                    
                    // Extract and log the refund order ID from the response
                    let responseDict = response.transactionDetails.toDictionary()
                    self.orderID = responseDict["refund_order_id"] as? String ?? ""
                    debugPrint("Refund Order ID: \(self.orderID)")
                    
                    // Show an alert with the payment response message
                    self.displayAlert(status: response.message, responseMessage: response)
                
                case .failure(let error):
                    // Show an alert with error status and message
                    self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
                }
            }
        )
    }

    // Function to prepare invoice data for creating an invoice
    func createInvoiceData() -> [String: Any] {
        
        // Create customer details
        let customerDetail = CustomerModel(
            uniqueID: "ABCDer22126433",
            name: "Aqeel2",
            email: "Aqeel2@gmail.com",
            mobile: "69923183"
        )
        
        // Create order details
        let orderDetail = OrderModel(
            orderId: "123",
            reference: "REF-456",
            description: "Order Description",
            currency: "USD",
            amount: 19.98
        )
        
        // Create payment gateway details
        let paymentGatewayDetail = PaymentGatewayModel(src: "create-invoice")
        
        // Create plugin details
        let pluginDetail = PluginModel(sourceURL: "magento")
        
        // Create reference details
        let referenceDetail = ReferenceModel(referenceId: "123459865234889")
        
        // Create token details
        let tokenDetail = TokenModel(fastToken: "", creditCardToken: "", customerUniqueToken: "69923183")
        
        // Define the invoice data dictionary
        let invoiceData: [String: Any] = [
            "cancelUrl": "https://developers.upayments.com/",
            "customer": customerDetail.toDictionary(),
            "customerExtraData": "",
            "extraMerchantData": [],
            "isSaveCard": false,
            "isTest": false,
            "is_whitelabled": false,
            "language": "en",
            "notificationType": "email",
            "notificationUrl": "https://webhook.site/92eb6888-362b-4874-840f-3fff620f7cf4",
            "order": orderDetail.toDictionary(),
            "paymentGateway": paymentGatewayDetail.toDictionary(),
            "plugin": pluginDetail.toDictionary(),
            "product": [
                [
                    "description": "Product 1",
                    "name": "KFS",
                    "price": 10.0,
                    "qty": 1
                ],
                [
                    "description": "",
                    "name": "KFS2",
                    "price": 20.0,
                    "qty": 1
                ]
            ],
            "reference": referenceDetail.toDictionary(),
            "returnUrl": "https://upayments.com/en/",
            "sessionId": "",
            "tokens": tokenDetail.toDictionary()
        ]
        
        return invoiceData
    }

    // Function to process payment for multiple products
    func processPaymentForMultipleProducts() {
        
        // Create product details for the payment
        let mouseProductDetail = ProductModel(
            name: "Logitech K380",
            description: "Logitech K380 / Easy-Switch for Upto 3 Devices, Slim Bluetooth Tablet Keyboar ",
            price: 10,
            quantity: 1
        )
        
        let laptopProductDetail = ProductModel(
            name: "Logitech M171 Wireless Optical Mouse",
            description: "Logitech M171 Wireless Optical Mouse  (2.4GHz Wireless, Blue Grey)",
            price: 10,
            quantity: 1
        )
        
        var products = [ProductModel]()
        products.append(mouseProductDetail)
        products.append(laptopProductDetail)
        
        // Create merchant information details
        let merchantDataKW91 = MerchantMoreInfoModel(amount: 10, knetCharge: 5, knetChargeType: "fixed", ccCharge: 10, ccChargeType: "percentage", ibanNumber: "KW91KFHO0000000000051010173254")
        let merchantDataKW31 = MerchantMoreInfoModel(amount: 10, knetCharge: 5, knetChargeType: "fixed", ccCharge: 7, ccChargeType: "percentage", ibanNumber: "KW31NBOK0000000000002010177457")
        
        var merchantInfoDetails = [MerchantMoreInfoModel]()
        merchantInfoDetails.append(merchantDataKW91)
        merchantInfoDetails.append(merchantDataKW31)
        
        // Create order details for the payment
        let orderDetail = OrderModel(
            orderId: "202210101255255144669",
            reference: "11111991",
            description: "Purchase order received for Logitech K380 Keyboard",
            currency: "KWD",
            amount: 20
        )
        
        // Create payment gateway details
        let paymentGatewayDetail = PaymentGatewayModel(src: "knet")
        
        // Retrieve customer unique token from UserDefaults
        let customerUniqueToken = UserDefaults.standard.string(forKey: "customerUnique")
        
        // Create token details
        let tokenDetail = TokenModel(fastToken: "", creditCardToken: "", customerUniqueToken: customerUniqueToken)
        
        // Create reference details
        let referenceDetail = ReferenceModel(referenceId: "202210101202210101")
        
        // Create customer details
        let customerDetail = CustomerModel(
            uniqueID: "2129879kjbljg767881",
            name: "Dharmendra Kakde",
            email: "kakde.dharmendra@upayments.com",
            mobile: "+96566336537"
        )
        
        // Create plugin details
        let pluginDetail = PluginModel(sourceURL: "magento")
        
        // Create browser details
        let browserDetails = BrowserDetailsModel(
            screenWidth: "1920",
            screenHeight: "1080",
            colorDepth: "24",
            javaEnabled: "true",
            language: "en",
            timeZone: "-180"
        )
        
        // Create device details
        let deviceDetail = DeviceModel(
            browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0",
            browserDetails: browserDetails
        )
        
        // Create payment request details
        let paymentRequestDetails = PaymentRequestModel(
            products: products,
            merchantsMoreInfo: merchantInfoDetails,
            sessionID: "",
            isTest: true,
            order: orderDetail,
            paymentGateway: paymentGatewayDetail,
            notificationType: "all",
            language: "en",
            isSaveCard: false,
            isWhitelabeled: true,
            tokens: tokenDetail,
            reference: referenceDetail,
            customer: customerDetail,
            plugin: pluginDetail,
            customerExtraData: "User define data",
            returnURL: "https://upayments.com/en/",
            cancelURL: "https://error.com",
            notificationURL: "https://webhook.site/d7c6e1c8-b98b-4f77-8b51-b487540df336",
            device: deviceDetail
        )

        // Print payment request details for debugging
        JSONUtilities.printModelAsJSON(paymentRequestDetails)
        
        // Process the payment request
        self.objPaymentAPIManager.processPayment(isBackground: true, token: self.apiToken, paymentRequestDetails: paymentRequestDetails, controller: self, completionHandler: { result in
            switch result {
            case .success(let response):
                debugPrint("Response:")
                JSONUtilities.printModelAsJSON(response)
                
                // Extract and print the refund order ID from the response
                let responseDict = response.transactionDetails.toDictionary()
                self.orderID = responseDict["refund_order_id"] as? String ?? ""
                debugPrint("Refund Order ID: \(self.orderID)")
                
                // Show success alert
                self.displayAlert(status: response.message, responseMessage: response)
            case .failure(let error):
                // Show error alert
                self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
            }
        })
    }

    // Function to generate an invoice
    func generateInvoice() {
        // Create invoice data
        let invoiceData = self.createInvoiceData()
        
        // Convert invoice data to JSON string for debugging
        if let jsonString = JSONUtilities.convertDictionaryToJSONString(dictionary: invoiceData) {
            debugPrint(jsonString)
        }
        
        // Send invoice data to the API
        self.objPaymentAPIManager.createInvoice(headerToken: self.apiToken, invoiceRequest: invoiceData, controller: self) { result in
            switch result {
            case .success(let response):
                // Print and handle successful response
                debugPrint("Response:")
                JSONUtilities.printModelAsJSON(response)
                self.displayAlert(status: "", responseMessage: response)
            case .failure(let error):
                // Print and handle error response
                debugPrint(error.localizedDescription)
            }
        }
    }

    /// Handles a refund request by sending the refund data to the API and processing the response.
    /// If the refund is for multiple vendors, it handles each vendor's refund separately.
    /// Otherwise, it processes a single refund.
    func handleRefund() {
        // Set default order ID if not already set
        if self.orderID.isEmpty {
            self.orderID = "mv1GZnrG2l2022101012552551446691695574999154823088265106bd73328c"
        }
        
        // Create refund request data
        let refundRequestData = RefundRequestModel(
            orderId: self.orderID,
            totalPrice: 1.0,
            customerFirstName: "John",
            customerEmail: "john@upayment.com",
            customerMobileNumber: "+96512345678",
            reference: "11223344",
            notifyUrl: "https://upayments.com/en"
        )
        
        // Print refund request data for debugging
        JSONUtilities.printModelAsJSON(refundRequestData)
        
        // Send refund request data to the API
        self.objPaymentAPIManager.fetchRefundDetails(token: self.apiToken, refundRequest: refundRequestData, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                }
                
                // Process the response data
                guard let responseDict = response["data"] as? [String: Any] else {
                    self.displayAlert(status: response["message"] as? String ?? "", responseMessage: response)
                    return
                }
                
                if (responseDict["isMultivendorRefund"] as? Int) == 1 {
                    // Handle multiple vendor refunds
                    let orderId = responseDict["orderId"] as? String
                    if let refundPayload = responseDict["refundPayload"] as? [[String: Any]] {
                        self.processMultiRefundRequest(orderId: orderId ?? "", payloadData: refundPayload)
                    } else {
                        self.displayAlert(status: response["message"] as? String ?? "", responseMessage: response)
                    }
                } else {
                    // Handle single refund
                    self.singleDeleteOrderID = responseDict["orderId"] as? String ?? ""
                    self.singleRefundOrderID = responseDict["refundOrderId"] as? String ?? ""
                    debugPrint("Order ID : \(self.singleDeleteOrderID)")
                    debugPrint("Refund Order ID : \(self.singleRefundOrderID)")
                    self.displayAlert(status: response["message"] as? String ?? "", responseMessage: response)
                }
            case .failure(let error):
                // Print and handle error response
                debugPrint(error.localizedDescription)
            }
        }
    }

    /// Processes multiple refund requests by updating payload data with refund amounts and sending it to the API.
    /// - Parameters:
    ///   - orderId: The unique identifier of the order for which refunds are being requested.
    ///   - payloadData: An array of dictionaries containing refund payload data.
    func processMultiRefundRequest(orderId: String, payloadData: [[String: Any]]) {
        // Initialize an array to hold updated payload data
        var updatedPayloadData: [[String: Any]] = []
        
        // Iterate over user-entered refund data
        for userRefund in arrUserEnteredRefundData {
            // Iterate over payload data to find matching ibanNumber
            for var item in payloadData {
                if userRefund["ibanNumber"] == item["ibanNumber"] as? String {
                    // Update the amount to refund and add to the updated payload data
                    if let amountToRefund = userRefund["amountToRefund"] {
                        item["amountToRefund"] = amountToRefund
                    }
                    updatedPayloadData.append(item)
                }
            }
        }
        
        // Print updated payload data for debugging
        debugPrint(updatedPayloadData)
        
        // Create the multi-refund request data dictionary
        let multiRefundRequestData: [String: Any] = [
            "orderId": orderId,
            "refundPayload": updatedPayloadData,
            "receiptId": "NHDBC55214",
            "customerFirstName": "John Smith",
            "customerEmail": "johnsmith@upayments.com",
            "customerMobileNumber": "+96512345678",
            "reference": "HCNHD1425KSM",
            "notifyUrl": "https://upayments.com"
        ]
        
        // Convert request data to JSON string for debugging
        if let jsonString = JSONUtilities.convertDictionaryToJSONString(dictionary: multiRefundRequestData) {
            debugPrint(jsonString)
        }
        
        // Send the multi-refund request to the API
        self.objPaymentAPIManager.fetchMultipleRefundDetails(headerToken: self.apiToken, refundRequest: multiRefundRequestData, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                }
                
                // Extract and handle response data
                let responseMessage = response["message"] as? String
                self.displayAlert(status: "", responseMessage: responseMessage ?? "")
                
                guard let responseData = response["data"] as? [String: Any],
                      let responseDataDict = responseData["responseData"] as? [String: Any],
                      let generatedArray = responseDataDict["generated"] as? [[String: AnyObject]],
                      let firstGeneratedData = generatedArray.first else {
                    return
                }
                
                self.multiDeleteRefundInvoiceID = firstGeneratedData["generatedInvoiceId"] as? String ?? ""
                self.multiDeleteOrderID = firstGeneratedData["orderId"] as? String ?? ""
                self.multiDeleteRefundARN = firstGeneratedData["refundArn"] as? String ?? ""
                self.multiDeleteRefundOrderID = firstGeneratedData["refundOrderId"] as? String ?? ""
                
                // Print the results
                debugPrint("Generated Refund Invoice ID : \(self.multiDeleteRefundInvoiceID)")
                debugPrint("Order ID : \(self.multiDeleteOrderID)")
                debugPrint("Refund ARN : \(self.multiDeleteRefundARN)")
                debugPrint("Refund Order ID : \(self.multiDeleteRefundOrderID)")
            case .failure(let error):
                // Handle error response
                self.displayAlert(status: "", responseMessage: error.localizedDescription)
                debugPrint(error.localizedDescription)
            }
        }
    }

    
    /// Sends a request to delete a single refund based on provided order and refund IDs.
    func deleteSingleRefund() {
        // Create the request data for single refund deletion
        let singleRefundRequest: [String: Any] = [
            "orderId": self.singleDeleteOrderID,
            "refundOrderId": self.singleRefundOrderID
        ]
        
        // Convert request data to JSON string for debugging
        if let jsonString = JSONUtilities.convertDictionaryToJSONString(dictionary: singleRefundRequest) {
            debugPrint(jsonString)
        }
        
        // Send the request to delete the single refund
        self.objPaymentAPIManager.deleteRefund(headerToken: self.apiToken, refundRequest: singleRefundRequest, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                    self.displayAlert(status: "", responseMessage: jsonResponse)
                }
            case .failure(let error):
                // Handle error response
                self.displayAlert(status: "", responseMessage: error.localizedDescription)
                debugPrint(error.localizedDescription)
            }
        }
    }

    /// Sends a request to delete multiple refunds based on provided refund details.
    func deleteMultiRefunds() {
        // Create the request data for multiple refund deletions
        let multiRefundRequest: [String: Any] = [
            "generatedInvoiceId": self.multiDeleteRefundInvoiceID,
            "orderId": self.multiDeleteOrderID,
            "refundArn": self.multiDeleteRefundARN,
            "refundOrderId": self.multiDeleteRefundOrderID
        ]
        
        // Convert request data to JSON string for debugging
        if let jsonString = JSONUtilities.convertDictionaryToJSONString(dictionary: multiRefundRequest) {
            print(jsonString)
        }
        
        // Send the request to delete multiple refunds
        self.objPaymentAPIManager.deleteMultiVendorRefund(headerToken: self.apiToken, refundRequest: multiRefundRequest, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                    self.displayAlert(status: "", responseMessage: jsonResponse)
                }
            case .failure(let error):
                // Handle error response
                self.displayAlert(status: "", responseMessage: error.localizedDescription)
                debugPrint(error.localizedDescription)
            }
        }
    }

    /// Sends a request to add card details using a unique customer token.
    func addCard() {
        // Retrieve the unique customer token from UserDefaults
        let customerUniqueToken = UserDefaults.standard.string(forKey: "customerUnique") ?? "0"
        
        // Create the request data for adding card details
        let addCardRequest: [String: Any] = [
            "returnUrl": "https://upayments.com/en/",
            "customerUniqueToken": Int(customerUniqueToken) ?? 0
        ]
        
        // Convert request data to JSON string for debugging
        if let jsonString = JSONUtilities.convertDictionaryToJSONString(dictionary: addCardRequest) {
            debugPrint(jsonString)
        }
        
        // Send the request to add card details
        self.objPaymentAPIManager.addCardDetails(isBackground: true, token: self.apiToken, cardRequest: addCardRequest, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                    self.displayAlert(status: "", responseMessage: jsonResponse)
                }
            case .failure(let error):
                // Handle error response
                self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
                debugPrint(error.localizedDescription)
            }
        }
    }

    /// Sends a request to fetch card details using a unique customer token.
    func fetchCardDetails() {
        // Retrieve the unique customer token from UserDefaults
        let customerUniqueToken = UserDefaults.standard.string(forKey: "customerUnique") ?? "0"
        
        // Create the request data for fetching card details
        let fetchCardRequest = TokenDataModel(customerUniqueToken: Int(customerUniqueToken) ?? 0)
        
        // Convert request model to JSON string for debugging
        JSONUtilities.printModelAsJSON(fetchCardRequest)
        
        // Send the request to fetch card details
        self.objPaymentAPIManager.fetchCardDetails(token: self.apiToken, cardRequestDetails: fetchCardRequest, controller: self) { result in
            switch result {
            case .success(let response):
                // Convert response to JSON string for debugging
                if let jsonResponse = JSONUtilities.convertDictionaryToJSONString(dictionary: response) {
                    debugPrint("Response:")
                    JSONUtilities.printModelAsJSON(jsonResponse)
                    self.displayAlert(status: "", responseMessage: jsonResponse)
                }
            case .failure(let error):
                // Handle error response
                self.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
                debugPrint(error.localizedDescription)
            }
        }
    }

}

extension ViewController {
    
    // MARK: - Helper Methods
    
    /// Displays a dropdown menu for selecting a payment type.
    func showPaymentTypeDropdown() {
        DispatchQueue.main.async {
            self.dropDownContainerView.isHidden = false
            
            let dropdown = DropDown()
            dropdown.direction = .bottom
            dropdown.cellHeight = 40
            dropdown.anchorView = self.dropDownContainerView
            dropdown.dataSource = self.arrPaymentOptions
            dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                // Parse the selected payment type
                let paymentType = self.arrPaymentOptions[index].split(separator: "_")
                debugPrint(paymentType)
                
                // Determine the payment value based on the selection
                let paymentValue: String
                if paymentType.count == 2 {
                    paymentValue = "\(paymentType[0])-\(paymentType[1])"
                } else {
                    paymentValue = "\(paymentType[0])"
                }
                
                // Set the source value based on the payment type
                self.sourceValue = (paymentValue == "credit-card") ? "cc" : paymentValue
                
                // Adjust the dropdown position and hide the container view
                dropdown.bottomOffset = CGPoint(
                    x: 0,
                    y: self.dropDownContainerView.frame.maxY
                )
                self.dropDownContainerView.isHidden = true
                
                // Trigger payment initiation based on the selected API type
                if self.apiType == "1" {
                    self.initiateSingleProductPayment()
                } else if self.apiType == "2" {
                    self.processPaymentForMultipleProducts()
                }
            }
            dropdown.show()
        }
    }
    
    /// Retrieves the unique customer token. If none exists, a new token is created.
    func retrieveCustomerUniqueToken() {
        if let customerUniqueToken = UserDefaults.standard.string(forKey: "customerUnique") {
            self.customerUniqueID = customerUniqueToken
            debugPrint("Customer Unique Token: \(self.customerUniqueID)")
            
            // Create a new token if the retrieved token is not valid
            if self.customerUniqueID.isEmpty {
                self.createNewCustomerToken()
            }
        } else {
            // Create a new token if none exists
            self.createNewCustomerToken()
        }
    }
    
    /// Creates a new customer token and updates the stored token in UserDefaults.
    func createNewCustomerToken() {
        let token = self.customerUniqueNumber
        let tokenRequestModel = CustomerTokenRequestModel(customerUniqueToken: token)
        
        self.objPaymentAPIManager.createCustomerToken(
            token: self.apiToken,
            customerTokenRequestDetail: tokenRequestModel,
            controller: self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                JSONUtilities.printModelAsJSON(response)
                self?.displayAlert(status: response.message ?? "", responseMessage: response)
                
                // Update the customer unique ID and store it in UserDefaults
                self?.customerUniqueID = String(response.data?.customerUniqueToken ?? 0)
                UserDefaults.standard.set(self?.customerUniqueID, forKey: "customerUnique")
                debugPrint(self?.customerUniqueID ?? "")
                
            case .failure(let error):
                self?.displayAlert(status: String(error.httpStatusCode ?? 0), responseMessage: error.reason ?? "")
            }
        }
    }
}

