//
//  CalenderListTVC.swift
//  Gradgap
//
//  Created by iMac on 12/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class CalenderListTVC: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var backView: View!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
