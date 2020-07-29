//
//  SignUpVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import ActiveLabel

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTxt: TextField!
    @IBOutlet weak var lastNameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var contactNumberTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    @IBOutlet weak var confirmPasswordTxt: TextField!
    @IBOutlet var termsLbl: ActiveLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    

    //MARK: - configUI
    private func configUI() {
        setUpActiveLabel()
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
        
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpActiveLabel()  {
        let tearmsType = ActiveType.custom(pattern: "\\sTerms & Conditions\\b") //Looks for "Terms & Conditions"
        let privacyType = ActiveType.custom(pattern: "\\sPrivacy Policy\\b") //Looks for "Privacy Policy"
        
        termsLbl.enabledTypes.append(tearmsType)
        termsLbl.enabledTypes.append(privacyType)
        
        termsLbl.customize { label in
            termsLbl.text = "By Signing Up, you agree to our Terms & Conditions and Privacy Policy."
            termsLbl.numberOfLines = 0
            termsLbl.lineSpacing = 2
  //        termsLbl.font = UIFont(name: SFUI_MEDIUM, size: 12.0)
            termsLbl.textColor = WhiteColor
            termsLbl.mentionColor = RedColor
            
            termsLbl.handleMentionTap { self.clickToTeamsPolicy("Mention", message: $0) }
            
            //Custom types
            termsLbl.customColor[tearmsType] = RedColor
            termsLbl.customColor[privacyType] = RedColor
            
            termsLbl.handleCustomTap(for: tearmsType) { self.clickToTeamsPolicy("Custom type", message: $0) }
            termsLbl.handleCustomTap(for: privacyType) { self.clickToTeamsPolicy("Custom type", message: $0) }
        }
    }
    
    func clickToTeamsPolicy(_ title: String, message: String) {
        if message == "Terms & Conditions"
        {
            print("Terms & Conditions")
        }
        else if message == "Privacy Policy"
        {
            print("Privacy Policy")
        }
    }
    
}
