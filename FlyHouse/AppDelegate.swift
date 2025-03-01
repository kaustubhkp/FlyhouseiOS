//
//  AppDelegate.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabIndex:Int! = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        if UserDefaults.standard.bool(forKey: "isUserVerified"){
            //self.createMenuView()
            self.setHomeToRootViewController()
        }
        
        //self.APICheckVersionCall()
        return true
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

