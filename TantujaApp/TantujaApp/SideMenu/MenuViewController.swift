//
//  MenuViewController.swift
//  SlideInSlideOut
//
//  Created by ampdevelops on 11/02/19.
//  Copyright © 2019 ampdevelops . All rights reserved.
//

import UIKit

enum MenuType: Int {
    case Home
    case Profile
    case PlaceNewOrder
    case MyOrder
    case Notifications
    case ChangeLanguage
    case ChangePassword
    case Logout
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var overLayButton: UIButton!
    @IBOutlet weak var menuTable: UITableView!
    let defaults = UserDefaults.standard

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!

    var arrayMenuList = [Dictionary<String,String>]()
    var didTapMenuType: ((MenuType) -> Void)?
    
    var strname : String          = UserDefaults.standard.string(forKey: "name") ?? ""
    var strEmail : String         = UserDefaults.standard.string(forKey: "email") ?? ""
   // var strLastname : String = UserDefaults.standard.string(forKey: "last_name") ?? ""
    var strProfile_image : String = UserDefaults.standard.string(forKey: "profile_image") ?? ""
    var strPhone_no : String      = UserDefaults.standard.string(forKey: "phone_number") ?? ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let imageUrl = URL(string: strProfile_image)
//
//        if strProfile_image != "" {
//          //  self.profileImg.imageURL = imageUrl
//        }
//        else {
//            self.profileImg.setImage(string: "\(strname)", color: .white, circular: true, textAttributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont(name: "Oswald-Bold", size: 18.0) as Any])
//        }
        
       // let strValue : String = UserDefaults.standard.string(forKey: "profile_image") ?? ""

        if strProfile_image == "" {
            
            profileImg.image = UIImage(named: "SomeEmptyImage-1")

            print("black image")
//            self.profileImg.setImage(string: "\(strname)", color: .white, circular: true, textAttributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont(name: "Oswald-Bold", size: 18.0) as Any])
            
            
        }else{
            
            let url = URL(string: strProfile_image)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    profileImg.image = image
                }else {
                    profileImg.image = UIImage(named: "SomeEmptyImage")
                }
        }
        
        setMenuInfo()
    }
    
    func setMenuInfo() {
        let string3 = " "

        self.nameLbl.text = strname //+ string3 + strLastname
        self.phoneLbl.text = strPhone_no
        self.emailLbl.text = strEmail
        
      //  profileImg.image = UIImage(data : defaults.value(forKey: "ImageData") as? Data ?? Data())
            
        self.profileImg.layer.masksToBounds = true
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height/2
        self.profileImg.layer.borderColor = UIColor.white.cgColor


//        let strImg : String  = defaults.value(forKey: "ImageData") as? String ?? ""
//        let imageUrl = URL(string: strImg)
//        
//        print("Prof_img_url:\(imageUrl)")
        
//        if strImg != "" {
//
//           // self.profileImg.imageURL = imageUrl
//
//        }
//        else {
//
//            self.profileImg.setImage(string: "\(strname)", color: .white, circular: true, textAttributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont(name: "Oswald-Bold", size: 18.0) as Any])
//
//        }
        
        self.profileImg.layer.masksToBounds = true
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height/2
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateMenu()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dismiss(animated: true) { [weak self] in
           
            self?.didTapMenuType?(MenuType(rawValue: 0)!)
            
        }
    }
    
    @IBAction func whenViewTap(_ sender: Any) {
        
        dismiss(animated: true) { [weak self] in
            
            self?.didTapMenuType?(MenuType(rawValue: 0)!)
            
        }
    }
    
    
    func updateMenu(){
        
        arrayMenuList.append(["title":"Home", "icon":"home"])
        arrayMenuList.append(["title":"Profile", "icon":"profile"])
        arrayMenuList.append(["title":"Place New Order", "icon":"appoveLeave"])
        arrayMenuList.append(["title":"My Orders", "icon":"liveMeeting"])
        arrayMenuList.append(["title":"Notifications", "icon":"liveClasses"])
        arrayMenuList.append(["title":"Change Language", "icon":"homework"])
        arrayMenuList.append(["title":"Change Password", "icon":"noticeBoard"])
        arrayMenuList.append(["title":"Logout", "icon":"aboutSchool"]);
        menuTable.reloadData()
        
    }
   
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuListCell")!
        menuTable.rowHeight = 60
        let lblTitle : UILabel    = cell.contentView.viewWithTag(101) as! UILabel
       // let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
      //  imgIcon.image = UIImage(named: arrayMenuList[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuList[indexPath.row]["title"]!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
            
            
        }
    }
    
}
