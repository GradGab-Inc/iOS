//
//  RateReviewVC.swift
//  Gradgap
//
//  Created by iMac on 03/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class RateReviewVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var callRateView: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Rate & Review"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
      
    //MARK: - configUI
    func configUI() {
        
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddFavoites(_ sender: Any) {
        
    }
    
    deinit {
        log.success("RateReviewVC Memory deallocated!")/
    }
      
    
}
