//
//  SelectAvaibilityVC.swift
//  Gradgap
//
//  Created by iMac on 9/23/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class SelectAvaibilityVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var weekBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    
    var selectedDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Set Availability"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        weekBtn.isSelected = true
        dateBtn.isSelected = false
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectTab(_ sender: UIButton) {
        weekBtn.isSelected = false
        dateBtn.isSelected = false
        if sender.tag == 1 {
            weekBtn.isSelected = true
        }
        else {
            dateBtn.isSelected = true
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if weekBtn.isSelected {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SetAvailabilityVC") as! SetAvailabilityVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SelectDateAvailabilityVC") as! SelectDateAvailabilityVC
            vc.selectedDate = selectedDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
