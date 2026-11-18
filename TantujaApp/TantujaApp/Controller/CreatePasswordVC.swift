//
//  CreatePasswordVC.swift
//  Sample
//
//  Created by Arun Halder on 01/09/22.
//

import UIKit
import MBProgressHUD

class CreatePasswordVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @IBAction func actionCreatePassword(_ sender: Any){
        HUD.show(to: self.view)
            let isConnected = ReachabilityClass.isConnectedToNetwork()
            let passWd = txtPassword.text
            let conPass  = txtConfirm.text
            if (passWd?.isEmpty == true) {
                
            popUpAlert(msg: "Please enter password")
                
            }
            else if (conPass?.isEmpty == true) {
                    
            popUpAlert(msg: "Please enter confirm password")
                    
            }
            else{
                    if (isConnected == true) {
                            
                    AuthService.instance.CreatePassAPI(passStr: passWd!, conPassStr: conPass!, completion:{(success, data, message) in
                        if success{
                            HUD.hide(to: self.view)
                        let alert = UIAlertController(title: "Tantuj" , message: message , preferredStyle: .alert)
                                        
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                           // self.okBtnTapped()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
