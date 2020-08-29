//
//  LoginVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import GoogleSignIn

class LoginVC: SocialLogin {

    private var loginVM: LoginViewModel = LoginViewModel()
    
    //OUTLETS
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
       

    //MARK: - configUI
    private func configUI() {
        loginVM.delegate = self
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
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        guard let email = emailTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        let device = AppModel.shared.device
        
        if email == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your email")
        }
        else if !isValidEmail(testStr: email) {
            displayToast("Kindly enter valid email")
        }
        else if password == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your password")
        }
        else {
            let loginRequest = LoginRequest(email: email, password: password, device: device, fcmToken: getPushToken())
            loginVM.loginUser(loginRequest: loginRequest)
        }
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
    
    deinit {
        log.success("LoginVC Memory deallocated!")/
    }
    
}

//MARK: - LoginDelegate
extension LoginVC: LoginDelegate {
    func didRecieveLoginResponse(response: LoginResponse) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        setLoginUserData(response.data!.self)
        setIsUserLogin(isUserLogin: true)
        setIsSocialUser(isUserLogin: false)
        AppModel.shared.currentUser = response.data
        
        if AppModel.shared.currentUser.user?.userType == 1 {
            AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
        }
        else if AppModel.shared.currentUser.user?.userType == 2 {
            AppDelegate().sharedDelegate().navigateToMentorDashBoard()
        }
        else if AppModel.shared.currentUser.user?.userType == 3 {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeMentorVC") as! BecomeMentorVC
            self.navigationController?.pushViewController(vc, animated: true)
        }        
    }
}
