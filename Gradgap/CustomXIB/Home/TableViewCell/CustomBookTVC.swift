//
//  CustomBookTVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class CustomBookTVC: UITableViewCell {

    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
