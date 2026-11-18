//
//  PlaceYourOrderVCViewController.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 02/09/22.
//

import UIKit
import MBProgressHUD

class PlaceYourOrderVCViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var lblNotify_Count: UILabel!
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_PhoneNumber: UILabel!
    @IBOutlet weak var imgVw_Profile: UIImageView!
    var topView: UIView?
    let transiton = SlideInTransition()
    
    
    @IBOutlet weak var lblPlaceOrder: UILabel!
    @IBOutlet weak var lblPendingOrder: UILabel!
    @IBOutlet weak var lblFullfillOrder: UILabel!

    @IBOutlet weak var lblKGCotton: UILabel!
    @IBOutlet weak var lblOrderlimitCotton: UILabel!
    
    @IBOutlet weak var lblKGSilk: UILabel!
    @IBOutlet weak var lblOrderlimitSilk: UILabel!
    
    
    @IBOutlet weak var btnCartCount: UIButton!
    
    
    @IBOutlet weak var lblPlaceOrdertitle: UILabel!
    @IBOutlet weak var lblPendingOrdertitle: UILabel!
    @IBOutlet weak var lblFullfillOrdertitle: UILabel!
    
    @IBOutlet weak var lblOrderTitle: UILabel!
    @IBOutlet weak var lblKgTitle: UILabel!
    @IBOutlet weak var btnTitlePlaceNewOrder: UIButton!
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.profileCall()
        }
        // Do any additional setup after loading the view.
        lbl_Count.text = "\(String(describing: AuthService.instance.count))"
        
        languageSetup()
        
        let strValue : String = UserDefaults.standard.string(forKey: "status_value") ?? ""

        print("strValue: \(strValue)")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func languageSetup(){
        
        
        lblPlaceOrdertitle.text    = defaultLocalizer.stringForKey(key: "Placed Order")
        lblPendingOrdertitle.text  = defaultLocalizer.stringForKey(key: "Pending Orders")
        lblFullfillOrdertitle.text = defaultLocalizer.stringForKey(key: "Full fill Orders")
        
        
        lblOrderTitle.text    = defaultLocalizer.stringForKey(key: "Order quantity limit remaining for the month")
        lblKgTitle.text       = defaultLocalizer.stringForKey(key: "Order quantity limit remaining for the month")
        btnTitlePlaceNewOrder.setTitle(defaultLocalizer.stringForKey(key: "Place New Order"), for: .normal)

    }
    



    
    func profileCall(){
        HUD.show(to: self.view)
        AuthService.instance.MyProfileAPI(completion:{ [self](success, data, message) in
            if success{
                HUD.hide(to: self.view)
                
                if AuthService.instance.isLoggedExpire == true {
                    let alert = UIAlertController(title: "Tantuj", message: message!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                print("User click Approve button")
                               // AuthService.instance.isLoggedIn = false
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            self.navigationController?.pushViewController(vc, animated: false)

                            }))
                            self.present(alert, animated: true, completion: {
                                print("completion block")
                            })
                    
                }else{
                    self.lbl_Name.text = AuthService.instance.name!
                    self.lbl_Email.text = AuthService.instance.email!
                    self.lbl_PhoneNumber.text = AuthService.instance.phoneNumber!
                    
                    
                    self.defaults.set(self.lbl_Name.text, forKey: "name")
                    self.defaults.set(self.lbl_Email.text, forKey: "email")
                    self.defaults.set(self.lbl_PhoneNumber.text, forKey: "phone")

                    
                    self.lblPlaceOrder.text = AuthService.instance.placed_order!
                    self.lblPendingOrder.text = AuthService.instance.pendingOrder!
                    self.lblFullfillOrder.text = AuthService.instance.success_order!

                    self.lblKGCotton.text = AuthService.instance.cotton_limit!
                   // self.lblOrderlimitCotton.text = AuthService.instance.pendingOrder!

                 //   self.lblKGSilk.text = AuthService.instance.success_order!
                    self.lblKGSilk.text = AuthService.instance.silk_limit!
                    
                    print("txt_Count32: \(AuthService.instance.count ?? 0)")
                    
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
                    
                  

                    print("notification_count: \(AuthService.instance.notification_count ?? 0)")

                    let strCount = AuthService.instance.count ?? 0
                    let xNSNumber = strCount as NSNumber
                    lbl_Count.text = xNSNumber.stringValue
                    
                    
                    let strNotiCount = AuthService.instance.notification_count ?? 0
                    let noti = strNotiCount as NSNumber
                    lblNotify_Count.text = noti.stringValue
                    
                    let strValue : String = UserDefaults.standard.string(forKey: "profile_image") ?? ""

                    if strValue == "" {
                        
                        imgVw_Profile.image = UIImage(named: "SomeEmptyImage-1")

                    }else{
                        
                        let url = URL(string: strValue)
                            let data = try? Data(contentsOf: url!)
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                imgVw_Profile.image = image
                            }else {
                                imgVw_Profile.image = UIImage(named: "SomeEmptyImage")
                        }
                    }
                }

                
                
            }
            else{
                HUD.hide(to: self.view)
                self.showAlertWith(message: "Something is error")

            }
    })
    
}
    @IBAction func btnNotificationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func btnCartAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    @IBAction func actionPlaceNewOrder(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateOrderViewController") as! CreateOrderViewController
        self.navigationController?.pushViewController(vc,animated: true)
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
    
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

extension PlaceYourOrderVCViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }

}
