//
//  CardListTVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class CardListTVC: UITableViewCell {

    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var removeCardBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
