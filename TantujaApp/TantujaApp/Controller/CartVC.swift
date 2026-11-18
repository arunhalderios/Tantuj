//
//  CartVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit
import SwiftyJSON
import UniformTypeIdentifiers
import MBProgressHUD
class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let defaults = UserDefaults.standard

    @IBOutlet weak var tbleVw_Cart: UITableView!
    var intSelectedIndex = -1
    var arrCartListing = [JSON]()
    var attdList : JSON = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getCartApiCall()
        }
       // print(cartListing)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        DispatchQueue.main.async {
            self.getCartApiCall()
        }

    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let nav = self.navigationController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    func getCartApiCall(){
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
                    if (isConnected == true) {
                        
                        AuthService.instance.Get_CartAPI(completion:{(success, data, message) in
                            if success{self
                                HUD.hide(to: self.view)
                                    UserDefaults.standard.set(AuthService.instance.cartListing.count, forKey: "cartListing_Count")
                                    self.tbleVw_Cart.reloadData()
                               // }
                            }
                            else{
                                HUD.hide(to: self.view)
                                self.showAlertWith(message: message!)
                            }
                    })
                
            }
            else {
                HUD.hide(to: self.view)
            showAlertWith(message: "No internet connection!")
                    
            }
    }
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else{
            return 350
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var totolCount = 0
        if section == 0 {
            if AuthService.instance.cartListing.count > 0{
                totolCount = AuthService.instance.cartListing.count
            }
            return totolCount
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartQTYCell") as! CartQTYCell
            cell.selectionStyle = .none
            if AuthService.instance.cartListing.count > 0{
                cell.lbl_MillName.text = "\(AuthService.instance.cartListing[indexPath.row]["mills_name"].stringValue)"
                cell.lbl_maxQuantity.text = "\(AuthService.instance.cartListing[indexPath.row]["max_quantity"].stringValue)"
                cell.lbl_HubsName.text = "\(AuthService.instance.cartListing[indexPath.row]["hubs_name"].stringValue)"
                cell.lbl_Amount.text = "\(AuthService.instance.cartListing[indexPath.row]["amount"].stringValue)"
                cell.btnRemove.addTarget(self, action: #selector(removeButtonClicked), for: .touchUpInside)
               // cell.btnOption.addTarget(self, action: #selector(optionButtonClicked), for: .touchUpInside)
                cell.btnRemove.tag = indexPath.row
//                if indexPath.row == intSelectedIndex{
//                    cell.btnRemove.isHidden = false
//                }else{
//                    cell.btnRemove.isHidden = true
//                }
                
                cell.btnRemove.isHidden = true
                cell.delegate = self

            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalAmountCell") as! TotalAmountCell
            cell.selectionStyle = .none
            let subtotal = AuthService.instance.subtotal
            let gst = AuthService.instance.gst
            let cgst =  AuthService.instance.cgst
            let sgst =  AuthService.instance.sgst
            let total = AuthService.instance.total

            
            cell.lbl_Subtotal.text = String(format: "%.2f", subtotal)
            cell.lbl_GST.text = String(format: "%.2f", gst)
            cell.lbl_CGST.text = String(format: "%.2f", cgst)
            cell.lbl_SGST.text = String(format: "%.2f", sgst)
            cell.lbl_GrantTotal.text = String(format: "%.2f", total)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        intSelectedIndex = -1
        tbleVw_Cart.reloadData()
    }
    @objc func optionButtonClicked(sender : UIButton!) {
        intSelectedIndex = sender.tag
      //  tbleVw_Cart.reloadData()
    }
    @objc func removeButtonClicked(sender : UIButton!) {
//        intSelectedIndex = -1
//        tbleVw_Cart.reloadData()
        DispatchQueue.main.async {
            let cartID = "\(AuthService.instance.cartListing[sender.tag]["id"].stringValue)"
            self.cartRemoveAPICall(cartID)
            self.tbleVw_Cart.reloadData()

        }
    }
    
    //MARK: --------------->>>>>>>>>> JSONTOSTRINGFY

    func jsonToStrinfy(from object:Any) -> String? {

        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {

            return nil

        }

        

        let result  = String(data: data, encoding: String.Encoding.utf8)

        let descResult = ("\(String(describing: result))")

       // print(descResult)

        var original = descResult

        let wordToRemove = "Optional("

        if let range = original.range(of: wordToRemove) {

            original.removeSubrange(range)

        }

       // print(original)

        let finalString = String(original.dropLast())

      //  print(finalString)

        //return String(data: data, encoding: String.Encoding.utf8)

        return finalString

  }

    @IBAction func actionCheckout(_ sender: UIButton) {
        var finalDict = [String: Any]()
            var i = 0
            var rowArr = [[String:String]]()
            while i<AuthService.instance.cartListing.count{
                var rowDict = [String:String]()
                rowDict["hub_id"] = AuthService.instance.cartListing[i]["hub_id"].stringValue
                rowDict["yarn_id"] = AuthService.instance.cartListing[i]["yarn_id"].stringValue
                rowDict["mill_id"] = AuthService.instance.cartListing[i]["mill_id"].stringValue
                rowDict["max_quantity"] = AuthService.instance.cartListing[i]["max_quantity"].stringValue
                rowDict["quantity"] = AuthService.instance.cartListing[i]["weight"].stringValue
                rowArr.append(rowDict)
                i += 1
        }
    
        
        guard let result = jsonToStrinfy(from: rowArr) else{
        return
            
        }
        print(result)
        let newData1 = result.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
        let newData2 = newData1.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range:nil)
       
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        
                    if (isConnected == true) {

                        AuthService.instance.Procced_CheckoutAPI(cartData: rowArr, completion:{(success, data, message) in
                            if success{
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                            else{

                                self.showAlertWith(message: message!)
                            }
                    })

            }
            else {

            showAlertWith(message: "No internet connection!")

            }
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        
    }
    func jsonToString(json: AnyObject){
        do {
            
            
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    func cartRemoveAPICall(_ strCartID:String){
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        if (isConnected == true) {
            AuthService.instance.CartRemoveAPI(strCartID: strCartID, completion:{(success, data, message) in
                if success{
                    self.showAlertWith(message: message!)
                    self.getCartApiCall()
                    
                }
                else{
                    
                    self.showAlertWith(message: message!)
                }
        })
    
}
else {
        
    popUpAlert(msg: "No internet connection!")
        
}
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
}
extension CartVC: ItemTableViewCellDelegate {
func cellCheckButtonDidTapped(cell: CartQTYCell) {

    UIView.transition(with: cell.btnRemove, duration: 0.1, options: .transitionCrossDissolve, animations: {
        cell.btnRemove.isHidden = !cell.btnRemove.isHidden
    }, completion: nil)


}
}
