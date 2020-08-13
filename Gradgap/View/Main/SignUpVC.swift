//
//  SignUpVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTxt: TextField!
    @IBOutlet weak var lastNameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var contactNumberTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    @IBOutlet weak var confirmPasswordTxt: TextField!
 
    
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
     
     @IBAction func clickToShowConfirmPassword(_ sender: UIButton) {
         if sender.isSelected {
             sender.isSelected = false
             confirmPasswordTxt.isSecureTextEntry = true
         }
         else {
             sender.isSelected = true
             confirmPasswordTxt.isSecureTextEntry = false
         }
     }
    
    @IBAction func clickToSignUp(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
        vc.fromSignup = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    deinit {
        log.success("SignUpVC Memory deallocated!")/
    }
}
