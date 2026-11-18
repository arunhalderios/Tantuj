//
//  OtherLoginVC.swift
//  Tantuja
//
//  Created by Niranjan on 07/10/22.
//

import UIKit

class OtherLoginVC: UIViewController {

    @IBOutlet weak var lblHub: UILabel!
    @IBOutlet weak var lblAdmin: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnBackButton(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func actionLoginHub(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        UserDefaults.standard.set("Hub", forKey: "Hub")

        self.navigationController?.pushViewController(vc,animated: true)

    }
    
    
    @IBAction func actionLoginAdmin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        UserDefaults.standard.set("Admin", forKey: "Admin")
        self.navigationController?.pushViewController(vc,animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
