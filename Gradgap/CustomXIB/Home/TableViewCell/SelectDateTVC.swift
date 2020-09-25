//
//  SelectDateTVC.swift
//  Gradgap
//
//  Created by iMac on 9/23/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class SelectDateTVC: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var availableCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
