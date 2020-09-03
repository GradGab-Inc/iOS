//
//  TransactionTVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class TransactionTVC: UITableViewCell {

    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
