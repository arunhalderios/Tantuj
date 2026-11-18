//
//  OrderDetailsVC.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 17/09/22.
//

import UIKit

class OrderDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblOrderDetails: UITableView!
    @IBOutlet weak var viewCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCode.clipsToBounds = true
        viewCode.layer.cornerRadius = 5
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }else{
            return 350
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell") as! OrderDetailsCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsAmountCell") as! OrderDetailsAmountCell
            cell.selectionStyle = .none
            return cell
        }
        
    }


}
