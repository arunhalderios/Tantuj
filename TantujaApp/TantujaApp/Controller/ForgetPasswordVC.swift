//
//  ForgetPasswordVC.swift
//  TantujaApp
//
//  Created by Arun Halder on 08/09/22.
//

import UIKit
import MBProgressHUD

class ForgetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPhoneNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    

    @IBAction func actionForgetAPI(_ sender: Any) {
        HUD.show(to: self.view)
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        
        let phone  = txtPhoneNumber.text
        
        if (phone?.isEmpty == true) {
                
           popUpAlert(msg: "Please enter phone number")
                
        }
        else{
                if (isConnected == true) {
                        
                AuthService.instance.ForgotPasswordAPI(phNoStr: phone!, completion:{(success, data, message) in
                    if success{
                        HUD.hide(to: self.view)
                    let strPh = AuthService.instance.phoneNo!
                    let strOtp = AuthService.instance.otp!

                        
                    let alert = UIAlertController(title: "Tantuj" , message: message , preferredStyle: .alert)
                                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                       // self.okBtnTapped()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    let vc = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                        
                        vc.phoneNumber = strPh
                        vc.otp = strOtp
                        

                    self.navigationController?.pushViewController(vc,animated: true)

                    })
                                    
                    alert.addAction(okAction)
                                    
                    self.present(alert, animated: true, completion: nil)
                                
                    }
                    else{
                        HUD.hide(to: self.view)
                        self.showAlertWith(message: message!)
                        }
                    })
                
            }
            else {
                HUD.hide(to: self.view)
            popUpAlert(msg: "No internet connection!")
                    
            }
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

    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func actionSigin(_ sender: Any) {
        

    }
    

}
