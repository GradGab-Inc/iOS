//
//  ForgotPasswordVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
        vc.fromSignup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
