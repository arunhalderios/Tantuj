
import Foundation
//import Reachability
import Alamofire
import SwiftyJSON

struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}



class AuthService {
    static let instance = AuthService()//creating a instance
    typealias CompletionHandler = (_ success: Bool, _ data: Any?, _ message: String?)-> Void
    let baseUrl = "http://166.62.54.122/tantuja_latest/api/"
   // let baseUrl = "https://tantujaonline.com/api/"
    

    //"https://developer.shyamfuture.in/sms/api/"
    
    let imageBaseUrl = ""

    let STATUS          = "1"
    let SOCITY          = "society_list"
    let REGISTRATION    = "weaver_register"
    let LOGIN           = "weaver-login"
    let VERIFY_OTP      = "verify-otp"
    let Resend_OTP      = "resend-otp"
    let MYPROFILE       = "profile-details"
    let HUB_LIST        = "hub-list"
    let CATEGRY_LIST    = "category-list"
    let PARTICULAR_LIST = "particular-list"
    let MILL_LIST       = "mill-list"
    let ADD_TO_CART     = "add-to-cart"
    let GET_CART        = "get-cart"
    let COUNT           = "count"
    let NOTI_COUNT      = "notification_count"
    let UPCOMING_PAST   = "ordernew"
    let PAST            = "orderpast"
    let CARTREMOVE      =  "delete-cart-item"
    let PROFILEUPDATE   = "profile-update"
    let FORGOTPASSWORD  = "weaver-forgot-pass"
    let CREATEPASSWORD  = "weaver-create-pass"
    let CHANGEPASSWORD  = "change-password"
    let DELETE          = "update-user-status"
    let HOLIDAYLIST     = "holiday-list"

    let ISLOGGEDIN          = "isLogginTure"
    let ISLOGINEXPIRE         = "isloginExpire"
    let SAVE_CHECK          = "saveCheck"
    let SAVED_USER_NAME     = "savedUserName"
    let SAVED_PASSWORD      = "savedPassword"
    let CHECKOUT            = "cart-checkout"
    let PAYMENT             = "paynow"
    let HAS_ICARD           = "hasiCard"
    
    // http://166.62.54.122/tantuja-web/api/cart-checkout
    
    var idListArray = NSMutableArray()
    var nameListArray = NSMutableArray()
    var bundleListArray = NSMutableArray()
    
    var idtypeArray = NSMutableArray()
    var nameTypeArray = NSMutableArray()
    
    var dataArrayList = NSArray()
    var dataCategoryList = NSArray()
    var dataParticularList = NSArray()
    var dataMilkList = NSArray()

    var hubListArray:NSArray = NSArray()

    var dataCart = NSArray()
    
    var holidayListing = [JSON]()


    var cartListing = [JSON]()
    var subtotal = 0.0
    var gst = 0.0
    var sgst = 0.0
    var cgst = 0.0
    var total = 0.0
    
    
    
    var upcomingListing = [JSON]()
    var upcoming_subtotal = 0.0
    var u_gst = 0.0
    var u_sgst = 0.0
    var u_cgst = 0.0
    var u_total = 0.0

    let defaults = UserDefaults.standard
    
    let ICARD          = "ICARD"
    let AADHAAR        = "AADHAAR"
    let PROFILE_DATA   = "PROFILE_DATA"
    let TOKEN          = "TOKEN"
    let USERID         = "USERID"
    let EMAIL          = "EMAIL"
    let PROFILE_PIC    = "PROFILE_PIC"
    let PHONE_NUMBER   = "PHONE_NUMBER"
    let OTP            = "OTP"

    let SOCITY_NAME    = "SOCITY_NAME"

    let NAME           = "NAME"
    let PENDING_ORDER  = "PENDING_ORDER"
    let PLACED_ORDER   = "PLACED_ORDER"
    let SUCCESS_ORDER  = "SUCCESS_ORDER"
    let COTTON_LIMIT   = "COTTON_LIMIT"
    let SILK_LIMIT     = "SILK_LIMIT"
    let NOTIFICATION   = "notification"
    


        // Set and get the value
    
    var isLoggedIn:Bool?{
        get{
            return (defaults.value(forKey: ISLOGGEDIN) as? Bool)
        }set{
            defaults.setValue(newValue, forKey: ISLOGGEDIN)
        }
        
    }
    
    var isLoggedExpire:Bool?{
        get{
            return (defaults.value(forKey: ISLOGINEXPIRE) as? Bool)
        }set{
            defaults.setValue(newValue, forKey: ISLOGINEXPIRE)
        }
        
    }
    
    var hasICard:Bool?{
        get{
            return (defaults.value(forKey: HAS_ICARD) as? Bool)
        }set{
            defaults.setValue(newValue, forKey: HAS_ICARD)
        }
        
    }
    
    var savedCheck:Bool?{
        get{
            return (defaults.value(forKey:SAVE_CHECK ) as? Bool)
        }set{
            defaults.setValue(newValue, forKey: SAVE_CHECK)
        }
        
    }
    
    var savedUserName:String?{
        get{
            return (defaults.value(forKey: SAVED_USER_NAME) as? String)
        }set{
            defaults.setValue(newValue, forKey: SAVED_USER_NAME)
        }
        
    }
    
    var savedPassword:String?{
        get{
            return (defaults.value(forKey: SAVED_PASSWORD) as? String)
        }set{
            defaults.setValue(newValue, forKey: SAVED_PASSWORD)
        }
        
    }
    
    
    var count:Int?{
        get{
            return (defaults.value(forKey: COUNT) as? Int)
        }set{
            defaults.set(newValue, forKey: COUNT)
        }
    }
    
    var notification_count:Int?{
        get{
            return (defaults.value(forKey: NOTI_COUNT) as? Int)
        }set{
            defaults.set(newValue, forKey: NOTI_COUNT)
        }
    }
    
    var iCard_user:String?{
        get{
            return (defaults.value(forKey: ICARD) as? String)
        }set{
            defaults.set(newValue, forKey: ICARD)
        }
    }
    
    var iCardData:Data?{
        get{
            return (defaults.value(forKey: ICARD) as? Data)
        }set{
            defaults.set(newValue, forKey: ICARD)
        }
    }
    
    var profileData:Data?{
        get{
            return (defaults.value(forKey: PROFILE_DATA) as? Data)
        }set{
            defaults.set(newValue, forKey: PROFILE_DATA)
        }
    }
    
    var aadharData:Data?{
        get{
            return (defaults.value(forKey: AADHAAR) as? Data)
        }set{
            defaults.set(newValue, forKey: AADHAAR)
        }
    }
    
    var token:String?{
        get{
            return (defaults.value(forKey: TOKEN) as? String)
        }set{
            defaults.set(newValue, forKey: TOKEN)
        }
    }
    
    var userID:String?{
        get{
            return (defaults.value(forKey: USERID) as? String)
        }set{
            defaults.set(newValue, forKey: USERID)
        }
    }
    
    var phoneNo:String?{
        get{
            return (defaults.value(forKey: PHONE_NUMBER) as? String)
        }set{
            defaults.set(newValue, forKey: PHONE_NUMBER)
        }
    }
    
    var otp:String?{
        get{
            return (defaults.value(forKey: OTP) as? String)
        }set{
            defaults.set(newValue, forKey: OTP)
        }
    }
    
    var email:String?{
        get{
            return (defaults.value(forKey: EMAIL) as? String)
        }set{
            defaults.set(newValue, forKey: EMAIL)
        }
    }
    
    var profilePic:String?{
        get{
            return (defaults.value(forKey: PROFILE_PIC) as? String)
        }set{
            defaults.set(newValue, forKey: PROFILE_PIC)
        }
    }
    
    var IcardPic:String?{
        get{
            return (defaults.value(forKey: ICARD) as? String)
        }set{
            defaults.set(newValue, forKey: ICARD)
        }
    }
    
    var AadhaarPic:String?{
        get{
            return (defaults.value(forKey: AADHAAR) as? String)
        }set{
            defaults.set(newValue, forKey: AADHAAR)
        }
    }
    
    var phoneNumber:String?{
        get{
            return (defaults.value(forKey: PHONE_NUMBER) as? String)
        }set{
            defaults.set(newValue, forKey: PHONE_NUMBER)
        }
    }
    
    var socityName:String?{
        get{
            return (defaults.value(forKey: SOCITY_NAME) as? String)
        }set{
            defaults.set(newValue, forKey: SOCITY_NAME)
        }
    }
    
    var pendingOrder:String?{
        get{
            return (defaults.value(forKey: PENDING_ORDER) as? String)
        }set{
            defaults.set(newValue, forKey: PENDING_ORDER)
        }
    }
    
    var placed_order:String?{
        get{
            return (defaults.value(forKey: PLACED_ORDER) as? String)
        }set{
            defaults.set(newValue, forKey: PLACED_ORDER)
        }
    }
    
    var success_order:String?{
        get{
            return (defaults.value(forKey: SUCCESS_ORDER) as? String)
        }set{
            defaults.set(newValue, forKey: SUCCESS_ORDER)
        }
    }
    
    var cotton_limit:String?{
        get{
            return (defaults.value(forKey: COTTON_LIMIT) as? String)
        }set{
            defaults.set(newValue, forKey: COTTON_LIMIT)
        }
    }
    
    var silk_limit:String?{
        get{
            return (defaults.value(forKey: SILK_LIMIT) as? String)
        }set{
            defaults.set(newValue, forKey: SILK_LIMIT)
        }
    }

    var name:String?{
        get{
            return (defaults.value(forKey: NAME) as? String)
        }set{
            defaults.set(newValue, forKey: NAME)
        }
    }
    
    var Success_Status:String?{
        get{
            return (defaults.value(forKey: STATUS) as? String)
        }set{
            defaults.set(newValue, forKey: STATUS)
        }
    }
    
    func sociaty (completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let url = baseUrl + SOCITY
        print("============HEADERS=================")
        print(url)
            AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
                print("response: \(response.result)")
                switch response.result{
                case .success(let value):
                    
                    let resultValue = SwiftyJSON.JSON(value)
                    print("=============RESPONSE DATA==================")
                    
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(false, nil, err.localizedDescription)
                }
            }
        
    }
    
    func SignUpAPI(nameStr:String,phoneNumberStr:String,emailStr:String,passwordStr:String,societyIdStr:String,id_cardYesOrNOStr:String,icard_numberStr:String,adharImgData: Data,icardImgData:Data, completion: @escaping CompletionHandler){
          
        /*
         nameStr: name, id_cardYesOrNOStr: strCardOptionData, icard_numberStr: strCardNumber, passwordStr: phone!, societyIdStr: email!, id_cardYesOrNOStr: passWd!, icard_numberStr: sName!, adharImgData: AuthService.instance.aadharData!, icardImgData: AuthService.instance.iCardData!,
         
         */
        
        let headers: HTTPHeaders = [
            "Accept" : "application/json"]
        
        let url = baseUrl + REGISTRATION
        
         print("============HEADERS=================")
         print(headers)
         print(icardImgData)
         print(adharImgData)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(icardImgData, withName: "icard", fileName: "icard.jpg", mimeType: "image/jpeg");
            multipartFormData.append(id_cardYesOrNOStr.data(using: .utf8)!, withName: "id_card")

            multipartFormData.append(adharImgData, withName: "adhar_document", fileName: "adhar_document.jpg", mimeType: "image/jpeg")
            multipartFormData.append(nameStr.data(using: .utf8)!, withName: "name")
            multipartFormData.append(phoneNumberStr.data(using: .utf8)!, withName: "phone_number")
            multipartFormData.append(emailStr.data(using: .utf8)!, withName: "email")
            multipartFormData.append(passwordStr.data(using: .utf8)!, withName: "password")
            multipartFormData.append("1".data(using: .utf8)!, withName: "language")
            multipartFormData.append(societyIdStr.data(using: .utf8)!, withName: "society_id")
            multipartFormData.append(emailStr.data(using: .utf8)!, withName: "email")
            multipartFormData.append(emailStr.data(using: .utf8)!, withName: "icard_number")

        },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    

    func ForgotPasswordAPI(phNoStr: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["phone_number":phNoStr]
        let url = baseUrl + FORGOTPASSWORD
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.token = resultValue["data"]["auth_token"].stringValue
                    self.phoneNo = resultValue["data"]["phone_number"].stringValue
                    self.otp = resultValue["data"]["otp"].stringValue

                    let message = resultValue["msg"].stringValue
                    
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func LoginAPI(phNoStr: String,passwordStr: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["phone_number":phNoStr,"password":passwordStr]
        let url = baseUrl + LOGIN
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.token = resultValue["data"]["auth_token"].stringValue
                    self.userID = resultValue["data"]["id"].stringValue
                    let message = resultValue["msg"].stringValue
                    AuthService.instance.isLoggedIn = true
                    
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func otpAPI(mobileNumber:String, completion: @escaping CompletionHandler){
        let strPhone =  UserDefaults.standard.string(forKey: "phone") ?? ""

        print(strPhone)

        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let url = baseUrl + VERIFY_OTP + "?phone_no=\(mobileNumber)"
       
        print("============HEADERS=================")
        print(headers)

        print("============URL=================")
        print(url)
        AF.request(url, method: .get, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func ResendOtpAPI(phNoStr: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["phone_number":phNoStr]
        let url = baseUrl + Resend_OTP
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func CreatePassAPI(passStr: String,conPassStr: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["actualpass":passStr,"password":conPassStr]
        let url = baseUrl + CREATEPASSWORD
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.token = resultValue["data"]["auth_token"].stringValue
                    self.userID = resultValue["data"]["id"].stringValue
                    let message = resultValue["msg"].stringValue
                    
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func ChangePassAPI(prevPassStr: String,conPassStr: String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"old_password":prevPassStr,"password":conPassStr]
        let url = baseUrl + CHANGEPASSWORD
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.token = resultValue["data"]["auth_token"].stringValue
                    self.userID = resultValue["data"]["id"].stringValue
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func MyProfileAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json",
            "authorization": "Bearer \(AuthService.instance.token!)"
]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + MYPROFILE
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.email = resultValue["data"]["email"].stringValue
                    self.profilePic = resultValue["data"]["profile_pic"].stringValue
                    self.AadhaarPic = resultValue["data"]["adhar_document"].stringValue
                    self.IcardPic = resultValue["data"]["icard"].stringValue
                    self.name = resultValue["data"]["name"].stringValue
                    self.phoneNumber = resultValue["data"]["phone_number"].stringValue
                    self.pendingOrder = resultValue["data"]["pending_order"].stringValue
                    self.placed_order = resultValue["data"]["placed_order"].stringValue
                    self.success_order = resultValue["data"]["success_order"].stringValue
                    let limitCotton = Double(resultValue["data"]["cotton_limit"].stringValue)
                    
                   // self.cotton_limit = resultValue["data"]["cotton_limit"].stringValue
                    self.cotton_limit = "\(String(format: "%.2f", limitCotton!)) kg Cotton"
                    self.silk_limit = "\(resultValue["data"]["silk_limit"].stringValue) kg Silk"
                    self.count = resultValue["data"]["count"].intValue
                    self.notification_count = resultValue["data"]["notification_count"].intValue

                  //  let profileimage = dict?.value(forKeyPath: "data.profile_image") as? String ?? ""
                    self.defaults.set(self.profilePic, forKey: "profile_image")
                    self.defaults.set(self.AadhaarPic, forKey: "aadhaar_image")
                    self.defaults.set(self.IcardPic, forKey: "ICard_image")
                    self.defaults.set(self.phoneNumber, forKey: "phone_number")
                    self.defaults.set("", forKey: "status_value")
                    AuthService.instance.isLoggedExpire = false
                    
                    let iCardNumber  = resultValue["data"]["icard_number"].stringValue
                    if iCardNumber != ""{
                        AuthService.instance.hasICard = true
                    }
                    else{
                        AuthService.instance.hasICard = false
                    }

                    
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }else if statusStr == 3{
                    let message = resultValue["msg"].stringValue
                    self.defaults.set("3", forKey: "status_value")
                    AuthService.instance.isLoggedExpire = true
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func HubListAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json",
            "authorization": "Bearer \(AuthService.instance.token!)"
]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + HUB_LIST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.dataArrayList = resultValue["data"].rawValue as! NSArray
                    let tempArray = resultValue["data"].arrayValue
                    
         
                    for i in 0...tempArray.count-1{
                        self.idListArray.add(tempArray[i]["id"])
                        self.nameListArray.add(tempArray[i]["name"])
                        self.bundleListArray.add(tempArray[i]["bundle_weight"])
                    }
                    
                    
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func CategoryListAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + CATEGRY_LIST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.dataCategoryList = resultValue["data"].rawValue as! NSArray

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func ParticularListAPI(CatIDStr:Int, hubIdStr:Int,catType:Int, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"cat_id":CatIDStr,"cat_type":catType,"hub_id":hubIdStr]
        let url = baseUrl + PARTICULAR_LIST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.dataParticularList = resultValue["data"].rawValue as! NSArray

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func AddToCartAPI(hubIdStr:Int,categoryIDStr:Int,selling_costStr:Double, yardIdStr:Int,mill_idStr:Int,bundleStr:Int,weightStr:Double,max_quantityStr:Double, completion: @escaping CompletionHandler){

        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = [
            "user_id":AuthService.instance.userID!,"hub_id":hubIdStr, "category_id":categoryIDStr,"selling_cost":selling_costStr,"yarn_id":yardIdStr, "mill_id":mill_idStr,"bundle":bundleStr,"weight":weightStr,"max_quantity":max_quantityStr,]
        let url = baseUrl + ADD_TO_CART
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.dataCart = resultValue["data"].rawValue as? NSArray ?? []

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func MillListAPI(catType:Int,hubIdStr:Int,categoryIDStr:Int,yardIdStr:Int,completion: @escaping CompletionHandler){
           
           let headers: HTTPHeaders = [
                       "Content-Type":"application/json",
                       "Accept": "application/json",
                       "authorization": "Bearer \(AuthService.instance.token!)"
           ]
           let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"hub_id":hubIdStr,"cat_type":catType,"cat_id":categoryIDStr,"yarn_id":yardIdStr]
        
        let url = baseUrl + MILL_LIST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA Milk: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.dataMilkList = resultValue["data"].rawValue as! NSArray

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func Get_CartAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + GET_CART
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.cartListing = resultValue["data"].arrayValue
                    self.subtotal = resultValue["subtotal"].doubleValue
                    self.gst = resultValue["gst"].doubleValue
                    self.sgst = resultValue["sgst"].doubleValue
                    self.cgst = resultValue["cgst"].doubleValue
                    self.total = resultValue["total"].doubleValue
                    self.defaults.set(self.total, forKey: "total")
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func CartRemoveAPI(strCartID: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"cart_id":strCartID]
        let url = baseUrl + CARTREMOVE
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func PastAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + PAST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.upcomingListing = resultValue["data"].arrayValue
//                    let resultValueDic = resultValue["data"]
//
//                    self.upcoming_subtotal = resultValueDic["subtotal"].doubleValue
//                    self.u_gst      = resultValueDic["gst"].doubleValue
//                    self.u_sgst     = resultValueDic["sgst"].doubleValue
//                    self.u_cgst     = resultValueDic["cgst"].doubleValue
//                    self.u_total    = resultValueDic["total"].doubleValue

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func upcoming_PastAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + UPCOMING_PAST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.upcomingListing = resultValue["data"].arrayValue
//                    let resultValueDic = resultValue["data"]
//
//                    self.upcoming_subtotal = resultValueDic["subtotal"].doubleValue
//                    self.u_gst      = resultValueDic["gst"].doubleValue
//                    self.u_sgst     = resultValueDic["sgst"].doubleValue
//                    self.u_cgst     = resultValueDic["cgst"].doubleValue
//                    self.u_total    = resultValueDic["total"].doubleValue

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    func NotificationAPI(completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + NOTIFICATION
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.upcomingListing = resultValue["data"].arrayValue
//                    let resultValueDic = resultValue["data"]
//
//                    self.upcoming_subtotal = resultValueDic["subtotal"].doubleValue
//                    self.u_gst      = resultValueDic["gst"].doubleValue
//                    self.u_sgst     = resultValueDic["sgst"].doubleValue
//                    self.u_cgst     = resultValueDic["cgst"].doubleValue
//                    self.u_total    = resultValueDic["total"].doubleValue

                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    
    
    func profileUpdate(nameStr:String,phoneNumberStr:String,emailStr:String,profilePicData:Data,societyIdStr:String,adharImgData: Data,icardImgData:Data, completion: @escaping CompletionHandler){
          
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json",
            "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        
        let url = baseUrl + PROFILEUPDATE
        
         print("============HEADERS=================")
         print(headers)
         print(icardImgData)
         print(adharImgData)
         print(profilePicData)
         print("============URL=================")
         print(url)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(icardImgData, withName: "icard", fileName: "icard.jpg", mimeType: "image/jpeg");
            multipartFormData.append(adharImgData, withName: "adhar_document", fileName: "adhar_document.jpg", mimeType: "image/jpeg")
            multipartFormData.append(profilePicData, withName: "profile_pic", fileName: "profile_pic.jpg", mimeType: "image/jpeg")
            multipartFormData.append(nameStr.data(using: .utf8)!, withName: "name")
            multipartFormData.append(phoneNumberStr.data(using: .utf8)!, withName: "phone_number")
            multipartFormData.append(emailStr.data(using: .utf8)!, withName: "email")
          //  multipartFormData.append(passwordStr.data(using: .utf8)!, withName: "password")
          //  multipartFormData.append("1".data(using: .utf8)!, withName: "language")
            multipartFormData.append(societyIdStr.data(using: .utf8)!, withName: "society_id")
            multipartFormData.append(AuthService.instance.userID!.data(using: .utf8)!, withName: "user_id")
        },
        to:url, usingThreshold: UInt64.init(), method: .post, headers: headers).validate(statusCode: 200..<600).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                    
                    let strStatus = resultValue["msg"].stringValue
                    print("Value: \(strStatus)")
                }
                else if statusStr == 2{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else if statusStr == 3{
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
      }
    
    
    
    
    func Procced_CheckoutAPI(cartData:Array<Any>,completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "authorization": "Bearer \(AuthService.instance.token!)"
        ]
        
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"cart_id":cartData]
        let url = baseUrl + CHECKOUT
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    
                    self.cartListing = resultValue["data"].arrayValue
                    self.subtotal    = resultValue["subtotal"].doubleValue
                    self.gst         = resultValue["gst"].doubleValue
                    self.sgst        = resultValue["sgst"].doubleValue
                    self.cgst        = resultValue["cgst"].doubleValue
                    
                    
                    self.total   = resultValue["total"].doubleValue
                 //   self.total     = "\(Double(format: "%.2f", strTotal!))"
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func payment(cartData:Array<Any>,paymentModeStr:String,subTotalStr:String,gstString:String,cgstString:String,sgstString:String,totalString:String,pickupDateString:String,completion: @escaping CompletionHandler){

            let headers: HTTPHeaders = [

                        "Content-Type":"application/json",
                        "Accept": "application/json",
                        "authorization": "Bearer \(AuthService.instance.token!)"

            ]

            let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"cart_id":cartData,"payment_mode":paymentModeStr,"sub_total":subTotalStr,"gst":gstString,"cgst":cgstString,"total":totalString,"pickup_date":pickupDateString]
            

            let url = baseUrl + PAYMENT


            print("============HEADERS=================")

            print(headers)

            print("============PARAMS=================")

            print(params)

            print("============URL=================")

            print(url)

            AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in

                switch response.result{

                case .success(let value):

                    

                    let resultValue = SwiftyJSON.JSON(value)

                    print("=============RESPONSE DATA==================")

                    print("RESPONSE DATA: \(resultValue)")

                    let statusStr = resultValue["status"].intValue

                    if statusStr == 1{



                        let message = resultValue["msg"].stringValue

                        completion(true, nil, message)

                    }

                    else{

                        

                        let message = resultValue["msg"].stringValue

                        completion(false, nil, message)

                       // completion(false, nil, nil)

                    }

                    

                case .failure(let err):

                    print(err.localizedDescription)

                    completion(false, nil, err.localizedDescription)

                }

            }

        }
    
    
    // MARK: Delete API
    
    func DeleteAPI(statusStr: String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!,"status":statusStr]
        let url = baseUrl + DELETE
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    self.token = resultValue["data"]["auth_token"].stringValue
                    self.userID = resultValue["data"]["id"].stringValue
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                   // completion(false, nil, nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    
    func HolidayListAPI(completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
            
            "Content-Type":"application/json",
            "Accept": "application/json",
            "authorization": "Bearer \(AuthService.instance.token!)"

        ]
        let params : [String:Any]  = ["user_id":AuthService.instance.userID!]
        let url = baseUrl + HOLIDAYLIST
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print("RESPONSE DATA: \(resultValue)")
                let statusStr = resultValue["status"].intValue
                if statusStr == 1{
                    let totalList = resultValue["data"].arrayValue
                    self.holidayListing.removeAll()
                    for i in 0...totalList.count - 1 {
                        self.holidayListing.append(JSON(rawValue: totalList[i]["date"].stringValue) ?? "")
                    }
                    let message = resultValue["msg"].stringValue
                    completion(true, nil, message)
                }
                else{
                    
                    let message = resultValue["msg"].stringValue
                    completion(false, nil, message)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    

    //Sign Up API
   /* func SignUpAPI(unameStr: String,emailidStr: String,phone_noStr: String,passwordStr: String,roleStr:String, completion: @escaping CompletionHandler){
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["uname":unameStr,"emailid":emailidStr,"phone_no":phone_noStr,"password":passwordStr,"role":roleStr]
        let url = baseUrl + "signup"
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
            AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    
                    let resultValue = SwiftyJSON.JSON(value)
                    print("=============RESPONSE DATA==================")

                    print(resultValue)
                    let statusStr = resultValue["stat"].stringValue
                    if statusStr == "val_err"{
                        completion(false, nil, nil)

                    }
                    else if statusStr == "succ"{
                        let messageStr = resultValue["message"].stringValue
                        completion(true, nil, messageStr)
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(false, nil, err.localizedDescription)
                }
            }
        
    }*/
    /*
    func LoginAPI(emailidStr: String,passwordStr: String, completion: @escaping CompletionHandler){
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let params : [String:Any]  = ["emailid":emailidStr,"password":passwordStr,"fcm_token":AuthService.instance.firebaseToken!]
        let url = baseUrl + TEACHER_LOGIN
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        AF.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")

                print(resultValue)
                let statusStr = resultValue["stat"].stringValue
                if statusStr == "val_err"{
//                    let message  = resultValue["message"].stringValue
//                    print(message)
                    completion(false, nil, nil)

                }
                else if statusStr == "succ"{
                    self.token = resultValue["token"].stringValue
                    let result = resultValue["data"].dictionaryValue
                    print("=============RESULT DATA==================")
                    
                    self.name = result["name"]?.stringValue
                    self.email = result["email"]?.stringValue
                    self.phone = result["phone_no"]?.stringValue
                    self.userID = result["id"]?.intValue

                    print(result)
                    
                    
                    completion(true, nil, nil)
                }
                else if statusStr == "err"{
                    let message  = resultValue["message"].stringValue
                    completion(false, nil, message)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, err.localizedDescription)
            }
        }
    }
    */
    
}

