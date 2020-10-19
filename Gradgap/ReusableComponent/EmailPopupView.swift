//
//  EmailPopupView.swift
//  Gradgap
//
//  Created by iMac on 10/17/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

protocol emailPopUpDelegate {
    func getemailPopUp(_ selectedData : SocialLoginRequest)
}

@available(iOS 13.0, *)
class EmailPopupView : UIView {
    
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var submitBtn: Button!
    
    var delegate : emailPopUpDelegate?
    var appleCredential : ASAuthorization!
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("EmailPopupView", owner: self, options: nil)![0] as! UIView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delay(1.0) {
            self.setUp()
        }
    }
    
    
    func setUp() {
       
    }
    
    
    //MARK: - Button Click
    @IBAction func clickToremoveView(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        guard let email = emailTxt.text else { return }
        
        if email == "" {
            displayToast("Please enter email")
        }
        else {
            guard let appleIDCredential = appleCredential!.credential as? ASAuthorizationAppleIDCredential else { return }
            
            let userId = appleIDCredential.user
            let socialToken = String(decoding: appleIDCredential.identityToken ?? Data(), as: UTF8.self)
            
            var fname = ""
            if let temp = appleIDCredential.fullName?.givenName {
                fname = temp
            }
            
            var lname = ""
            if let temp = appleIDCredential.fullName?.familyName {
                lname = temp
            }
            
            let socialRequest = SocialLoginRequest(socialToken: socialToken, socialIdentifier: SocialType.apple.rawValue, firstName: fname, lastName: lname, socialId: userId, email: email, fcmToken: getPushToken(), device: "iOS")
            
            delegate?.getemailPopUp(socialRequest)
                        
        }
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    
}
