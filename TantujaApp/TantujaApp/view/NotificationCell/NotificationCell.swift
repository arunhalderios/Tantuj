//
//  NotificationCell.swift
//  TantujaApp
//
//  Created by Niranjan Barik on 12/09/22.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lbl_yarnName: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    
    @IBOutlet weak var viewNotification: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewNotification.clipsToBounds = true
        viewNotification.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
