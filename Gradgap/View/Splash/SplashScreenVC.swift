//
//  SplashScreenVC.swift
//  Gradgap
//
//  Created by iMac on 15/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class SplashScreenVC: UIViewController {

    @IBOutlet weak var logoVerticleConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoBackView: UIView!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logoVerticleConstraint.constant = 250//(SCREEN.HEIGHT/2) - 150
    }
    
    func configUI()  {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.animatedView), userInfo: nil, repeats: true)
        
        logoBackView.alpha = 0
    }

    @objc func animatedView() {
        logoVerticleConstraint.constant = logoVerticleConstraint.constant - 1.5
        if logoBackView.alpha <= 1 {
            logoBackView.alpha = logoBackView.alpha + 0.005
        }
        print(logoVerticleConstraint.constant)
        if logoVerticleConstraint.constant < 0 {
            self.logoBackView.alpha = 1
            timer.invalidate()
            logoBackView.sainiShake()
            delay(0.3) {
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
}
