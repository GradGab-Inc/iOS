//
//  ForgotPasswordVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    
    private var ForgotPasswordVM: ResendVerificcationViewModel = ResendVerificcationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - configUI
    private func configUI() {
        ForgotPasswordVM.delegate = self
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        guard let email = emailTxt.text else {
           return
        }
        if email.trimmed.count == 0 {
            displayToast("Kindly enter your email")
        }
        else if !isValidEmail(testStr: email) {
            displayToast("Kindly enter valid your email")
        }
        else {
            let forgotPasswordrequest = ResendVerificationRequest(email: email, requestType: 2)
            ForgotPasswordVM.resendVerification(request: forgotPasswordrequest)
        }
    }
    
    deinit {
        log.success("ForgotPasswordVC Memory deallocated!")/
    }
}


//MARK: - Service Response
extension ForgotPasswordVC : ResendVerificcationSuccessDelegate {
    func didReceivedData(message: String) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
        vc.fromSignup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
