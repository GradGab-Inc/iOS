//
//  EmailVerificationVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class EmailVerificationVC: UIViewController {

    @IBOutlet weak var messageLbl: UILabel!
    
    var fromSignup : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
    }
    
    //MARK: - configUI
    private func configUI() {
        if fromSignup {
            messageLbl.text = "A verification link has been sent to your email."
        }
        else {
             messageLbl.text = "A reset link has been sent to your email."
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToOk(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
//        if fromSignup {
//            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else {
////            self.navigationController?.popToRootViewController(animated: true)
//        }
        
    }
    
    
    
}
