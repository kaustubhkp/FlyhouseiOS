//
//  AppDelegate.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabIndex:Int! = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.black
        if UserDefaults.standard.bool(forKey: "isUserVerified"){
            //self.createMenuView()
            self.setHomeToRootViewController()
        }
        
        //self.APICheckVersionCall()
        
        // 1. Configure Firebase in the app
        Analytics.setAnalyticsCollectionEnabled(false)
        FirebaseApp.configure()
                
        // 2. Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }

        // 3. Set the FCM delegate to handle incoming messages
        Messaging.messaging().delegate = self

        return true
    }
    
    // 4. Handle device token for push notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.description)
        Messaging.messaging().apnsToken = deviceToken
    }

    // 5. Handle errors for remote notification registration
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       // self.APICheckVersionCall()
        self.APIGetAllUrls()
    }
    
    func APICheckVersionCall(){
        
        let appCurrentVersion = UIApplication.getVersion
        let urlStr = String(format: "%@/UserDevice/CheckAppVersion?userAppVersion=%@", APIUrl.baseUrl,appCurrentVersion)
        
        APILogin.shared.checkAppVersion(urlStr: urlStr) { response in
            
            if response.result == "success"{
                
//                if response.data == false{
//                    
//                    let updateVC = AppUpdatePopupVC.storyboardViewController()
//                    updateVC.updateString = response.description!
//                    let navigationController = UINavigationController(rootViewController: updateVC)
//                    navigationController.isNavigationBarHidden = true
//                    appDelegate.window?.rootViewController = navigationController
//                }
            }
        } fail: { error in
            
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: (self.window?.currentController)!) { OkAction in
                
            }
        }
    }
    
    func setMainController(){
        
        self.window?.rootViewController = nil
        let rootVC = IntroductionVC.storyboardViewController()
        let navigationController = UINavigationController.init(rootViewController: rootVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func APIGetAllUrls(){
        
        let urlStr = String(format: "%@/UserDevice/GetAllAppUrls", APIUrl.baseUrl)
        APILogin.shared.getAppAllUrls(urlStr: urlStr) { response in
            //
            if response.result == "success"{
                if response.data != nil{
                    let resultData = response.data!
                    CommonFunction.setAPIUrlsSettingsAndVersion(data: resultData)
                }
            }
        } fail: { error in
            print("Error:\(error.localizedDescription)")
        }
    }
    
 
    
    func setHomeToRootViewController(){
        
        let mainViewController  = HomeTabBarVC.storyboardViewController()
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        self.window?.rootViewController = nil
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setMyTripTabWithIndex(atIndex:Int,optionIndex:Int){
        
        let mainViewController  = HomeTabBarVC.storyboardViewController()
        mainViewController.selectedIndex = atIndex
        self.tabIndex = optionIndex
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        // Hide the navigation bar to remove extra top space
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = nil
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setTabBarRootViewControllerOnTabIndex(tabIndex:Int){
        
        let mainViewController  = HomeTabBarVC.storyboardViewController()
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        self.window?.rootViewController = nil
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    

    func createMenuView() {
        
        let leftViewController = LeftMenuViewController.storyboardViewController()
        let mainViewController  = HomeTabBarVC.storyboardViewController()
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        leftViewController.mainViewController = navigationController
        let aObjNavigationController = UINavigationController.init(rootViewController: leftViewController)
        
        let slideMenuController = SlideMenuController(mainViewController:navigationController, leftMenuViewController: aObjNavigationController)
        
        let width = UIScreen.main.bounds.size.width - 100
        slideMenuController.changeLeftViewWidth(width)
        
        self.window?.rootViewController = nil
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func createNewRequestView() {
        
        let leftViewController = LeftMenuViewController.storyboardViewController()
        let mainViewController  = RequestVC.storyboardViewController()
        mainViewController.isNewRequest = true
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        leftViewController.mainViewController = navigationController
        let aObjNavigationController = UINavigationController.init(rootViewController: leftViewController)
        
        let slideMenuController = SlideMenuController(mainViewController:navigationController, leftMenuViewController: aObjNavigationController)
        
        let width = UIScreen.main.bounds.size.width - 100
        slideMenuController.changeLeftViewWidth(width)
        
        self.window?.rootViewController = nil
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    // Called when the app receives a push notification while the app is in the foreground
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token: \(fcmToken ?? "")")
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmTokenStr")
        UserDefaults.standard.synchronize()
        // You can now send the FCM token to your server to send push notifications
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification received when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification even when the app is in the foreground
        completionHandler([.alert, .badge, .sound])
    }

    // Handle user interaction with the notification (e.g., tapping the notification)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Process the notification
        print("User tapped the notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
