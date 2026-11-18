//
//  NotificationVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit
import MBProgressHUD

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbl_Count: UILabel!
    
    @IBOutlet weak var tblNotification: UITableView!
    
    var topView: UIView?
    let transiton = SlideInTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_Count.text = "\(String(describing: AuthService.instance.count))"

        print("cart count: \(lbl_Count.text)")
        DispatchQueue.main.async {
            self.notificationApiCall()
            self.tblNotification.reloadData()
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
    
    
    func notificationApiCall(){
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
                    if (isConnected == true) {
                        AuthService.instance.NotificationAPI(completion:{(success, data, message) in
                            if success{
                                HUD.hide(to: self.view)
                                if AuthService.instance.upcomingListing.count > 0{
                                    self.tblNotification.reloadData()
                                    
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
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
            //self.navigationController?.pushViewController(vc, animated: false)
            
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.selectionStyle = .none
        
      if AuthService.instance.upcomingListing.count > 0{
           
       cell.lbl_yarnName.text = "\(AuthService.instance.upcomingListing[indexPath.row]["message"].stringValue)"
       cell.lbl_Date.text  = "\(AuthService.instance.upcomingListing[indexPath.row]["created_at"].stringValue)"

        }
        return cell
    }
}
