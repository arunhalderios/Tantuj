//
//  PaymentSuccessVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit

class PaymentSuccessVC: UIViewController {

    @IBOutlet weak var lbl_OrderNumber: UILabel!
    
    @IBAction func btn_CheckYourOrder(_ sender: UIButton) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

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
