//
//  CouponTVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class CouponTVC: UITableViewCell {

    @IBOutlet weak var perecentLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var applyBtn: Button!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
