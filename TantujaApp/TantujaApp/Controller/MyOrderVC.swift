//
//  MyOrderVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 17/09/22.
//

import UIKit
import MBProgressHUD
class MyOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblUpcoming: UILabel!
    @IBOutlet weak var lblPastOrder: UILabel!
    @IBOutlet weak var viewLineUpcoming: UIView!
    @IBOutlet weak var viewLinePastOrder: UIView!
    @IBOutlet weak var tblMyOrder: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblPastOrder.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        lblUpcoming.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLineUpcoming.backgroundColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLinePastOrder.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        tblMyOrder.isHidden = false
        tblMyOrder.reloadData()
        DispatchQueue.main.async {
            self.UpcomingApiCall()
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    func UpcomingApiCall(){
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
                    if (isConnected == true) {
                        AuthService.instance.upcoming_PastAPI(completion:{(success, data, message) in
                            if success{
                                HUD.hide(to: self.view)
                                if AuthService.instance.upcomingListing.count > 0{
                                    self.tblMyOrder.reloadData()
                                }
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
    
    
    func PastApiCall(){
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
                    if (isConnected == true) {
                        AuthService.instance.PastAPI(completion:{(success, data, message) in
                            if success{
                                HUD.hide(to: self.view)
                                if AuthService.instance.upcomingListing.count > 0{
                                self.tblMyOrder.reloadData()
                                }
                            }
                            else{
                                HUD.show(to: self.view)
                                self.showAlertWith(message: message!)
                            }
                    })
                
            }
            else {
            HUD.show(to: self.view)
            showAlertWith(message: "No internet connection!")
                    
            }
    }
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func btnPastOrderAction(_ sender: Any) {
        lblUpcoming.textColor =  UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        lblPastOrder.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLinePastOrder.backgroundColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLineUpcoming.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        DispatchQueue.main.async {
            self.PastApiCall()
        }
        tblMyOrder.isHidden = false
        
    }
    @IBAction func btnUpcomingOrderAction(_ sender: Any) {
        lblPastOrder.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        lblUpcoming.textColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLineUpcoming.backgroundColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00)
        viewLinePastOrder.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        tblMyOrder.isHidden = false
        DispatchQueue.main.async {
            self.UpcomingApiCall()
            self.tblMyOrder.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 304
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totolCount = 0
         if section == 0 {
             if AuthService.instance.upcomingListing.count > 0{
                 totolCount = AuthService.instance.upcomingListing.count
             }
             return totolCount
         }else{
             return 1
         }
         
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell") as! MyOrderCell
      //  cell.selectionStyle = .none
       // let cell = tableView.dequeueReusableCell(withIdentifier: "CartQTYCell") as! CartQTYCell
      //  cell.selectionStyle = .none
     if AuthService.instance.upcomingListing.count > 0{
        cell.lbl_yarnName.text  = "\(AuthService.instance.upcomingListing[indexPath.row]["yarns_name"].stringValue)"
        cell.lbl_millName.text  = "\(AuthService.instance.upcomingListing[indexPath.row]["mills_name"].stringValue)"
        cell.lbl_Qty.text       = "\(AuthService.instance.upcomingListing[indexPath.row]["qty"].stringValue)"
        cell.lbl_Pickup.text    = "\(AuthService.instance.upcomingListing[indexPath.row]["hubs_name"].stringValue)"
        cell.lbl_OrderDate.text = "\(AuthService.instance.upcomingListing[indexPath.row]["created_at"].stringValue)"
        cell.lbl_OrderId.text   = "\(AuthService.instance.upcomingListing[indexPath.row]["order_no"].stringValue)"
        cell.lbl_Code.text      = "\(AuthService.instance.upcomingListing[indexPath.row]["code"].stringValue)"
        cell.lbl_Amount.text    = "\(AuthService.instance.upcomingListing[indexPath.row]["total"].stringValue)"
         
    cell.lbl_Name.text        = "\(AuthService.instance.upcomingListing[indexPath.row]["name"].stringValue)"
    cell.lbl_SocityName.text  = "\(AuthService.instance.upcomingListing[indexPath.row]["society_name"].stringValue)"
         
         cell.invoiceBtnPressed = {
             let invoiceUrl = "\(AuthService.instance.upcomingListing[indexPath.row]["invoice"].stringValue)"
             print(invoiceUrl)
//             let fileName = "MyFile"
//             self.savePdf(urlString: invoiceUrl, fileName: fileName)
            
             
             if invoiceUrl != ""{
                 let url = URL(string: "\(invoiceUrl)")
                 if #available(iOS 10.0, *) {
                     UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                 } else {
                     UIApplication.shared.openURL(url!)
                 }
             }
             else{
                 self.showAlertWith(message: "PDF is not found.")
             }

             
         }


     }else{
         
         showAlertWith(message: "No order!")

     }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func savePdf(urlString:String, fileName:String) {
                DispatchQueue.main.async {
                    let url = URL(string: urlString)
                    let pdfData = try? Data.init(contentsOf: url!)
                    let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                    let pdfNameFromUrl = "Tantuj-\(fileName).pdf"
                    let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                    do {
                        try pdfData?.write(to: actualPath, options: .atomic)
                        print("pdf successfully saved!")
        //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
                    } catch {
                        print("Pdf could not be saved")
                    }
                }
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
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .MyOrder:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            //self.navigationController?.pushViewController(vc, animated: false)
            
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
    
    @IBAction func btnNotificationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func btnCartAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    
}

