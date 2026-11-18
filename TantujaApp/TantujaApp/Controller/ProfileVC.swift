//
//  ProfileVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 17/09/22.
//

import UIKit
import MBProgressHUD

class ProfileVC: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var lblCart_count: UILabel!
    
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var btnCart_count: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgCardID: UIImageView!
    @IBOutlet weak var imgAdhar: UIImageView!
    @IBOutlet weak var txtSociety: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var topView: UIView?
    let transiton = SlideInTransition()

    
    // ********** Array ********** //
    var nameArray:NSArray = NSArray()

    // ********** Variable ********** //

    var alertForName :UIAlertController = UIAlertController()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    private var image: UIImage?
    var defaults = UserDefaults.standard
    var isImageUpdated: Bool    = false
    var check         : Bool    = false
    var selectedSocityID: String = ""
    
    var icardDataaa = Data()
    var adhaarDataaa = Data()
    var profileDataaa = Data()
    var imageAdhaarBool = true
    var imageProfileBool = true
    var imageIdcarrdBool = true

    let userDefaults = UserDefaults.standard

    var base64String : String = String()
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSociety.delegate = self
        DispatchQueue.main.async {
            self.societyApiCall()
            self.getProfileCall()
            self.configureGesture()
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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    // MARK: textField customize methods
       
       func configureGesture(){
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
           view.addGestureRecognizer(tapGesture)
       }
       
       @objc func handleTap(){
           
        view.endEditing(true)
           
       }
    

    
    func getProfileCall(){
        HUD.show(to: self.view)
        AuthService.instance.MyProfileAPI(completion:{ [self](success, data, message) in
            if success{
                HUD.hide(to: self.view)
                self.txtName.text = AuthService.instance.name!
                self.txtEmail.text = AuthService.instance.email!
                self.txtPhone.text = AuthService.instance.phoneNumber!
                let Socity_Name = userDefaults.object(forKey: "socity_Name")

                self.txtSociety.text = Socity_Name as? String ?? ""

                print("txt_Count: \(AuthService.instance.count ?? 0)")
                print("notification_count: \(AuthService.instance.notification_count ?? 0)")

                let strCount = AuthService.instance.count ?? 0
                let xNSNumber = strCount as NSNumber
                
                print("Cart Count: \(xNSNumber)")

                let cart_count = xNSNumber.stringValue

                lblCart_count.text = cart_count


                let strNotiCount = AuthService.instance.notification_count ?? 0
                let noti = strNotiCount as NSNumber
                print("Noti Count: \(noti)")

                let strNotification = noti.stringValue
                
                lblNotification.text = strNotification
                
                let strValueProfile : String = UserDefaults.standard.string(forKey: "profile_image") ?? ""
                
                if strValueProfile == "" {
                    
                    imgUserProfile.image = UIImage(named: "SomeEmptyImage-1")

                }else{
                    
                    print("card: \(strValueProfile)")
                    let urll = URL(string: strValueProfile)
                        let dataa = try? Data(contentsOf: urll!)
                    AuthService.instance.profileData = dataa
                        if let imageDataa = dataa {
                            let imagee = UIImage(data: imageDataa)
                            imgUserProfile.image = imagee
                        }else {
                            imgUserProfile.image = UIImage(named: "SomeEmptyImage-1")
                        }
                }
                
                let strValueAadhaar : String = UserDefaults.standard.string(forKey: "aadhaar_image") ?? ""

                if strValueAadhaar == "" {
                    
                    imgAdhar.image = UIImage(named: "SomeEmptyImage-1")

                }else{

                    let url = URL(string: strValueAadhaar)
                        let dataa = try? Data(contentsOf: url!)
                       AuthService.instance.aadharData = dataa

                        if let imageData = dataa {
                            let image = UIImage(data: imageData)
                            imgAdhar.image = image
                        }else {
                            imgAdhar.image = UIImage(named: "SomeEmptyImage-1")
                        }
                }
                
                let strValueICard : String = UserDefaults.standard.string(forKey: "ICard_image") ?? ""

                
                if strValueICard == "" {
                    
                    imgCardID.image = UIImage(named: "SomeEmptyImage-1")

                }else{
                    
                    let url2 = URL(string: strValueICard)
                    
                        let dataa = try? Data(contentsOf: url2!)
                    AuthService.instance.iCardData = dataa

                        if let imageData2 = dataa {
                            let image2 = UIImage(data: imageData2)
                            imgCardID.image = image2
                        }else {
                            imgCardID.image = UIImage(named: "SomeEmptyImage-1")
                        }
                    
                       
                }

            }
            else{
                HUD.hide(to: self.view)
                self.showAlertWith(title: "Tantuj", message: "Something is error")

            }
    })
    
}
    
    
    @IBAction func btnProfileAction(_ sender: Any) {
        
        self.imageProfileBool = true

        self.imageAdhaarBool  = false
        self.imageIdcarrdBool = false

        let actionSheet = UIAlertController.init(title: "Please choose a source type", message: nil, preferredStyle: .actionSheet)
        
    actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (action) in
            self.openCamera()
        }))
        
    actionSheet.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertAction.Style.default, handler: { (action) in
            self.showPhotoLibrary()
        }))
        
    actionSheet.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnIDCardAction(_ sender: Any) {
        self.imageAdhaarBool  = false
        self.imageProfileBool = false

           let actionSheet = UIAlertController.init(title: "Please choose a source type", message: nil, preferredStyle: .actionSheet)
           
       actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (action) in
               self.openCamera()
           }))
           
       actionSheet.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertAction.Style.default, handler: { (action) in
               self.showPhotoLibrary()
           }))
           
       actionSheet.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (action) in
               // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
               //Plus whatever method you define here, gets called,
               //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
           }))
           
           //Present the controller
           self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnAdharAction(_ sender: Any) {
        
        self.imageAdhaarBool = true

        
        let actionSheet = UIAlertController.init(title: "Please choose a source type", message: nil, preferredStyle: .actionSheet)
        
    actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (action) in
            self.openCamera()
        }))
        
    actionSheet.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertAction.Style.default, handler: { (action) in
            self.showPhotoLibrary()
        }))
        
    actionSheet.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    // MARK:- Open Camera methods

    func openCamera(){
           
           //isProfileApiGetCalled = false
           
          let imagePicker = UIImagePickerController()
           imagePicker.sourceType = .camera
           imagePicker.allowsEditing = false
           imagePicker.delegate = self
           self.present(imagePicker, animated: true, completion: nil)
       }
       
    // MARK:- Photo Library methods

       func showPhotoLibrary(){
           
                   
                   let imagePicker = UIImagePickerController()
                   imagePicker.sourceType = .photoLibrary
                   imagePicker.allowsEditing = false
                   imagePicker.delegate = self
                   self.present(imagePicker, animated: true, completion: nil)
        
        
       }
    
    
    //MARK: - Add image to Library
      @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
          if let error = error {
              // we got back an error!
              showAlertWith(title: "Save error", message: error.localizedDescription)
          } else {
              showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
          }
      }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    //MARK: - Saving Image here

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        if imageAdhaarBool == true{
            self.adhaarDataaa = image.jpegData(compressionQuality: 0.2)!
            AuthService.instance.aadharData = self.adhaarDataaa
            print(adhaarDataaa)
            self.imgAdhar.image = image
        }
        else if imageProfileBool == true{
            self.profileDataaa = image.jpegData(compressionQuality: 0.2)!
            AuthService.instance.profileData = self.profileDataaa
            print(profileDataaa)
            self.imgUserProfile.image = image
        }
        else{
            self.icardDataaa = image.jpegData(compressionQuality: 0.2)!
            AuthService.instance.iCardData = self.icardDataaa
            print(icardDataaa)
            self.imgCardID.image = image
        }
        
        
        self.image = image
                    
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        
        let email  = txtEmail.text
        let phone = txtPhone.text
       // let phone  = txtPhoneNumber.text
        let name   = txtName.text
        var sName  = txtSociety.text

            
        if (isValidEmail(testStr: email!) == false) {
            
            popUpAlert(msg: "Invalid email address")
            
        }
        else if (phone?.isEmpty == true) {
            
            popUpAlert(msg: "Please enter password")
            
        }
        else if (name?.isEmpty == true) {
                    
         popUpAlert(msg: "Please enter your name")
                    
       }else if (sName?.isEmpty == true) {
                          
          popUpAlert(msg: "Please select society name")
                          
       }
        else{
            
                if (isValidTextfield() == true) {
                    if (isConnected == true) {
                        
                        sName = self.selectedSocityID
                        AuthService.instance.profileUpdate(nameStr: name!, phoneNumberStr: phone!, emailStr: email!, profilePicData: AuthService.instance.profileData!, societyIdStr: sName!, adharImgData: AuthService.instance.aadharData!, icardImgData: AuthService.instance.iCardData!, completion:{(success, data, message) in
                            if success{
                                self.showAlertWith(title: "Tantuj", message: message!)
                            }
                            else{
                                self.showAlertWith(title: "Tantuj", message: message!)

                            }
                    })
                    
                }
                else {
                        
                        popUpAlert(msg: "No internet connection!")
                        
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       
        if (txtSociety.isFirstResponder == true) {
                   
        // countryTxt.placeholder = nil
            
            
            self.view.endEditing(true)
            self.showSocityListing()
           
        }
        
    }
    // MARK:- Textfield validation methods
    
    func isValidTextfield() -> Bool {
        
        let name   = txtName.text
        let email  = txtEmail.text
        let phone = txtPhone.text
       // let phone   = txtPhoneNumber.text
        let socity   = txtSociety.text

//        defaults.set(phone, forKey: "phone")
//
//         if (txtName.text?.isEmpty == true) {
//
//            popUpAlert(msg: "Please enter your name")
//
//            return false
//
//        }
        if (isNumber(text: txtName.text!) == true) {
            
            popUpAlert(msg: "Please enter a valid name")
            
            return false
            
        }
        else if (phone?.isEmpty == true) {
                 
                 popUpAlert(msg: "Please enter password")
                 return false
         }
        else if (isValidEmail(testStr: email!) == false) {
            
            popUpAlert(msg: "Invalid email address")
            
            return false
            
        }
       
        
       else if (txtSociety.text?.isEmpty == true) {
           
           popUpAlert(msg: "Please select your socity name")
           
           return false
           
       }
        else {
            
            return true
            
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
          
          let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
          
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: testStr)
      }
    
    func isNumber(text : String)-> Bool {
        
        let str = text
        
        let decimalCharacters = CharacterSet.decimalDigits
        
        let decimalRange = str.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange == nil {
            
            return false // Numbers not found
            
        }
        else {
            
            return true // Number found
        }
    }
    
    func isContainSpace(text : String)-> Bool {
        
        let whitespace = NSCharacterSet.whitespaces
        
        let phrase = text
        let range = phrase.rangeOfCharacter(from: whitespace)
        
        // range will be nil if no whitespace is found
        if range == nil {
            
            return false // whitespace not found
            
        }
        else {
            
            return true  // whitespace found
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
    //Mark :- Alert For Socity
    
    func showSocityListing(){
        
        self.view.endEditing(true)
             do{
                               
                //showActivityIndicator()
                if self.nameArray.count > 1 {
                                          
                alertForName = UIAlertController(title: "Select Socity", message: nil, preferredStyle: .actionSheet)
                                   
               
                for i in 0..<self.nameArray.count {
                              
                let dictName : NSDictionary = self.nameArray.object(at: i) as? NSDictionary ?? NSDictionary()
                let strName : String = dictName.value(forKey: "name") as? String ?? ""
                let strID : String = dictName.value(forKey: "id") as? String ?? ""

                                       
              let actioninArray : UIAlertAction = UIAlertAction(title: strName, style: .default , handler:{  (UIAlertAction)in
                                                              
                  self.selectedSocityID  = strID
                  print("SocityID: \(strID)")
                  print("name: \(strName)")
               
                  self.txtSociety.text = "\(strName)"
                    
                                          
                    }) as? UIAlertAction ?? UIAlertAction()
                                       
                                       
                    alertForName.addAction(actioninArray)
                                       
                    }
                                                       
                                                         
                    alertForName.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{   (UIAlertAction)in
                                                                 
                    print("User click Dismiss button")
                                                             
                    }))
                                                             
                                                         
                    alertForName.popoverPresentationController?.sourceView = self.view

                    alertForName.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                                                         
                    alertForName.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                                             
                                                        
               self.present(alertForName, animated: true, completion: {
                                                          
                     print("completion block")
                            
                    self.hideActivityIndicator()
                   
                })
                                          
                                      
             }

            }
           catch{
                               
             print(error)
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
    func societyApiCall(){
        //HUD.show(to: self.view)

        let url = URL(string: "https://developer.shyamfuture.in/sms/api/society_list")
         
         URLSession.shared.dataTask(with: url!) {(data, response, error ) in
             
             
             if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
             
                 //let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                 print("jsonObject: \(jsonObj)")
                 HUD.hide(to: self.view)

                    let dicData = jsonObj.value(forKey: "data") as? NSArray
                    print("dicData: \(dicData)")
                    self.nameArray = dicData!
                
             }
             
         }.resume()
    }
    
    @IBAction func btnNotificationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc,animated: true)
    }
    @IBAction func btnCartAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
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
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DeleteViewController") as! DeleteViewController
        self.navigationController?.pushViewController(vc, animated:true)
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
             // self.navigationController?.pushViewController(vc, animated: false)
            
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


    
}
