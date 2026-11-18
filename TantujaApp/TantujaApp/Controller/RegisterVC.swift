//
//  RegisterVC.swift
//  Sample
//
//  Created by Arun Halder on 01/09/22.
//

import UIKit
import MBProgressHUD

class RegisterVC: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ********** UITextField ********** //
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSocityName: UITextField!
    
    @IBOutlet weak var txtCardOption: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    
    @IBOutlet weak var lblUploadAadhaar: UILabel!
    @IBOutlet weak var lblUploadWeavers: UILabel!
    
    @IBOutlet weak var vwIdcardOption: UIView!

    @IBOutlet weak var vwIdcardField: UIView!
    @IBOutlet weak var vwWeaversIDcard: RoundView!
    @IBOutlet weak var imgVw_Aadhaar: UIImageView!
    @IBOutlet weak var imgVw_Weaver: UIImageView!
    
    @IBOutlet weak var stackHeightConstant: NSLayoutConstraint!
    // ********** Array ********** //
    var nameArray:NSArray = NSArray()
    var idCardOptionArray:NSMutableArray = NSMutableArray()

    // ********** Variable ********** //

    var alertForName :UIAlertController = UIAlertController()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    private var image: UIImage?
    var defaults = UserDefaults.standard
    @IBOutlet var aadhaarBtn:      UIButton!
    var isImageUpdated: Bool    = false
    var check         : Bool    = false
    
    @IBOutlet var checkBtn: UIButton!

    var selectedSocityID: String = ""
    
    var icardData  = Data()
    var adhaarData = Data()
    var imageAdhaarBool = true

    
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
        
        
        // Do any additional setup after loading the view.
        
     //   let notificationCenter = NotificationCenter.default
      //  notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        idCardOptionArray = ["Yes","No"]
        
        configureGesture()
        self.sociteyAPI()
        
        
    }
    
    func sociteyAPI(){
        
        HUD.show(to: self.view)
        let url = URL(string: "https://tantujaonline.com/api/society_list")
         
         URLSession.shared.dataTask(with: url!) {(data, response, error ) in
             
             if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                 
                 print("jsonObject: \(jsonObj)")
                 HUD.hide(to: self.view)
                    let dicData = jsonObj.value(forKey: "data") as? NSArray
                    print("dicData: \(dicData)")
                    self.nameArray = dicData!
                 
             }
             
         }.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.sociteyAPI()
        

    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        
       // login.logOut()
    }
    
    // MARK: set Scrollview
    
    func setScrollView() {
       
//        registerMainView.frame.size.height    = registerBtn.frame.origin.y + registerBtn.frame.size.height + 20
//        mainScrolView.contentSize = CGSize(width: mainScrolView.frame.size.width , height: registerMainView.frame.origin.y + registerMainView.frame.size.height + 20)
        
        //scroller.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
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
    
    
    // MARK: textField customize methods
       
       func configureGesture(){
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.handleTap))
           view.addGestureRecognizer(tapGesture)
       }
       
       @objc func handleTap(){
           
        view.endEditing(true)
           
       }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       
        if (txtSocityName.isFirstResponder == true) {
            
            self.view.endEditing(true)
            
            self.showSocityListing()
           
        }else if (txtCardOption.isFirstResponder == true){
            
            print("option: \(idCardOptionArray)")
            self.view.endEditing(true)
            self.showIdOption()
            
        }
        
    }
    
    // MARK:- Textfield validation methods
    
    func isValidTextfield() -> Bool {
        
        let name   = txtName.text
        let email  = txtEmail.text
        let passWd = txtPassword.text
        let phone   = txtPhoneNumber.text
        let socity   = txtSocityName.text

        defaults.set(phone, forKey: "phone")

         if (txtName.text?.isEmpty == true) {
            
            popUpAlert(msg: "Please enter your name")
            
            return false
            
        }
        
        else if (isValidEmail(testStr: email!) == false) {
            
            popUpAlert(msg: "Invalid email address")
            
            return false
            
        }
       else if (passWd?.isEmpty == true) {
                
                popUpAlert(msg: "Please enter password")
                return false
        }
        else if (isNumber(text: txtName.text!) == true || isContainSpace(text: txtName.text!) == true) {
            
            popUpAlert(msg: "Please enter a valid name")
            
            return false
            
        }
        else if (txtPhoneNumber.text?.isEmpty == true) {
           
           popUpAlert(msg: "Please enter your phone number")
           
           return false
           
       }
       else if (txtSocityName.text?.isEmpty == true) {
           
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
                               
               // showActivityIndicator()
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
               
                  self.txtSocityName.text = "\(strName)"

                  UserDefaults.standard.set(strName, forKey: "socity_Name")

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
    
    
    //Mark :- Alert For Id Option
    
    func showIdOption(){
        
        self.view.endEditing(true)

        let alert = UIAlertController(title: "", message: "Do you have Weavers identity card ?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.txtCardOption.text = "Yes"
                self.vwWeaversIDcard.isHidden = false
                self.vwIdcardField.isHidden = false

                self.stackHeightConstant.constant = 700.0

            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
                self.txtCardOption.text = "No"
                self.vwWeaversIDcard.isHidden = true
                self.vwIdcardField.isHidden = true
                //stackHeightConstant = 600.00
                self.stackHeightConstant.constant = 600.0

            }))


            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        
       }
    
    @IBAction func btnBackButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBtnAction(_ sender: UIButton) {
        
        if (check == false) {
            
            checkBtn.setImage(UIImage(named: "circletick"), for: UIControl.State.normal)
            check = true
            
        } else {
            
            checkBtn.setImage(UIImage(named: "b_uncheck"), for: UIControl.State.normal)
            check = false
            
        }
        
    }
    
    @IBAction func takeAadhaarAction(_ sender: Any) {
        
           var imageAdhaarBool = true
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
    
    @IBAction func uploadWeAction(_ sender: Any) {
        
        
         self.imageAdhaarBool = false
        
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
            self.adhaarData = image.jpegData(compressionQuality: 0.2)!
            AuthService.instance.aadharData = self.adhaarData
            print(adhaarData)
            self.imgVw_Aadhaar.image = UIImage(named: "image")
        }
        else{
            self.icardData = image.jpegData(compressionQuality: 0.2)!
            AuthService.instance.iCardData = self.icardData
            print(icardData)
            self.imgVw_Weaver.image = UIImage(named: "image")
        }
        
        
        self.image = image
        
//        let imageData:NSData = image.jpegData(compressionQuality: 0.5)! as NSData
//
//         base64String = imageData.base64EncodedString(options: .endLineWithCarriageReturn)
//         print("strBase64" , base64String)
//
//            if base64String.isEmpty == true {
//
//                aadhaarBtn.isUserInteractionEnabled = false
//
//            }else if base64String.isEmpty == false {
//
//               self.defaults.set(base64String, forKey: "profile_image_Base64")
//                isImageUpdated = true
//
//                aadhaarBtn.isUserInteractionEnabled = true
//                aadhaarBtn.backgroundColor          = UIColor.black
//
//                aadhaarBtn.isUserInteractionEnabled = true
//                aadhaarBtn.backgroundColor          = UIColor.black
//            }
//
//          print("End")
                    
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signupAction(_ sender: Any) {
    
        
        print(self.icardData)
        print(self.adhaarData)
        
            let isConnected = ReachabilityClass.isConnectedToNetwork()
            
            let email  = txtEmail.text
            let passWd = txtPassword.text
            let phone  = txtPhoneNumber.text
            let name   = txtName.text
            var sName  = txtSocityName.text
        
           let strCardOption = txtCardOption.text
           var strCardOptionData = ""
           var strCardNumber = ""

           if strCardOption == "Yes" {
            
            strCardOptionData = "Y"
            strCardNumber = txtCardNumber.text ?? ""
            
           }else if strCardOption == "No"{
            
            strCardOptionData = "N"
            
          }
                
            if (isValidEmail(testStr: email!) == false) {
                
                popUpAlert(msg: "Invalid email address")
                
            }
            else if (passWd?.isEmpty == true) {
                
                popUpAlert(msg: "Please enter password")
                
            }
            else if (phone?.isEmpty == true) {
                
            popUpAlert(msg: "Please enter phone number")
                
            }
            else if (name?.isEmpty == true) {
                        
             popUpAlert(msg: "Please enter your name")
                        
           }else if (sName?.isEmpty == true) {
                              
              popUpAlert(msg: "Please select society name")
                              
           }
           else if (check == false){
               
               popUpAlert(msg: "You need to agree with our Terms and Privacy Policy to be a member")

           }
          else if (strCardOptionData == "Y") {
            
            if strCardNumber.isEmpty == true {
                
                popUpAlert(msg: "Please enter Weavers identity number")

            }
            
                 
         }
            else{
                
                    if (isValidTextfield() == true) {
                            
                        if (isConnected == true) {
                            
                            
                            // icard_numberStr: sName!,
                            sName = self.selectedSocityID
                            
                            
                            AuthService.instance.SignUpAPI(nameStr: name!, phoneNumberStr: phone!, emailStr: email!, passwordStr: passWd!, societyIdStr: self.selectedSocityID, id_cardYesOrNOStr: strCardOptionData, icard_numberStr: strCardNumber, adharImgData: AuthService.instance.aadharData!, icardImgData: AuthService.instance.iCardData!, completion:{(success, data, message) in
                                
                                if success{
                                   // self.showAlertWith(title: "Tantuj", message: message!)
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                                    let vc = storyboard.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC

                                    self.navigationController?.pushViewController(vc,animated: true)
                                    
                                }
                                else{
                                    self.showAlertWith(title: "Tantuj", message: "Something is error")

                                }
                        })
                        
                    }
                    else {
                            
                            popUpAlert(msg: "No internet connection!")
                            
                    }
                }
            }
            

            
        }

    
    
    @IBAction func btnSignin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

        self.navigationController?.pushViewController(vc,animated: true)
        
    }
    
    
    
    
    func uploadImageToImgur(image: UIImage) {
        
        getBase64Image(image: image) { base64Image in
                  // ...
              }
    }
    
    func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
           DispatchQueue.main.async {
               let imageData = image.pngData()
               let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
               complete(base64Image)
           }
       }


}
