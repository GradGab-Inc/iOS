//
//  AppDelegate.swift
//  Gradgap
//
//  Created by Rohit Saini on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import MFSideMenu


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var container : MFSideMenuContainerViewController = MFSideMenuContainerViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        if isUserLogin() {
            if getLoginUserData() != nil {
                AppModel.shared.currentUser = UserDataModel.init()
                AppModel.shared.currentUser = getLoginUserData()!
                print(AppModel.shared.currentUser)
                
//                AppDelegate().sharedDelegate().navigateToMentorDashBoard()
                
                if AppModel.shared.currentUser.user?.userType == 1 {
                    AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
                }
                else if AppModel.shared.currentUser.user?.userType == 2 {
                    AppDelegate().sharedDelegate().navigateToMentorDashBoard()
                }
                else if AppModel.shared.currentUser.user?.userType == 3 {
                    continueToLogout()
                    navigateToLogin()
                }
            }
        }
        else {
            AppModel.shared.currentUser = UserDataModel.init()
            navigateToLogin()
        }
        
        
        return true
    }

    
    //MARK:- Share Appdelegate
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- Loader
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = AppColor
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }

    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }

    //MARK:- Navigation
    func navigateToLogin() {
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectLoginVCNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    func navigateToWhoYouAre() {
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectWhoYouAreVCNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    // MARK:- Navigate To Dashboard
    func navigateToMenteeDashBoard()
    {
        let rootVC: MFSideMenuContainerViewController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        container = rootVC
        var navController: UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DashboardVCNav") as! UINavigationController
        if #available(iOS 9.0, *) {
            let vc : HomeVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            
            let leftSideMenuVC: UIViewController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SideMenuContentVC")
            container.menuWidth = 300
            container.panMode = MFSideMenuPanModeSideMenu
            container.menuSlideAnimationEnabled = false
            container.leftMenuViewController = leftSideMenuVC
            container.centerViewController = navController
            
            container.view.layer.masksToBounds = false
            container.view.layer.shadowOffset = CGSize(width: 10, height: 10)
            container.view.layer.shadowOpacity = 0.5
            container.view.layer.shadowRadius = 5
            container.view.layer.shadowColor = UIColor.black.cgColor
            
            let rootNavigatioVC : UINavigationController = self.window?.rootViewController
                as! UINavigationController
            rootNavigatioVC.pushViewController(container, animated: false)
        }
    }
    
    func navigateToMentorDashBoard()
    {
        let rootVC: MFSideMenuContainerViewController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        container = rootVC
        var navController: UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorDashboardNavVC") as! UINavigationController
        if #available(iOS 9.0, *) {
            let vc : MentorHomeVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorHomeVC") as! MentorHomeVC
            navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            
            let leftSideMenuVC: UIViewController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SideMenuContentVC")
            container.menuWidth = 300
            container.panMode = MFSideMenuPanModeSideMenu
            container.menuSlideAnimationEnabled = false
            container.leftMenuViewController = leftSideMenuVC
            container.centerViewController = navController
            
            container.view.layer.masksToBounds = false
            container.view.layer.shadowOffset = CGSize(width: 10, height: 10)
            container.view.layer.shadowOpacity = 0.5
            container.view.layer.shadowRadius = 5
            container.view.layer.shadowColor = UIColor.black.cgColor
            
            let rootNavigatioVC : UINavigationController = self.window?.rootViewController
                as! UINavigationController
            rootNavigatioVC.pushViewController(container, animated: false)
        }
    }
    
    func continueToLogout() {
        removeUserDefaultValues()
        AppModel.shared.resetAllModel()
        self.navigateToLogin()
    }
    
    //MARK:- AppDelegate Method
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


