//
//  WantToMeetVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class WantToMeetVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCollegeStudent(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
    }
    
    @IBAction func clickToMBAStudent(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
    }
    
    deinit {
        log.success("WantToMeetVC Memory deallocated!")/
    }
    
}
