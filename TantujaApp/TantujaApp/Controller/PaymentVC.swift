//
//  PaymentVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit
import CryptoSwift
import SwiftyJSON

class PaymentVC: UIViewController {
    //Text Field Connection
       @IBOutlet weak var txtDatePicker: UITextField!
       //Uidate picker
       let datePicker = UIDatePicker()
    @IBOutlet var dropdownPicker: UIPickerView!
    var strDob = String()
    @objc let datePickerCompletion = UIDatePicker()
    @IBOutlet var dobBtn: UIButton!

    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var datePickerProfile: UIDatePicker!
    
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var btnPayLater: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var viewOnline: RoundView!
    @IBOutlet weak var viewOffline: RoundView!
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var btnCheckBox: UIButton!
    var rationFlag = "0"
    var selectedDate  = ""
    var paymentValue = 0
    var paylaterEnableBool = true
    
    @IBOutlet weak var btnCheckBox2: UIButton!
    var paymentCheck:Bool = false
    @IBOutlet weak var lblNetPay: UILabel!
    
    @IBOutlet weak var viewCardDetailsHeight: NSLayoutConstraint!
    var netPay = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPayNow.isUserInteractionEnabled = false
        self.btnPayLater.isUserInteractionEnabled = false
        netPay = UserDefaults.standard.double(forKey: "total")
         print("total:\(netPay)")
        let strNetValue = String(format: "%.2f", netPay)
        let doubleValueStr = Double(strNetValue)
        paymentValue = (doubleValueStr?.toInt())!
        lblNetPay.text = "Net Payable: ₹\(strNetValue)"

        
    }

    
    // MARK:- ActivityIndicator Methods
    
    func showActivityIndicator() {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator() {
        
       self.activityIndicator.stopAnimating()
        
       UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    @IBAction func action_SelectDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .date, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let dateValue = selectedDate.dateString("dd/MM/yyyy")
            //self?.txtDatePicker.text = dateValue
            let valDate = selectedDate.dateString("yyyy-MM-dd")
            let result1 = AuthService.instance.holidayListing.contains(JSON(rawValue: "\(valDate)") ?? "")
            if result1 == true{
                self?.paylaterEnableBool = false
            }
            else{
                self?.paylaterEnableBool = true
            }
            
                self?.btnDate.setTitle(dateValue, for: .normal)
                self?.btnPayNow.isUserInteractionEnabled = true

                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.month = 0
                dateComponent.day = 1
                dateComponent.year = 0
                let future1Date = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                let new1 = future1Date!.dateString("yyyy-MM-dd")
                print(new1)

                
                self?.selectedDate = valDate
                dateComponent.day = 2
                let future2Date = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                let new2 = future2Date!.dateString("yyyy-MM-dd")
                print(new2)
               // self?.lbl_DateMonth.text = valDate
                if valDate == "\(new1)"{
                    self?.btnPayNow.isUserInteractionEnabled = true
                    self?.btnPayLater.isUserInteractionEnabled = true
                } else if valDate == "\(new2)"{
                    self?.btnPayNow.isUserInteractionEnabled = true
                    self?.btnPayLater.isUserInteractionEnabled = true
                } else{
                    self?.btnPayNow.isUserInteractionEnabled = true
                    self?.btnPayLater.isUserInteractionEnabled = false
                }
                
                self!.btnCheckBox.setImage(UIImage(named: ""), for: UIControl.State.normal)
                self!.btnCheckBox2.setImage(UIImage(named: ""), for: UIControl.State.normal)
                UserDefaults.standard.set("", forKey: "paymentMethod")
                self!.paymentCheck = false

        })
    }
    @IBAction func actionDoneDate(_ sender: Any) {
         
         let formatter = DateFormatter()
         formatter.dateFormat = "MM/dd/yyyy"
         let pickedDate = formatter.string(from: datePickerProfile.date)

         dobBtn.setTitle(pickedDate, for: .normal)
        print("dob:%@",dobBtn.titleLabel?.text! ?? "")
       //  viewDatePicker.isHidden = true
     }
     

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.holidayListingAPICAll()
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    func holidayListingAPICAll(){
     //   HUD.show(to: self.view)
        if (NetworkState().isInternetAvailable) {
            AuthService.instance.HolidayListAPI(completion: {(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                    
                    
                }
                else{
                    HUD.hide(to: self.view)
                }
        })
        }
        else{
            HUD.hide(to: self.view)
        }
    }
    
    
    @IBAction func actionOnline(_ sender: Any) {
        btnCheckBox.setImage(UIImage(named: "circletick"), for: UIControl.State.normal)
        btnCheckBox2.setImage(UIImage(named: ""), for: UIControl.State.normal)
        UserDefaults.standard.set("online", forKey: "paymentMethod")
        self.paymentCheck = true
    }
    
    @IBAction func actionCashOnDelivery(_ sender: Any) {
        if paylaterEnableBool == true{
            btnCheckBox.setImage(UIImage(named: ""), for: UIControl.State.normal)
            btnCheckBox2.setImage(UIImage(named: "circletick"), for: UIControl.State.normal)
            UserDefaults.standard.set("cashOnDelivery", forKey: "paymentMethod")
            self.paymentCheck = true
        }
        else{
            self.showAlertWith(message: "Selected pickup date is holiday please choose a different date")
        }
        
    }
    
    
    

    
    @IBAction func actionPaynow(_ sender: Any) {
        
        if paymentCheck == false{
            
            self.showAlertWith(message: "Please select payment option")

        }else{
            
            if paylaterEnableBool == true{
                let strValue : String = UserDefaults.standard.string(forKey: "paymentMethod") ?? ""

                print("value: \(strValue)")
                
                if strValue == "online" {
                   // setupPayu()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
                    vc.amountStr = paymentValue
                    self.navigationController?.pushViewController(vc,animated: true)
                    
                }else{
                    
                    var i = 0
                    var rowArr = [[String:String]]()
                    while i<AuthService.instance.cartListing.count{
                        var rowDict = [String:String]()
                        rowDict["id"] = AuthService.instance.cartListing[i]["cat_id"].stringValue
                        rowArr.append(rowDict)
                        i += 1
                }
                    
                    let isConnected = ReachabilityClass.isConnectedToNetwork()
                                if (isConnected == true) {
                                    AuthService.instance.payment(cartData: rowArr, paymentModeStr: "0", subTotalStr: "\(AuthService.instance.subtotal)", gstString: "\(AuthService.instance.gst)", cgstString: "\(AuthService.instance.cgst)", sgstString: "\(AuthService.instance.sgst)", totalString: "\(AuthService.instance.total)", pickupDateString: self.selectedDate, completion:{(success, data, message) in
                                        if success{
                                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC//MyOrderVC
                                            self.navigationController?.pushViewController(vc, animated: false)
                                        }
                                        else{
                                           // self.showAlertWith(message: message!)
                                        }
                                })

                        }
                        else {
                            self.showAlertWith(message: "No internet connection!")
                        }
                    
                }
            }
            else{
                self.showAlertWith(message: "Selected pickup date is holiday please choose a different date")
            }
                
            
            
        }
        
        
    }
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func setupPayu()
    {
//      let kMerchantSalt = "Etal4JIhcJF1XHk5BuvFruzdB6Ygl9HB"
        let kMerchantSalt = "pjVQAWpA"
        let txnParam = PUMTxnParam()
        PlugNPlay.setDisableCompletionScreen(true)
        //Set the parameters
        
        txnParam.phone = "8240201059"
        txnParam.email = "nbarik1407@gmail.com"
        txnParam.amount = "10"
        txnParam.environment = PUMEnvironment.test //PUMEnvironment.production
        txnParam.firstname = "Niranjan"
//      txnParam.key = "cch28f"
        txnParam.key = "7rnFly"
//      txnParam.merchantid = "8442887"
        txnParam.merchantid = "9025782"
        txnParam.txnID = "7605592"

        txnParam.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        txnParam.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        txnParam.productInfo = "iPhone"
        txnParam.udf1 = "iPhone 13"
        txnParam.udf2 = "nbarik1407@gmail.com"
        txnParam.udf3 = "8240201059"
        txnParam.udf4 = "kolkata"
        txnParam.udf5 = "76055179"

//        txnParam.udf6 = ""
//        txnParam.udf7 = ""
//        txnParam.udf8 = ""
//        txnParam.udf9 = ""
//        txnParam.udf10 = ""
        let hashString = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo!)|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)||||||\(kMerchantSalt)"
        
        /*
        let strUrl = "https://test.payu.in/_payment?key="
        let strMarchantID = "7rnFly" //txnParam.merchantid
        let strTransectionID = "&txnid=\(txnParam.udf5!)"
        let strAmount = "&amount="+"\(AuthService.instance.total)"
        let strProduct = "&productinfo=iPhone"
        let strEmail = "&email=\(txnParam.email!)"
        let strFname = "&firstname=\(txnParam.firstname!)"
        let sfUrl     = "&surl=https://www.payumoney.com/mobileapp/payumoney/success.php&furl=https://www.payumoney.com/mobileapp/payumoney/failure.php&phone="
        let strP     = txnParam.udf3
        let strEnd  = "&hash=0afdb2d168676256b0077e0871719ed2fa5f2a99d9d85230c187b49480304a21e96c3172f3f640ce98cbd23a157ae191f45786ad0490080fbdd6e9861dbb30a6"
        
       // let strFinal = strUrl + strMarchantID + strTransectionID + strAmount + strProduct + strEmail + strFname + sfUrl + strP + strEnd
        
        let strFinal = "\(strUrl)\(strMarchantID)\(strTransectionID)\(strAmount)\(strProduct)\(strEmail)\(strFname)\(sfUrl)\(strP!)\(strEnd)"
        print("full str \(strFinal)")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        vc.strURL = strFinal
        self.navigationController?.pushViewController(vc, animated: false)
        
        */
        let data = hashString.data(using: .utf8)
        // https://test.payu.in/_payment?key=9025782&txnid=76055179&amount=10&productinfo=iPhone%2013&email=nbarik1407@gmail.com&firstname=Abc&surl=https://www.payumoney.com/mobileapp/payumoney/success.php&furl=https://www.payumoney.com/mobileapp/payumoney/failure.php&phone=8240201059&hash=0afdb2d168676256b0077e0871719ed2fa5f2a99d9d85230c187b49480304a21e96c3172f3f640ce98cbd23a157ae191f45786ad0490080fbdd6e9861dbb30a6
        
       txnParam.hashValue = data?.sha512().toHexString()
      PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self) { (response, error, extraParam) in

        print(response)

            print(error as Any)

       }
    }
    

  //  showActivityIndicator()
    
    
//  self.hideActivityIndicator()

    
    @IBAction func btnBackButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension Double {
    
    func toInt() -> Int? {
        let roundedValue = rounded(.toNearestOrEven)
        return Int(exactly: roundedValue)
    }
    
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears

        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAddingMonth(_ dMonth: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = dMonth

        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
}
