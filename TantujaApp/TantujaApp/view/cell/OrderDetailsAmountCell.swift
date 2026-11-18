//
//  OrderDetailsAmountCell.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 17/09/22.
//

import UIKit

class OrderDetailsAmountCell: UITableViewCell {

    @IBOutlet weak var viewCancel: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCancel.clipsToBounds = true
        viewCancel.layer.borderColor = UIColor(red: 0.00, green: 0.44, blue: 0.68, alpha: 1.00).cgColor
        viewCancel.layer.borderWidth = 1
        viewCancel.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
