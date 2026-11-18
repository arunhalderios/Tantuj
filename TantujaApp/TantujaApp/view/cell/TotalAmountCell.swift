//
//  TotalAmountCell.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit

class TotalAmountCell: UITableViewCell {

    @IBOutlet weak var lbl_Subtotal: UILabel!
    @IBOutlet weak var lbl_GST: UILabel!
    @IBOutlet weak var lbl_CGST: UILabel!
    @IBOutlet weak var lbl_SGST: UILabel!
    @IBOutlet weak var lbl_GrantTotal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
