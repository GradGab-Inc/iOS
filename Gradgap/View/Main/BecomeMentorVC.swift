//
//  BecomeMentorVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

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
        
    }
    
    @IBAction func clickToSignUp(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        parentBackView.isHidden = true
    }
    

}
