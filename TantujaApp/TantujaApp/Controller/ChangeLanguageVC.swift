//
//  ViewController.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 30/08/22.
//

import UIKit
import Alamofire

class ChangeLanguageVC: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var imgcircletickEng: UIImageView!
    @IBOutlet weak var imgCircletickbangali: UIImageView!
    @IBOutlet weak var btnEnglish: CustomButton!
    @IBOutlet weak var btnBangali: CustomButton!
    @IBOutlet weak var viewTop: UIView!
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        languageSetup()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            viewTop.clipsToBounds = false
            viewTop.layer.cornerRadius = 30
            viewTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            viewTop.clipsToBounds = false
            viewTop.layer.cornerRadius = 30
            viewTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        btnContinue.layer.cornerRadius = 17
        btnContinue.clipsToBounds = true
        setEnglishButton()
    }
    
    func languageSetup(){
        
        btnContinue.setTitle(defaultLocalizer.stringForKey(key: "Continue"), for: .normal)
    }
    
    func setBangaliButton(){
        imgCircletickbangali.isHidden = false
        imgcircletickEng.isHidden = true
        btnBangali.layer.borderWidth = 2
        btnBangali.layer.borderColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00).cgColor
        btnBangali.layer.cornerRadius = 12
        
        btnEnglish.layer.borderColor = UIColor.clear.cgColor
    }
    func setEnglishButton(){
        imgCircletickbangali.isHidden = true
        imgcircletickEng.isHidden = false
        btnEnglish.layer.borderWidth = 2
        btnEnglish.layer.borderColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00).cgColor
        btnEnglish.layer.cornerRadius = 12
        imgCircletickbangali.isHidden = true
        btnBangali.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func btnBackbutton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnBangaliAction(_ sender: Any) {
        setBangaliButton()
        defaultLocalizer.setSelectedLanguage(lang: "bn")
    }
    @IBAction func btnEngAction(_ sender: Any) {
        setEnglishButton()
        defaultLocalizer.setSelectedLanguage(lang: "en")
        
    }
    @IBAction func btnContinueAction(_ sender: Any) {
        
    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceYourOrderVCViewController") as? PlaceYourOrderVCViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

