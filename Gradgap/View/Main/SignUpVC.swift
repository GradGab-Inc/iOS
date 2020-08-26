//
//  SignUpVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import GoogleSignIn

class SignUpVC: SocialLogin {
    
    private var signUpVM: SignUpViewModel = SignUpViewModel()

    //OUTLETS
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
        signUpVM.delegate = self
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFacebook(_ sender: Any) {
        self.view.endEditing(true)
        loginWithFacebook()
    }
    
    @IBAction func clickToApple(_ sender: Any) {
        self.view.endEditing(true)
        actionHandleAppleSignin()
    }
    
    @IBAction func clickToGoogle(_ sender: Any) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().signIn()
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
        self.view.endEditing(true)
        guard let firstName = firstNameTxt.text else { return }
        guard let lastName = lastNameTxt.text else { return }
        guard let email = emailTxt.text else { return }
        guard let contactNumber = contactNumberTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        guard let confirmPassword = confirmPasswordTxt.text else { return }
        let fcmToken = AppModel.shared.fcmToken
        let device = AppModel.shared.device
        
        if firstName == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your First Name")
        }
        else if lastName == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your Last Name")
        }
        else if email == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your email")
        }
        else if !isValidEmail(testStr: email) {
            displayToast("Kindly enter valid email")
        }
        else if password == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your password")
        }
        else if confirmPassword == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your confirmed password")
        }
        else if password != confirmPassword {
            displayToast("Password doesn't match")
        }
        else {
            let signUpRequest = SignUpRequest(firstName: firstName, lastName: lastName, email: email, password: password, contactCode: "+91", contactNumber: contactNumber, device: device, fcmToken: fcmToken)
            signUpVM.createUser(signUpRequest: signUpRequest)
        }
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        self.view.endEditing(true)
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    deinit {
        log.success("SignUpVC Memory deallocated!")/
    }
}

//MARK: - SignUpDelegate
extension SignUpVC: SignUpDelegate {
    func didRecieveSignUpResponse(response: SuccessModel) {
        log.success(response.message)/
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
        vc.fromSignup = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
