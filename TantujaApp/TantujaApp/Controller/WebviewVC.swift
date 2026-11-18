//
//  WebviewVC.swift
//  Tantuja
//
//  Created by Niranjan on 07/10/22.
//

import UIKit
//import WebKit
import Razorpay

class WebviewVC: UIViewController, RazorpayProtocol{

    
//    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var strURL = ""
    var amountStr = 0
    
    var razorpayObj : RazorpayCheckout? = nil
//    let defaultHeight : CGFloat = 40
//    let defaultWidth : CGFloat = 120
//
    let razorpayKey = "rzp_live_8Tu7NHdgOVlTDY"

    
    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //Testing
        var merchantKey = "7rnFly"
        var salt = "pjVQAWpA"
        var PayUBaseUrl = "https://test.payu.in"

        //Production

       // var merchantKey = “xxxxx”
       // var salt = “xxxx”
       // var PayUBaseUrl = "https://secure.payu.in"
    
    
    var hashKey: String! = nil
        var totalPriceAmount = "100"//String()
        let productInfo = "Tantuj" //Project name or anything else
        let firstName = "Arun"
        let email = "arunhalder.leo@gmail.com"
        let phone = "9876543210"
        let successUrl = "https://www.payumoney.com/mobileapp/payumoney/successs.php"   //Success URL
        let failureUrl = "https://www.payumoney.com/mobileapp/payumoney/failuree.php"   //Failure URL
        let service_provider = "payu_paisa"
        var txnid1: String! = ""    //a unique id for specific order number.


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.initPayment()
        
        self.openRazorpayCheckout()

    }
    
    
    private func openRazorpayCheckout() {
        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
        razorpayObj = RazorpayCheckout.initWithKey(razorpayKey, andDelegate: self)
        let options: [AnyHashable:Any] = [
            "prefill": [
                "contact": "1234567890",
                "email": "a@a.com"
                //                "method":"wallet",
                //                "wallet":"amazonpay"
            ],
            "image": "http://www.freepngimg.com/download/light/2-2-light-free-download-png.png",
            "amount" : "\(amountStr * 100)",
            "timeout":97,
            "theme": [
                "color": "#3371AE"
            ]//            "order_id": "order_B2i2MSq6STNKZV"
            // and all other options
        ]
        if let rzp = self.razorpayObj {
            rzp.open(options)
        } else {
            print("Unable to initialize")
        }
    }
    
    /*
    func initPayment() {
           //Creating taxation id with timestamp
           txnid1 = "Tantuj\(String(Int(NSDate().timeIntervalSince1970)))"

           //Generating Hash Key
        let hashValue = String.localizedStringWithFormat("%@|%@|%@|%@|%@|%@|||||||||||%@",merchantKey,txnid1,totalPriceAmount,productInfo,firstName,email,salt)
           let hash=self.sha1(string: hashValue)
        print(hashValue)
        print(hash)

        let postStr = "txnid=\(txnid1!)&key=\(merchantKey)&amount=\(totalPriceAmount)&productinfo=\(productInfo)&firstname=\(firstName)&email=\(email)&phone=\(phone)&surl=\(successUrl)&furl=\(failureUrl)&hash=\(hash)&service_provider=\(service_provider)"
        print(postStr)
        
//        let postStr1 = "txnid="+txnid1+"&key="+merchantKey+"&amount="+totalPriceAmount+"&productinfo="+productInfo+"&firstname="+firstName!+"&email="+email!+"&phone="+phone!+"&surl="+successUrl+"&furl="+failureUrl+"&hash="+hash+"&service_provider="+service_provider
           
           
           let url = NSURL(string: String.localizedStringWithFormat("%@/_payment", PayUBaseUrl))
           let request = NSMutableURLRequest(url: url! as URL)
               
           do {
               let postLength = String.localizedStringWithFormat("%lu",postStr.count)
               request.httpMethod = "POST"
               request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Current-Type")
               request.setValue(postLength, forHTTPHeaderField: "Content-Length")
               request.httpBody = postStr.data(using: String.Encoding.utf8)
               myWebView.loadRequest(request as URLRequest)
           } catch let error as NSError {
               print("Error:", error)
           }
       }

       func sha1(string:String) -> String {
           let cstr = string.cString(using: String.Encoding.utf8)
           let data = NSData(bytes: cstr, length: string.count)
           var digest = [UInt8](repeating: 0, count:Int(CC_SHA512_DIGEST_LENGTH))
           CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
           let hexBytes = digest.map { String(format: "%02x", $0) }
           return hexBytes.joined(separator: "")
       }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
            let requestURL = self.myWebView.request?.url
            let requestString:String = (requestURL?.absoluteString)!
            if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/success.php") {
                print("success payment done")
            }else if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/failure.php") {
                print("payment failure")
            }
        }
        
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
            let requestURL = self.myWebView.request?.url
            print("WebView failed loading with requestURL: \(requestURL) with error: \(error.localizedDescription) & error code: \(error)")
            
            if error._code == -1009 || error._code == -1003 {
                showAlertView(string: "Please check your internet connection!")
            }else if error._code == -1001 {
                showAlertView(string: "The request timed out.")
            }
        }

        func showAlertView(string: String) {
            let alertController = UIAlertController(title: "Alert", message: string, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                (result : UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "goBackToOrderPage", sender: self)
                //Go back to place order page.
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    */
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        self.presentAlert(withTitle: "Alert", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
    }
    
    //**********//
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        self.presentAlert(withTitle: "Alert", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
    }
    
    func presentAlert(withTitle title: String?, message : String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}

// RazorpayPaymentCompletionProtocol - This will execute two methods 1.Error and 2. Success case. On payment failure you will get a code and description. In payment success you will get the payment id.


// RazorpayPaymentCompletionProtocolWithData - This will returns you the data in both error and success case. On payment failure you will get a code and description. In payment success you will get the payment id.



