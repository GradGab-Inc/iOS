//
//  ConfirmBookingVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ConfirmBookingVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var applyCouponTxt: TextField!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var walletBallenceLbl: UILabel!
    @IBOutlet weak var toBePaidLbl: UILabel!
    @IBOutlet weak var additionalTopicTxt: TextView!
    
    @IBOutlet var bookingStatusBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Book"
        navigationBar.backBtn.setImage(UIImage.init(named: "ic_close-1"), for: .normal)
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        bookingStatusBackView.isHidden = true
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToConfirmBooking(_ sender: Any) {
        bookingStatusBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: bookingStatusBackView)
    }
    
    @IBAction func clickToBackToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        log.success("ConfirmBookingVC Memory deallocated!")/
    }
    
}
