//
//  LoginVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
       

    //MARK: - configUI
    private func configUI() {
           
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFacebook(_ sender: Any) {
        
    }
    
    @IBAction func clickToApple(_ sender: Any) {
        
    }
    
    @IBAction func clickToGoogle(_ sender: Any) {
        
    }
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        
    }
    
    @IBAction func clickToShowShowPassword(_ sender: UIButton) {
         if sender.isSelected {
             sender.isSelected = false
             passwordTxt.isSecureTextEntry = true
         }
         else {
             sender.isSelected = true
             passwordTxt.isSecureTextEntry = false
         }
     }
    

}
