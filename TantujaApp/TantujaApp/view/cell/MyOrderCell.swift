//
//  MyOrderCell.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 17/09/22.
//

import UIKit



class MyOrderCell: UITableViewCell {

    @IBOutlet weak var lbl_yarnName: UILabel!
    @IBOutlet weak var lbl_millName: UILabel!
    @IBOutlet weak var lbl_Qty: UILabel!
    @IBOutlet weak var lbl_Pickup: UILabel!
    @IBOutlet weak var lbl_OrderDate: UILabel!
    @IBOutlet weak var lbl_OrderId: UILabel!
    @IBOutlet weak var lbl_Code: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    
    var invoiceBtnPressed : (() -> ()) = {}


    @IBAction func invoiceBtnAction(_ sender: UIButton) {
        invoiceBtnPressed()
    }
    
    // Bill To
    
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_SocityName: UILabel!

    
    
    /*
                 id": "2",
                 "user_id": "3",
                 "payment_mode": "0",
                 "sub_total": "2045",
                 "gst": "100",
                 "cgst": "50",
                 "sgst": "50",
                 "total": "2145",
                 "status": "0",
                 "payment_status": "0",
                 "created_at": "2022-09-14 13:02:32",
                 "updated_at": "2022-09-14 13:02:32",
                 "category_name": "Cotton",
                 "hubs_name": "Cooch Behar",
                 "yarns_name": "Cone Yarn (Grey and Dyed Form)",
                 "mills_name": "Tamralipta Co-op Spinning Mills Ltd, Purba Medinipur , West Bengal",
                 "code": "9296",
                 "name": "test"
     
     */
    
    @IBOutlet weak var viewCode: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCode.clipsToBounds = true
        viewCode.layer.cornerRadius = 5
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
