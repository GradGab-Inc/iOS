//
//  SocialLogin.swift
//  E-Auction
//
//  Created by iMac on 01/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import SainiUtils
import AuthenticationServices

//Gmail account : support@gradgab.com
//Facebook account : hello@gradgab.com


class SocialLogin: UIViewController, GIDSignInDelegate {

    let fbLoginManager = LoginManager()
    private var socialLoginVM: SocialLoginViewModel = SocialLoginViewModel()
    var isFromLogin : Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        socialLoginVM.delegate = self
    }
    
    //MARK: - Facebook Login
    func loginWithFacebook() {
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: AppDelegate().sharedDelegate().window?.rootViewController) { (result, error) in
            if let error = error {
                showAlert("Error", message: error.localizedDescription, completion: {})
                return
            }
            guard let token = result?.token else {
                return
            }
            guard let accessToken : String = token.tokenString else {
                return
            }
            
            let request : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name, last_name, gender"])
            
            let connection : GraphRequestConnection = GraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) in
                
                if result != nil
                {
                    let dict = result as! [String : AnyObject]
                    guard let userId = dict["id"] as? String else { return }
                    guard let email = dict["email"] as? String else {
                        displayToast("Kindly provide the access of your email to \(self.isFromLogin ? "Login" : "Signup")")
                        return
                    }
                    
                    var fname = ""
                    if let temp = dict["first_name"] as? String {
                        fname = temp
                    }
                    
                    var lname = ""
                    if let temp = dict["last_name"] as? String {
                        lname = temp
                    }
                    
                    let socialRequest = SocialLoginRequest(socialToken: accessToken, socialIdentifier: SocialType.facebook.rawValue, firstName: fname, lastName: lname, socialId: userId, email: email, fcmToken: getPushToken(), device: "iOS")
                    
                    log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
                    self.socialLoginVM.socialLogin(request: socialRequest)
                }
            })
            connection.start()
        }
    }
    
    //MARK: - GoogleLogin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            log.error("The user has not signed in before or they have since signed out.")/
          } else {
            log.error("\(Log.stats()) \(error)")/
          }
          return
        }
         
        guard let token = user.authentication.idToken  else { return }
        guard let userId = user.userID else { return }
        guard let email = user.profile.email else {
            displayToast("Kindly provide the access of your email to \(self.isFromLogin ? "Login" : "Signup")")
            return
        }

        var fname = ""
        if let temp = user.profile.givenName {
            fname = temp
        }
        
        var lname = ""
        if let temp = user.profile.familyName {
            lname = temp
        }
        
        let socialRequest = SocialLoginRequest(socialToken: token, socialIdentifier: SocialType.google.rawValue, firstName: fname, lastName: lname, socialId: userId, email: email, fcmToken: getPushToken(), device: "iOS")
        
        log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
        socialLoginVM.socialLogin(request: socialRequest)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        log.error("\(Log.stats()) \(error!)")/
    }
    
    
   //Apple login
   @objc func actionHandleAppleSignin() {
       if #available(iOS 13.0, *) {
           let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
           let authorizationRequest = authorizationAppleIDProvider.createRequest()
           authorizationRequest.requestedScopes = [.fullName, .email]

           let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationRequest])
           authorizationController.presentationContextProvider = self
           authorizationController.delegate = self
           authorizationController.performRequests()
       } else {
           // Fallback on earlier versions
       }
   }
}

extension SocialLogin : SocialLoginSuccessDelegate {
    func didReceivedSocialLoginData(userData: LoginResponse) {
        self.view.endEditing(true)
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        setLoginUserData(userData.data!.self)
        setIsUserLogin(isUserLogin: true)
        setIsSocialUser(isUserLogin: false)
        AppModel.shared.currentUser = userData.data
        
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


@available(iOS 13.0, *)
extension SocialLogin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

     // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.endEditing(true)
        log.error("\(Log.stats()) \(error)")/
    }

    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        self.view.endEditing(true)
        let userId = appleIDCredential.user
        let socialToken = String(decoding: appleIDCredential.identityToken ?? Data(), as: UTF8.self)
        
        guard let email = appleIDCredential.email else {
            displayToast("Kindly provide the access of your email to \(self.isFromLogin ? "Login" : "Signup")")
            return
        }
        var fname = ""
        if let temp = appleIDCredential.fullName?.givenName {
            fname = temp
        }
        
        var lname = ""
        if let temp = appleIDCredential.fullName?.familyName {
            lname = temp
        }
        
        let socialRequest = SocialLoginRequest(socialToken: socialToken, socialIdentifier: SocialType.apple.rawValue, firstName: fname, lastName: lname, socialId: userId, email: email, fcmToken: getPushToken(), device: "iOS")
        
        log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
        socialLoginVM.socialLogin(request: socialRequest)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
