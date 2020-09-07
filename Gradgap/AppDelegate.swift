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
import FBSDKLoginKit
import GoogleSignIn
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var container : MFSideMenuContainerViewController = MFSideMenuContainerViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 4.0)
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //Push Notification
        registerPushNotification(application)
        
        //Facebook Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google Login
        GIDSignIn.sharedInstance().clientID = CLIENT_ID
        
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
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
        activityLoader.color = WhiteColor
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

    
  //MARK:- Notification
    func registerPushNotification(_ application: UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
             
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Notification registered")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
     
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
         
        // Print full message.
        print(userInfo)
    }
     
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        // This notification is not auth related, developer should handle it.
         
        completionHandler(UIBackgroundFetchResult.newData)
//         NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CHAT_NOTIFICATION.UPDATE_MESSAGE_BADGE), object: nil)
    }
    
    func getFCMToken() -> String
    {
        let newToken = Messaging.messaging().fcmToken!
        setPushToken(newToken)
        return newToken
    }

}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if getPushToken() == ""
        {
            setPushToken(fcmToken)
            print(fcmToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //print("Received data message: \(remoteMessage.appData)")
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

// MARK:- Push Notification
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .inactive
        {
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(delayForNotification(tempTimer:)), userInfo: userInfo, repeats: false)
        }
        else
        {
            notificationHandler(userInfo as! [String : Any])
        }
        
        completionHandler()
    }
    
    @objc func delayForNotification(tempTimer:Timer)
    {
        notificationHandler(tempTimer.userInfo as! [String : Any])
    }
    
    //Redirect to screen
    func notificationHandler(_ dict : [String : Any])
    {
        printData(dict)
        if !isUserLogin() {
            return
        }
                
//        if let type : String = dict["refType"] as? String, let itemRef : String = dict["itemRef"] as? String {
//            if type == String(NotifiacetionStatusType.Outbid.rawValue) || type == String(NotifiacetionStatusType.Won.rawValue) || type == String(NotifiacetionStatusType.Lost.rawValue) || type == String(NotifiacetionStatusType.Delivered.rawValue) {
//                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex":0])
//                delay(1.0) {
//                    let item : [String : String] = ["itemRef":itemRef]
//                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.NOTIFICATION_TAB_CLICK), object: item)
//                }
//            } else if type == String(NotifiacetionStatusType.Private.rawValue) {
//                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex":0])
//                delay(1.0) {
//                    let item : [String : String] = ["itemRef":itemRef]
//                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.PRIVATE_AUCTION_CLICK), object: item)
//                }
//            }
//        }
    }
}

