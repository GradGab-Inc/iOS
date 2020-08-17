//
//  LoginVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class LoginVC: UIViewController {

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
        guard let email = emailTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        let device = AppModel.shared.device
        let fcmToken = AppModel.shared.fcmToken
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
            let loginRequest = LoginRequest(email: email, password: password, device: device, fcmToken: fcmToken)
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
extension LoginVC: LoginDelegate{
    func didRecieveLoginResponse(response: LoginResponse) {
        log.success(response.message)/
        AppModel.shared.currentUser = response.data?.user
        AppModel.shared.token = response.data!.accessToken
        UserDefaults.standard.set(response.data?.accessToken, forKey: UserDefaultKeys.token)
        UserDefaults.standard.set(encodable: response.data?.user, forKey: UserDefaultKeys.currentUser)
        AppDelegate().sharedDelegate().navigateToDashBoard()
    }
}
