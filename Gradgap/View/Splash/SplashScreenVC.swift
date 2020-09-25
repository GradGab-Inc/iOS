//
//  SplashScreenVC.swift
//  Gradgap
//
//  Created by iMac on 15/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

    @IBOutlet weak var logoVerticleConstraint: NSLayoutConstraint!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    func configUI()  {
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.animatedView), userInfo: nil, repeats: true)
    }

    @objc func animatedView() {
        logoVerticleConstraint.constant = logoVerticleConstraint.constant - 0.5
        if logoVerticleConstraint.constant < -90 {
            timer.invalidate()
            
            if isUserLogin() {
                if getLoginUserData() != nil {
                    AppModel.shared.currentUser = UserDataModel.init()
                    AppModel.shared.currentUser = getLoginUserData()!
                    print(AppModel.shared.currentUser)
    
                    if AppModel.shared.currentUser.user?.userType == 1 {
                        AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
                    }
                    else if AppModel.shared.currentUser.user?.userType == 2 {
                        AppDelegate().sharedDelegate().navigateToMentorDashBoard()
                    }
                    else if AppModel.shared.currentUser.user?.userType == 3 {
                        AppDelegate().sharedDelegate().navigateToLogin()
                    }
    
                    AppDelegate().sharedDelegate().getAboutUsData()
                }
                else {
                    AppModel.shared.currentUser = UserDataModel.init()
                    AppDelegate().sharedDelegate().navigateToLogin()
                }
            }
            else {
                AppModel.shared.currentUser = UserDataModel.init()
                AppDelegate().sharedDelegate().navigateToLogin()
            }
        }
    }
}
