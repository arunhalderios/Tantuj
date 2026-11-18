//
//  OTPVerificationVC.swift
//  Sample
//
//  Created by Arun Halder on 01/09/22.
//

import UIKit
import MBProgressHUD

class OTPVerificationVC: UIViewController {

    var count = 60
    var phoneNumber = ""
    var otp = ""

    let defaults = UserDefaults.standard

    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let strString = "We’ve sent a 4 digit code to your phone "
        let strFinalString = strString + phoneNumber
        lblPhone.text = strFinalString
        
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @objc func updateCounter() {
        if(count > 0) {
            
            count  -= 1
            
            lblTimer.text = "Code expires in : 00:\(count)"
              //String(count--)
          //  print("\(count) seconds to the end of the world")
                   
        }
    }
    
    
    
    @IBAction func btnBackbutton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func actionVerifyOTP(_ sender: Any) {
    print("pho: \(phoneNumber)")
        HUD.show(to: self.view)

        AuthService.instance.otpAPI(mobileNumber: phoneNumber, completion:{(success, data, message) in
            if success{
                HUD.hide(to: self.view)

                let alert = UIAlertController(title: "Tantuj" , message: message , preferredStyle: .alert)
                  
                  let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                     // self.okBtnTapped()
                      let storyboard = UIStoryboard(name: "Main", bundle: nil)

                      let vc = storyboard.instantiateViewController(withIdentifier: "CreatePasswordVC") as! CreatePasswordVC

                      self.navigationController?.pushViewController(vc,animated: true)
                      
                      
                  })
                  
                  alert.addAction(okAction)
                  
              self.present(alert, animated: true, completion: nil)
                
                
                
            }
            else{
                HUD.hide(to: self.view)
                self.showAlertWith(title: "Tantuj", message: message!)
            }
    })

    }
            
                
    
    @IBAction func actionResendOTP(_ sender: Any) {
        HUD.show(to: self.view)
        let strPhone =  UserDefaults.standard.string(forKey: "phone") ?? ""

        phoneNumber = strPhone
        
        AuthService.instance.ResendOtpAPI(phNoStr: phoneNumber, completion:{(success, data, message) in
            if success{
                HUD.hide(to: self.view)
                self.showAlertWith(title: "Tantuj", message: message!)
            }
            else{

            }
    })

    }

    
    
    // MARK: UIAlertView methods
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
      
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
