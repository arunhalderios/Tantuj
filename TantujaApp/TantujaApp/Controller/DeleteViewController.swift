//
//  DeleteViewController.swift
//  TantujaApp
//
//  Created by Niranjan on 16/01/23.
//

import UIKit

class DeleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
       
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        
                
            if (isConnected == true) {
                // || validphone.isValidEmailField()
               
                HUD.show(to: self.view)
                AuthService.instance.DeleteAPI(statusStr: "2", completion:{(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                let alert = UIAlertController(title: "HCS Assist" , message: message , preferredStyle: .alert)
                                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                 
                    
                let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated:true)
                    

                })
                                
                alert.addAction(okAction)
                                
                self.present(alert, animated: true, completion: nil)
                            
                }
                else{
                    HUD.hide(to: self.view)
                 //   self.showAlertWith(message: message!)

                    }
                })
            
        }
    }
    
    @IBAction func btnDeactivateAction(_ sender: Any) {
        
        
        let isConnected = ReachabilityClass.isConnectedToNetwork()
        
                
            if (isConnected == true) {
                // || validphone.isValidEmailField()
               
                HUD.show(to: self.view)
                AuthService.instance.DeleteAPI(statusStr: "3", completion:{(success, data, message) in
                if success{
                    HUD.hide(to: self.view)
                let alert = UIAlertController(title: "HCS Assist" , message: message , preferredStyle: .alert)
                                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                 
                    
                let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated:true)
                    

                })
                                
                alert.addAction(okAction)
                                
                self.present(alert, animated: true, completion: nil)
                            
                }
                else{
                    HUD.hide(to: self.view)
                 //   self.showAlertWith(message: message!)

                    }
                })
            
        }
        else {
            HUD.hide(to: self.view)
        //popUpAlert(msg: "No internet connection!")
                
        }

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
