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
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
//        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeMentorVC") as! BecomeMentorVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        AppDelegate().sharedDelegate().navigateToDashBoard()
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
