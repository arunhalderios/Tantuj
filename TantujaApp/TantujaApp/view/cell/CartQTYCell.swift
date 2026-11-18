//
//  CartQTYCell.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit

protocol ItemTableViewCellDelegate: NSObject {
func cellCheckButtonDidTapped(cell: CartQTYCell)
 }

class CartQTYCell: UITableViewCell {

    @IBOutlet weak var lbl_MillName: UILabel!
    @IBOutlet weak var lbl_maxQuantity: UILabel!
    @IBOutlet weak var lbl_HubsName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var btnOption: UIButton!
    weak var delegate: ItemTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnRemove.clipsToBounds = true
        btnRemove.layer.cornerRadius = 5
        btnRemove.layer.borderWidth = 0.5
        btnRemove.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func btnOptionAction(_ sender: Any) {
        delegate?.cellCheckButtonDidTapped(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
