//
//  LoginVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 31/08/22.
//

import UIKit
import MBProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnOtherLogin: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var viewButtomconstant: NSLayoutConstraint!
    @IBOutlet weak var viewPassword: CustomView!
    @IBOutlet weak var viewNumber: CustomView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblWelcomeBack: UILabel!
    @IBOutlet weak var lblExplore: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblRememberMe: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnRegister: UIButton!

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    var check: Bool = false

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPhoneNumber.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.txtPhoneNumber.text = "7980083573"//"7019518336"//"8918179687"//"9087654321"
        self.txtPassword.text = "123456"//"12345678"
        
        setupUI()
        languageSetup()
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    @objc func textFieldDidChange(){
        print("text changed:", txtPhoneNumber.text!)
        if txtPhoneNumber.text?.count == 10{
            self.checkMark.isHidden = false
        }
        else{
            self.checkMark.isHidden = true
        }
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if AuthService.instance.savedCheck == true{
            self.txtPhoneNumber.text = "\(AuthService.instance.savedUserName!)"
            self.txtPassword.text = "\(AuthService.instance.savedPassword!)"
            btnCheckBox.setImage(UIImage(named: "circletick"), for: UIControl.State.normal)
            check = true
        }else{
            self.txtPhoneNumber.text = ""
            self.txtPassword.text = ""
            btnCheckBox.setImage(UIImage(named: "b_uncheck"), for: UIControl.State.normal)
            check = false

        }

    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            viewTop.clipsToBounds = false
            viewTop.layer.cornerRadius = 30
            viewTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else {
            viewTop.clipsToBounds = false
            viewTop.layer.cornerRadius = 30
            viewTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        btnSignIn.layer.cornerRadius = 17
        btnSignIn.clipsToBounds = true
        
        btnOtherLogin.layer.cornerRadius = 17
        btnOtherLogin.clipsToBounds = true
        
    }
    func languageSetup(){
        
    lblWelcomeBack.text = defaultLocalizer.stringForKey(key: "Welcome Back")
    lblExplore.text     = defaultLocalizer.stringForKey(key: "Let’s login for explore continues")
    lblPhoneNumber.text = defaultLocalizer.stringForKey(key: "Phone Number")
    lblPassword.text    = defaultLocalizer.stringForKey(key: "Password")
    lblRememberMe.text    = defaultLocalizer.stringForKey(key: "Remember Me")
    btnForgotPassword.setTitle(defaultLocalizer.stringForKey(key: "Forgot Password"), for: .normal)

    btnSignIn.setTitle(defaultLocalizer.stringForKey(key: "Sign In"), for: .normal)
    lblAccount.text    = defaultLocalizer.stringForKey(key: "Don’t have an account?")
    btnRegister.setTitle(defaultLocalizer.stringForKey(key: "Register Now"), for: .normal)

    btnOtherLogin.setTitle(defaultLocalizer.stringForKey(key: "Login to other account"), for: .normal)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)

        self.viewButtomconstant.constant = 0.0
        
    }
    
    @IBAction func actionEye(_ sender: Any) {
        
        
    }
    
    
    @IBAction func actionCheckBox(_ sender: Any) {
        
        if (check == false) {
            btnCheckBox.setImage(UIImage(named: "circletick"), for: UIControl.State.normal)
            check = true
            AuthService.instance.savedCheck = true
        } else {
            btnCheckBox.setImage(UIImage(named: "b_uncheck"), for: UIControl.State.normal)
            check = false
            AuthService.instance.savedCheck = false
        }
        
    }
    
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    @IBAction func actionRegister(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc,animated: true)
        
    }
    
    @IBAction func actionOtherLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OtherLoginVC") as! OtherLoginVC
        self.navigationController?.pushViewController(vc,animated: true)
        
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        HUD.show(to: self.view)
            let isConnected = ReachabilityClass.isConnectedToNetwork()
            
            let passWd = txtPassword.text
            let phone  = txtPhoneNumber.text
            if (passWd?.isEmpty == true) {
                popUpAlert(msg: "Please enter password")
            }
            else if (phone?.isEmpty == true) {
               popUpAlert(msg: "Please enter phone number")
            }
            else{
                    if (isConnected == true) {
                    AuthService.instance.LoginAPI(phNoStr: phone!, passwordStr: passWd!, completion:{(success, data, message) in
                        if success{
                        HUD.hide(to: self.view)
                        let alert = UIAlertController(title: "Tantuj" , message: message , preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        // self.okBtnTapped()
                            if AuthService.instance.savedCheck == true{
                                AuthService.instance.savedUserName = "\(phone!)"
                                AuthService.instance.savedPassword = "\(passWd!)"
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PlaceYourOrderVCViewController") as! PlaceYourOrderVCViewController
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
    

    
    func okBtnTapped() {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func showAlertWith(message: String){
        let ac = UIAlertController(title: "Tantuj", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
            
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        if textField.tag == 1 {
            
            viewNumber.layer.borderWidth = 1
            viewNumber.layer.borderColor = UIColor(red: 0.08, green: 0.42, blue: 0.97, alpha: 1.00).cgColor
            viewPassword.layer.borderWidth = 0.0
            viewPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewButtomconstant.constant = 170.0

        }else{
            
            viewPassword.layer.borderWidth = 1
            viewPassword.layer.borderColor = UIColor(red: 0.08, green: 0.42, blue: 0.97, alpha: 1.00).cgColor
            viewNumber.layer.borderWidth = 0.0
            viewNumber.layer.borderColor = UIColor.clear.cgColor
            self.viewButtomconstant.constant = 200.0

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
