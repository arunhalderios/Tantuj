//
//  CreateOrderViewController.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 06/09/22.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CreateOrderViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var priceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackHightConstant: NSLayoutConstraint!
    @IBOutlet weak var vw_Type: UIView!
    @IBOutlet weak var vw_Particular: UIView!
    @IBOutlet weak var vw_SupplyMeal: UIView!
    @IBOutlet weak var lbl_Discount15Percent: UILabel!
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    //********** UILabel *************//
    @IBOutlet weak var lblHub:            UILabel!
    @IBOutlet weak var lblCategory:       UILabel!
    @IBOutlet weak var lblItemParticular: UILabel!
    @IBOutlet weak var lblMill:           UILabel!
    @IBOutlet weak var lblKG:             UILabel!
    
    //********** UILabel Title *************//

    @IBOutlet weak var lblHubTitle:            UILabel!
    @IBOutlet weak var lblCategoryTitle:       UILabel!
    @IBOutlet weak var lblItemParticularTitle: UILabel!
    @IBOutlet weak var lblMillTitle:           UILabel!
    @IBOutlet weak var lblKGTitle:             UILabel!
    @IBOutlet weak var lblEachBundle:          UILabel!
    
    //********** UIView *************//

    
    @IBOutlet weak var vwItem: RoundView!
    
    //********** UITextField *************//

    @IBOutlet weak var txtType:           UITextField!
    @IBOutlet weak var txtHub:            UITextField!
    @IBOutlet weak var txtCategory:       UITextField!
    @IBOutlet weak var txtItemParticular: UITextField!
    @IBOutlet weak var txtMill:           UITextField!
   // @IBOutlet weak var txtKG:             UITextField!
    
    
    @IBOutlet weak var txtBundleKG:      UITextField!
    
    @IBOutlet weak var lbl_SellingPrice:       UILabel!
    @IBOutlet weak var lbl_SellPerAmountPrice: UILabel!
    
    @IBOutlet weak var lbl_DiscountPrice: UILabel!
    @IBOutlet weak var lbl_OrderAmount: UILabel!
    
    //********** UIButton *************//

    @IBOutlet weak var lblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblType:                UILabel!

    @IBOutlet weak var lblTypeHeightConstaint: NSLayoutConstraint!

    
    @IBOutlet weak var lblHunkDiscount: UILabel!
    
    @IBOutlet weak var btnButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    @IBOutlet weak var vwConstrain: RoundView!
    
    
    var alertForName :UIAlertController = UIAlertController()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var selectedHubID = Int()
    var selectedSocityID = Int()
    var selectedTypeID = Int()
    var selectedMilkID = Int()
    var selectedCatID = Int()
    
    var bundleInt = Double()
    var weightInt = Double()
    var getBundleValue = ""

    
    var bundle_size = ""
    var max_order_quantity = Int()
    var bundle_weight = ""
    
    
    var sellingCostPerKg = Double()
    var totalSellingCostPerKg = Double()

    var quantityPerKg : Double = Double()
    var bundle_size_Cotton : Double = Double()

    var selectedYarnID = Int()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    //var typeArray = ["Silk", "Cotton"]
    var typeArray : [String] = ["Hank", "Cone"]
    var typeIdArray : [Int] = [1,2]
    
    
    @IBAction func btnCartAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc,animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strCartCount : Int = AuthService.instance.count ?? 0
        print(strCartCount)
        
        let strCart_Count = UserDefaults.standard.integer(forKey: "cartListing_Count")
        if strCart_Count == strCartCount {
            lbl_Count.text   = String(strCartCount)
            print(lbl_Count.text)
        }else{
            lbl_Count.text   = String(strCart_Count)
            print(lbl_Count.text)
        }
        languageSetup()
        self.lblHub.isHidden = false
        // HubListAPI
    }
    
    
    func languageSetup(){
        
        
        lblHubTitle.text = defaultLocalizer.stringForKey(key: "Order From *")
        lblHub.text      = defaultLocalizer.stringForKey(key: "Select Hub")

        lblCategoryTitle.text = defaultLocalizer.stringForKey(key: "Category *")
        lblCategory.text      = defaultLocalizer.stringForKey(key: "Select Category")
        
        
        lblItemParticularTitle.text = defaultLocalizer.stringForKey(key: "Item Particulars *")
        lblItemParticular.text = defaultLocalizer.stringForKey(key: "Select item particulars")

        
        lblMillTitle.text    = defaultLocalizer.stringForKey(key: "Supply Mill *")
        lblMill.text         = defaultLocalizer.stringForKey(key: "Select supply mill")

        
        lblKGTitle.text       = defaultLocalizer.stringForKey(key: "Enter Bundle *")
        lblKG.text            = defaultLocalizer.stringForKey(key: "kg")
        
       // lblEachBundle.text       = defaultLocalizer.stringForKey(key: "Place New Order")

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.txtBundleKG.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let strCartCount : Int = AuthService.instance.count ?? 0
        print(strCartCount)
        
        let strCart_Count = UserDefaults.standard.integer(forKey: "cartListing_Count")

        if strCart_Count == strCartCount {
            
            lbl_Count.text   = String(strCartCount)
            print(lbl_Count.text!)
            
        }else{
            
            lbl_Count.text   = String(strCart_Count)
            print(lbl_Count.text!)
        }
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @objc func textFieldDidChange(){
        
            if txtCategory.text == "Silk"  {
                if self.txtItemParticular.text != ""{
                    print("text changed:", txtBundleKG.text!)
                    if let text = txtBundleKG.text! as NSString? {
                        self.getBundleValue = text as String
                        bundleInt = Double(text as Substring) ?? Double()
                    print("bundle: \(bundleInt)")
                    print(txtBundleKG.text)
                    let value = self.txtBundleKG.text!
                    bundleInt = Double(value) ?? Double()
                    print("bundleInt: \(bundleInt)")
                    let kgVal = bundleInt * 4.54
                    lblKG.text = String(format: "%.2fKG", kgVal)

                    if value != ""{
                        let amountPrice = Double(self.sellingCostPerKg) * Double(bundle_size_Cotton) * Double(bundleInt)
                        print("Total: \(amountPrice)")

                        self.lbl_SellingPrice.text = "₹ \(self.sellingCostPerKg)"
                        self.lbl_SellPerAmountPrice.text = String(format: "₹ %.2f", amountPrice)
                        totalSellingCostPerKg = amountPrice
                        let discount = (15 * amountPrice) / 100.0
                        let orderAmount = amountPrice - discount
                        self.lbl_DiscountPrice.text = String(format: "₹ %.2f",discount)
                        self.lbl_OrderAmount.text =  String(format: "₹ %.2f",orderAmount)
                        //"\(amountPrice)"
                    }
                    else{
                       print("test")
                    }
                    }
                }else{
                    self.txtBundleKG.text = ""
                    self.lblKG.text = "KG"
                    self.showAlertWith(message: "Please select item particular")
                }

            }else{
                if self.txtMill.text != ""{
                    print("text changed:", txtBundleKG.text!)
                    if let text = txtBundleKG.text! as NSString? {
                        self.getBundleValue = text as String
                        bundleInt = Double(text as Substring) ?? Double()
                    print("bundle: \(bundleInt)")
                    print(txtBundleKG.text)
                    let value = self.txtBundleKG.text!
                    bundleInt = Double(value) ?? Double()
                    print("bundleInt: \(bundleInt)")
                    let kgVal = bundleInt * 4.54
                    lblKG.text = String(format: " %.2fKG", kgVal)

                    if value != ""{
                        let amountPrice = Double(self.sellingCostPerKg) * Double(bundle_size_Cotton) * Double(bundleInt)
                        print("Total: \(amountPrice)")

                        self.lbl_SellingPrice.text = "₹ \(self.sellingCostPerKg)"
                        self.lbl_SellPerAmountPrice.text = String(format: "₹ %.2f", amountPrice)
                        totalSellingCostPerKg = amountPrice
                        if AuthService.instance.hasICard == false{
                            self.lbl_OrderAmount.text =  String(format: "₹ %.2f",amountPrice)
                        }
                        else{
                            let discount = (15 * amountPrice) / 100.0
                            let orderAmount = amountPrice - discount
                            self.lbl_DiscountPrice.text = String(format: "₹ %.2f",discount)
                            self.lbl_OrderAmount.text =  String(format: "₹ %.2f",orderAmount)
                        }

                        //"\(amountPrice)"
                    }
                    else{
                       print("test")
                    }
                    }
                }else{
                    self.txtBundleKG.text = ""
                    self.lblKG.text = "KG"
                    self.showAlertWith(message: "Please select the supply mill")
                }

            }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
       
        if (txtHub.isFirstResponder == true) {
                   
            self.view.endEditing(true)
           self.showHubListing()
           
        }
       else if (txtCategory.isFirstResponder == true) {
                   
            self.view.endEditing(true)
           self.showCategoryListing()
           
        }
        else if (txtType.isFirstResponder == true) {
                    
             self.view.endEditing(true)
            self.showTypeListing()
            
         }
        else if (txtItemParticular.isFirstResponder == true) {
                    
             self.view.endEditing(true)
            self.showItemParticular()
            
         }
        else if (txtMill.isFirstResponder == true) {
                    
             self.view.endEditing(true)
            self.showSupplymill()
            
         }
//        else if (txtKG.isFirstResponder == true){
//            print("Test")
//            let value =  self.txtKG.text!
//            if value != ""{
//                let sellingPrice = Int(value)! * self.sellingCostPerKg
//                let amountPrice = Int(value)! * self.quantityPerKg
//
//                self.lbl_SellingPrice.text = "\(sellingPrice)"
//                self.lbl_SellPerAmountPrice.text = "\(amountPrice)"
//            }
//        }
//        if (textField == self.txtKG){
//            let value =  self.txtKG.text!
//            if value != ""{
//                let sellingPrice = Int(value)! * self.sellingCostPerKg
//                let amountPrice = Int(value)! * self.quantityPerKg
//
//                self.lbl_SellingPrice.text = "\(sellingPrice)"
//                self.lbl_SellPerAmountPrice.text = "\(amountPrice)"
//            }
//
//        }

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
        if textField == txtBundleKG{
            
            if let text = textField.text as NSString? {
                self.getBundleValue = text as String
                bundleInt = Double(text as Substring) ?? Double()
            print("bundle: \(bundleInt)")
            print(txtBundleKG.text)
            let value = self.txtBundleKG.text!
            bundleInt = Double(value) ?? Double()
            print("bundleInt: \(bundleInt)")
            let kgVal = bundleInt * 4.54
            lblKG.text = "\(kgVal) KG"

            if value != ""{
                
               // let selP         = Double(value)! * (self.sellingCostPerKg)
                //let sellingPrice = Double(value)! * (self.sellingCostPerKg )
                let amountPrice = Double(self.sellingCostPerKg) * Double(bundle_size_Cotton) * Double(bundleInt)
                print("Total: \(amountPrice)")

                self.lbl_SellingPrice.text = "₹ \(self.sellingCostPerKg)"
                self.lbl_SellPerAmountPrice.text = String(format: "₹ %.2f", amountPrice)
                totalSellingCostPerKg = amountPrice
                //"\(amountPrice)"
            }
            else{
               print("test")
            }
            }

        }
    }
    

    @IBAction func bundleFldFldEditingDidBegin(_ sender: Any) {
       // print(txtBundleKG.text)
    }
    
    @IBAction func bundleFldEditingChange(_ sender: Any) {
        print(txtBundleKG.text as Any)

    }
    
    @IBAction func bundleValueChange(_ sender: Any) {
        print(txtBundleKG.text)

    }
    
    

    
    func showHubListing(){
        HUD.show(to: self.view)

        let isConnected = ReachabilityClass.isConnectedToNetwork()
        if (isConnected == true) {
            AuthService.instance.HubListAPI { success, data, message in
                if success{
                    HUD.hide(to: self.view)

                    do{
                        if AuthService.instance.dataArrayList.count > 0 {
                            self.alertForName = UIAlertController(title: "Select Hub", message: nil, preferredStyle: .actionSheet)
                       for i in 0..<AuthService.instance.dataArrayList.count {
                           let dictName : NSDictionary = AuthService.instance.dataArrayList.object(at: i) as? NSDictionary ?? NSDictionary()
                           let strName : String = dictName.value(forKey: "name") as? String ?? ""
                           let strID = dictName["id"] as? Int ?? Int()
                           let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{  (UIAlertAction)in
                               self.selectedHubID  = strID
                               print("SelectedHubID: \(self.selectedHubID)")
                               print("name: \(strName)")
                               self.lblHub.isHidden = true
                               self.txtHub.text = "\(strName)"
                               self.txtType.text = ""
                               self.txtCategory.text = ""
                               self.txtType.text = ""
                               self.txtItemParticular.text = ""
                               self.txtMill.text = ""
                               self.txtBundleKG.text = ""

                               self.lblType.isHidden = false
                               self.lblCategory.isHidden = false
                               self.lblType.isHidden = false
                               self.lblItemParticular.isHidden = false
                               self.lblMill.isHidden = false
                               self.lbl_Discount15Percent.isHidden = true
                               self.lblKG.text = "KG"
                               
                               
                           }) as? UIAlertAction ?? UIAlertAction()
                           self.alertForName.addAction(actioninArray)
                           }
                            self.alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
                           print("User click Dismiss button")
                           }))
                            self.alertForName.popoverPresentationController?.sourceView = self.view
                            self.alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                            self.alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            self.present(self.alertForName, animated: true, completion: {
                            print("completion block")
                           self.hideActivityIndicator()
                       })
                    }
                   }
                  catch{
                    print(error)
                }
                }
                else{
                    HUD.hide(to: self.view)
                    self.showAlertWith(message: "Your session is expired. Please login again")
                }
            }
        }else{
            HUD.hide(to: self.view)
            popUpAlert(msg: "No internet connection!")
        }
    }
    
    func showCategoryListing(){
        HUD.show(to: self.view)
        if self.txtHub.text != ""{
            let isConnected = ReachabilityClass.isConnectedToNetwork()
            if (isConnected == true) {
                AuthService.instance.CategoryListAPI { success, data, message in
                    if success{
                        HUD.hide(to: self.view)
                        do{
                            if AuthService.instance.dataCategoryList.count > 0 {
                            self.alertForName = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
                                              
                          
                           for i in 0..<AuthService.instance.dataCategoryList.count {
                               
                               let dictName : NSDictionary = AuthService.instance.dataCategoryList.object(at: i) as? NSDictionary ?? NSDictionary()
                               let strName : String = dictName.value(forKey: "name") as? String ?? ""
                               let strID = dictName["id"] as? Int ?? Int()
                               
                               let strBundle_weight : String = dictName.value(forKey: "bundle_weight") as? String ?? ""
                               self.weightInt = Double(strBundle_weight) ?? 0
                               let strMax_order_quantity = dictName["max_order_quantity"] as? Int ?? Int()

                               let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{ [self]  (UIAlertAction)in
                                                                         
                                   self.selectedCatID  = strID
                                   print("selectedCatID: \(strID)")
                                   print("Cat_name: \(strName)")
                                 
                                   self.txtCategory.text = "\(strName)"
                                   self.txtType.text = ""
                                   self.txtItemParticular.text = ""
                                   self.txtMill.text = ""
                                   self.txtBundleKG.text = ""
                                   
                                   self.lblType.isHidden = false
                                   self.lblItemParticular.isHidden = false
                                   self.lbl_Discount15Percent.isHidden = true
                                   self.lblMill.isHidden = false
                                   self.lblKG.text = "KG"

                                   if self.txtCategory.text == "Cotton" {
                                       
                                       self.lblEachBundle.text = "Each bundle contains 4.54 kg cotton"
                                       self.vw_Type.isHidden = false
                                       self.vw_Particular.isHidden = false
                                       self.vw_SupplyMeal.isHidden = false
                                       self.stackHightConstant.constant = 600.0
                                       self.priceHeightConstraint.constant = 60.0
                                       self.stack1.isHidden = true
                                       self.stack2.isHidden = true
                                       
                                       self.lblHunkDiscount.isHidden = false
                                     
                                       
                                   }else{
                                       
                                    
                                       self.lblEachBundle.text = "Each bundle contains 4.54 kg cotton"
                                       self.vw_Type.isHidden = true
                                       self.vw_Particular.isHidden = false
                                       self.vw_SupplyMeal.isHidden = true
                                       self.lblHunkDiscount.isHidden = true
                                       self.stackHightConstant.constant = 400.0
                                       self.priceHeightConstraint.constant = 60.0
                                       self.stack1.isHidden = true
                                       self.stack2.isHidden = true
                                     
                                   }
                                   
                                   self.bundle_weight  = strBundle_weight
                                   self.weightInt  = Double(strBundle_weight) ?? 0.0
                                   self.lblCategory.isHidden = true
                                   self.max_order_quantity  = strMax_order_quantity
                                   print("bundle_weight: \(self.bundle_weight)")
                                   print("max_order_quantity: \(self.max_order_quantity)")
                                   
                                                     
                               }) as? UIAlertAction ?? UIAlertAction()
                                                  
                                                  
                               self.alertForName.addAction(actioninArray)
                                                  
                               }
                                                                  
                                self.alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
                                  //  self.lblHub.isHidden = false
                               print("User click Dismiss button")
                                                                        
                               }))
                                                                        
                                                                    
                                self.alertForName.popoverPresentationController?.sourceView = self.view
                                self.alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                                self.alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                self.present(self.alertForName, animated: true, completion: {
                                print("completion block")
                               self.hideActivityIndicator()
                           })
                        }
                       }
                      catch{
                        print(error)
                    }

                        
                    }
                    else{
                        HUD.hide(to: self.view)
                        self.showAlertWith(message: "Your session is expired. Please login again")

                    }
                    
                }
                
            }else{
                HUD.hide(to: self.view)
                popUpAlert(msg: "No internet connection!")
                
            }
        }
        else{
            HUD.hide(to: self.view)
            self.showAlertWith(message: "Please select HUB first")
        }
        
    }
    
    func showTypeListing(){
            
        self.alertForName = UIAlertController(title: "Select Type", message: nil, preferredStyle: .actionSheet)
            for i in 0..<typeArray.count {
                let strName : String = typeArray[i]
                // let strID = dictName.value(forKey: "id").intValue
                let strID = typeIdArray[i]
        let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{  (UIAlertAction)in
            self.selectedTypeID  = strID as? Int ?? Int()
           print("SocityID: \(strID)")
           print("name: \(strName)")
            
            self.txtItemParticular.text = ""
            self.txtMill.text = ""
            self.txtBundleKG.text = ""
            
            self.lblItemParticular.isHidden = false
            self.lbl_Discount15Percent.isHidden = true
            self.lblMill.isHidden = false
            self.lblKG.text = "KG"
            
            if strName == "Hank"{
                if AuthService.instance.hasICard == true{
                    self.lbl_Discount15Percent.isHidden = false
                }
                else{
                    self.lbl_Discount15Percent.isHidden = true
                }
                self.stackHightConstant.constant = 600.0
                self.priceHeightConstraint.constant = 120.0
                self.stack1.isHidden = false
                self.stack2.isHidden = false
            }
            else{
                self.lbl_Discount15Percent.isHidden = true
                self.stackHightConstant.constant = 540.0
                self.priceHeightConstraint.constant = 60.0
                self.stack1.isHidden = true
                self.stack2.isHidden = true
            }
           self.lblType.isHidden = true
           self.txtType.text = "\(strName)"
                             
       }) as? UIAlertAction ?? UIAlertAction()
                          
       self.alertForName.addAction(actioninArray)
       }
                                          
        self.alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
        
       print("User click Dismiss button")
       }))
                                                
                                            
        self.alertForName.popoverPresentationController?.sourceView = self.view
        self.alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        self.alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(self.alertForName, animated: true, completion: {
        print("completion block")
       self.hideActivityIndicator()
   })
}
    
    
    func showItemParticular(){
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        if (isConnected == true) {
            if txtCategory.text == "Silk"  {
                txtType.text = ""
            }
            AuthService.instance.ParticularListAPI(CatIDStr: self.selectedCatID,hubIdStr:self.selectedHubID,catType:self.selectedTypeID) { success, data, message in
                HUD.hide(to: self.view)

                if success{
                    do{
                        if AuthService.instance.dataParticularList.count > 0 {
                        self.alertForName = UIAlertController(title: "Select item particular", message: nil, preferredStyle: .actionSheet)
                            
                       for i in 0..<AuthService.instance.dataParticularList.count {
                           let dictName : NSDictionary = AuthService.instance.dataParticularList.object(at: i) as? NSDictionary ?? NSDictionary()
                           let strName : String = dictName.value(forKey: "name") as? String ?? ""
                           let strID = dictName["id"] as? Int ?? Int()
                           
                           let strBundle_size : String = dictName.value(forKey: "bundle_size") as? String ?? ""
                           //let strMax_order_quantity = dictName["max_order_quantity"] as? Int ?? Int()

                           let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{  (UIAlertAction)in
                                                                     
                               self.selectedYarnID  = strID
                               print("selectedCatID: \(strID)")
                               print("Cat_name: \(strName)")
                               self.lblItemParticular.isHidden = true
                               self.txtItemParticular.text = "\(strName)"
                               
                               self.txtMill.text = ""
                               self.txtBundleKG.text = ""
                               
                               self.lblMill.isHidden = false
                               self.lblKG.text = "KG"
                               
                               self.bundle_size  = strBundle_size
                               self.bundle_size_Cotton  = Double(strBundle_size)!

                              // self.max_order_quantity  = strMax_order_quantity
                               print("bundle_size: \(self.bundle_size)")
                               print("bundle_size_C: \(self.bundle_size_Cotton)")

                           }) as? UIAlertAction ?? UIAlertAction()
                           self.alertForName.addAction(actioninArray)
                           }
                            self.alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
                              //  self.lblHub.isHidden = false
                           print("User click Dismiss button")
                           }))
                            self.alertForName.popoverPresentationController?.sourceView = self.view
                            self.alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                            self.alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            self.present(self.alertForName, animated: true, completion: {
                            print("completion block")
                           self.hideActivityIndicator()
                       })
                    }
                   }
                  catch{
                    print(error)
                }
                }
                else{
                    HUD.hide(to: self.view)
                    self.showAlertWith(message: "Your session is expired. Please login again")
                }
            }
            
        }else{
            HUD.hide(to: self.view)
            popUpAlert(msg: "No internet connection!")
            
        }
    }
    
    
    func showSupplymill(){
        HUD.show(to: self.view)
        if self.txtItemParticular.text != ""{
        let isConnected = ReachabilityClass.isConnectedToNetwork()

        if (isConnected == true) {
            AuthService.instance.MillListAPI(catType: self.selectedTypeID, hubIdStr: self.selectedHubID, categoryIDStr: selectedCatID, yardIdStr: selectedYarnID) { success, data, message in
                if success{
                    HUD.hide(to: self.view)
                    do{
                        if AuthService.instance.dataMilkList.count > 0 {
                        self.alertForName = UIAlertController(title: "Select item particular", message: nil, preferredStyle: .actionSheet)
                       for i in 0..<AuthService.instance.dataMilkList.count {
                           let dictName : NSDictionary = AuthService.instance.dataMilkList.object(at: i) as? NSDictionary ?? NSDictionary()
                           let strName : String = dictName.value(forKey: "name") as? String ?? ""
                           let strID = dictName["id"] as? Int ?? Int()
                           
                           let strQuantity = dictName["quantity"] as? String ?? "0.0"
                           self.quantityPerKg = Double(strQuantity) ?? 0  //?? 0 //?? Int(0.0)
                           
                           let strSelling_cost = dictName["selling_cost"] as? String ?? "0.0"
                           self.sellingCostPerKg = Double(strSelling_cost) ?? 0 //?? 0 //?? 0 //?? Int(0.0)

                           let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{  (UIAlertAction)in
                                                                     
                               self.selectedMilkID  = strID
                               print("selectedMilkID: \(strID)")
                               print("Milk_name: \(strName)")
                               self.lblMill.isHidden = true
                               self.txtMill.text = "\(strName)"
                               self.lbl_SellingPrice.text = "₹\(strSelling_cost)"
                               print("quantity: \(strQuantity)")
                               print("selling_cost: \(strSelling_cost)")

                               self.txtBundleKG.text = ""
                               self.lblKG.text = "KG"
                           }) as? UIAlertAction ?? UIAlertAction()
                                              
                                              
                           self.alertForName.addAction(actioninArray)
                                              
                           }
                                                              
                                                                
                            self.alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
                              //  self.lblHub.isHidden = false
                           print("User click Dismiss button")
                                                                    
                           }))
                                                                    
                                                                
                            self.alertForName.popoverPresentationController?.sourceView = self.view
                            self.alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                            self.alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            self.present(self.alertForName, animated: true, completion: {
                            print("completion block")
                           self.hideActivityIndicator()
                       })
                    }
                   }
                  catch{
                    print(error)
                }
                }
                else{
                    HUD.hide(to: self.view)
                    self.showAlertWith(message: "Your session is expired. Please login again")

                }
                
            }
            
        }else{
            HUD.hide(to: self.view)
            popUpAlert(msg: "No internet connection!")
        }
    }
        else{
            self.showAlertWith(message: "Please select item particular")
        }
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
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    // MARK: UIAlertView methods
      
      func popUpAlert (msg : String) {
          
          let alert = UIAlertController(title: msg , message: "" , preferredStyle: .alert)
          
          present(alert, animated: true) {
              alert.view.superview?.isUserInteractionEnabled = true
              alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
          }
      }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
    }
    

    
    @IBAction func actionMenu(_ sender: Any) {
        
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        present(menuViewController, animated: true)
    }
      
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
       // topView?.removeFromSuperview()
        switch menuType {
        case .Home:
            print("Home")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceYourOrderVCViewController") as! PlaceYourOrderVCViewController
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .Profile:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
              self.navigationController?.pushViewController(vc, animated: false)
            
        case .PlaceNewOrder:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrderViewController") as! CreateOrderViewController
            //self.navigationController?.pushViewController(vc, animated: false)
            
        case .MyOrder:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .Notifications:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .ChangeLanguage:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .ChangePassword:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: false)
        case .Logout:
            let alert = UIAlertController(title: "Tantuj", message: "Are you sure to logout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
                        print("User click Approve button")
                       // AuthService.instance.isLoggedIn = false
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: false)

                    }))
            
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                        print("User click Dismiss button")
                    }))

                    self.present(alert, animated: true, completion: {
                        print("completion block")
                    })
        default:
            break
        }
    }
    
    
    @IBAction func actionPlaceOrder(_ sender: Any) {
        HUD.show(to: self.view)
        if txtBundleKG.text != ""{
            
            let isConnected = ReachabilityClass.isConnectedToNetwork()

            if (isConnected == true) {
            
                    
                AuthService.instance.AddToCartAPI(hubIdStr: selectedHubID, categoryIDStr: selectedCatID, selling_costStr: totalSellingCostPerKg, yardIdStr: selectedYarnID, mill_idStr: self.selectedMilkID, bundleStr: Int(bundleInt), weightStr: weightInt, max_quantityStr: Double(max_order_quantity)) { success, data, message in

                    
                    if success{
                        HUD.hide(to: self.view)

                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
                                self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        HUD.hide(to: self.view)

                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.showAlertWith(message: "Your session is expired. Please login again")
                    }
                }
                
            }else{
                HUD.hide(to: self.view)
                popUpAlert(msg: "No internet connection!")
            }
            
        }else{
            HUD.hide(to: self.view)
            self.showAlertWith(message: "Please enter bundle.")
        }
    }
}
