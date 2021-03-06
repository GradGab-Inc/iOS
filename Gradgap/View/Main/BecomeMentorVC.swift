//
//  BecomeMentorVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class BecomeMentorVC: UIViewController {

    @IBOutlet var parentBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - configUI
    private func configUI() {
        parentBackView.isHidden = true
    }
    
    //MARK: - Button Click
    @IBAction func clickToWhoAreYou(_ sender: UIButton) {
        if sender.tag == 1 {
            
        }
        else if sender.tag == 2 {
            
        }
        else if sender.tag == 3 {
            
        }
        else {
            
        }
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "WantToMeetVC") as! WantToMeetVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAreYouPerent(_ sender: Any) {
        parentBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: parentBackView)
    }
    
    @IBAction func clickToBecomMentor(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToMentorDashBoard()
    }
    
    @IBAction func clickToContinue(_ sender: Any) {
        parentBackView.isHidden = true
//        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "WantToMeetVC") as! WantToMeetVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        parentBackView.isHidden = true
    }
    
    deinit {
        log.success("BecomeMentorVC Memory deallocated!")/
    }

}
