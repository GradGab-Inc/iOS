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
    @IBOutlet weak var termsLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    

    //MARK: - configUI
    private func configUI() {
        signUpVM.delegate = self
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor.red]
        
        let attributedString1 = NSMutableAttributedString(string: "By Signing Up , you agree to our ", attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Terms & Conditions ", attributes: attrs2)
        let attributedString3 = NSMutableAttributedString(string: "and ", attributes: attrs1)
        let attributedString4 = NSMutableAttributedString(string: "Privacy Policy.", attributes: attrs2)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        termsLbl.attributedText = attributedString1
        
        termsLbl.isUserInteractionEnabled = true
        termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = "By Signing Up , you agree to our Terms & Conditions and Privacy Policy."
        let termsRange = (text as NSString).range(of: "Terms & Conditions ")
        let privacyRange = (text as NSString).range(of: "Privacy Policy.")

        if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsRange) {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: privacyRange) {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.type = 2
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Tapped none")
        }
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
            let signUpRequest = SignUpRequest(firstName: firstName, lastName: lastName, email: email, password: password, contactCode: "+91", contactNumber: contactNumber, device: device, fcmToken: getPushToken())
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


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
