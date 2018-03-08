//
//  AppDelegate.swift
//  TasteApp
//
//  Created by Shubhank on 31/01/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import CoreData
import INSPersistentContainer
import UserNotifications
import IQKeyboardManager
import SwipeCellKit

import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Fabric
import Crashlytics
import Firebase
import Mixpanel

typealias NSPersistentContainer         = INSPersistentContainer
typealias NSPersistentStoreDescription  = INSPersistentStoreDescription

extension UIViewController {
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,UIAlertViewDelegate
{
    
    var checkForNotification:String = ""
    var friendRequestID : String = ""
    var userRequestID : String = ""
    // let APIKEY: String="AIzaSyDhuh3e94Hx2mJB4DlVM9lDqNtc__kmw5s"//for google review
    enum Actions:String{
        case increment = "INCREMENT_ACTION"
        case decrement = "DECREMENT_ACTION"
        
    }
    var categoryID:String {
        get{
            return "COUNTER_CATEGORY"
        }
    }
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // UIApplication.shared.beginIgnoringInteractionEvents()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().disabledToolbarClasses.add(InnerCircleViewController.self)
        IQKeyboardManager.shared().disabledToolbarClasses.add(InnerCircleAddedViewController.self)
        IQKeyboardManager.shared().disabledToolbarClasses.add(BanksListViewController.self)
        IQKeyboardManager.shared().disabledToolbarClasses.add(ExploreTabViewController.self)
        IQKeyboardManager.shared().disabledToolbarClasses.add(ExploreMapViewController.self)
        GMSPlacesClient.provideAPIKey(GOOGLE_APIKEY)
        // GMSServices.provideAPIKey(APIKEY)
        GMSServices.provideAPIKey(GOOGLE_APIKEY)
        let singelton = SharedManager.sharedInstance
        singelton.refeshRecommendation = "yes"
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        //TODO: FOR REMOVING BADGE FOR TEMPORARY
         UIApplication.shared.applicationIconBadgeNumber = 0
        
        //TODO: FOR REMOVING BADGE COUNT AFTER REINSTALL
        if !UserDefaults.standard.bool(forKey: "is_first_time"){
            
            application.cancelAllLocalNotifications()
            // Restart the Local Notifications list
            application.applicationIconBadgeNumber = 0
            UserDefaults.standard.set(true, forKey: "is_first_time")
        }
        
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"is_first_time"])
//        {
//            [application cancelAllLocalNotifications];
//            // Restart the Local Notifications list
//            application.applicationIconBadgeNumber = 0;
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"is_first_time"];  }
        
        //MARK:
        
        //TODO: For crashlytics
              Fabric.with([Crashlytics.self])
        
        //TODO: for firebase crashlytics
        FirebaseApp.configure()
        
        //TODO: MixPnel Integration
        // Mixpanel.initialize(token: "MIXPANEL_TOKEN")
        let mixpanel = Mixpanel.sharedInstance(withToken: "a872b0049ad20ad055a92553969b3956");
        print(mixpanel)
        
        //MARK: 
        
        return true
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //application.applicationIconBadgeNumber = 5
        // UIApplication.shared.applicationIconBadgeNumber = 1
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        
        print("APNs device token: \(deviceTokenString)")
        
        // UserDefaults.standard.set(deviceTokenString, forKey: "devicetoken")
        let singelton = SharedManager.sharedInstance
        singelton.deviceToken = deviceTokenString
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func showHome()->Void{
        //        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //        SWRevealViewController *navVC = [storyBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        //        // UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:navVC];
        //        self.window.rootViewController = navVC;
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        //        self.window?.rootViewController = vc
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
        
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print(userInfo)
        let notificationName = Notification.Name("NotificationIdentifier")
        
        // Register to receive notification
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
        
        print("Recived: \(userInfo)")
        if let aps = userInfo["aps"] as? NSDictionary
        {
            if let extra = aps["extra_data"]  as? NSDictionary
            {
                if let type = extra["type"] as? NSString
                {
                    if type == "rate_last_transaction"// check for the notification type and put the code according to that
                    {
                        print("Push notification received: \(userInfo)")
                        
                        let state = UIApplication.shared.applicationState
                        
                        if state == .background
                        {
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    if let extra = aps["extra_data"]  as? NSDictionary
                                    {
                                        print("extra is \(extra)")
                                        if let user_Id = extra["user_obj"] as? NSString
                                        {
                                            print("User Id is \(user_Id)")
                                            let singelton = SharedManager.sharedInstance
                                            singelton.loginId = user_Id as String
                                            
                                            if let factualId = extra["factual_id"] as? NSString
                                            {
                                                K_INNERUSER_DATA.FactualId = factualId as String
                                                
                                                DispatchQueue.main.async(execute:
                                                    {
                                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                        let apptVC = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
                                                        apptVC.NotificationObj = "FromNotification"
                                                        apptVC.notify_user_id = (extra["notify_id"] as! NSString) as String
                                                        if let userId = extra["notify_user_id"]{
                                                            apptVC.recieveUserId = userId as! String
                                                        }
                                                        if let restoName = extra["restaurentName"]{
                                                            apptVC.resto_Name = restoName as! String
                                                        }else{
                                                            apptVC.resto_Name = ""
                                                        }
                                                        let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                        UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(aObjNavi, animated: true, completion: nil)
                                                        
                                                        
                                                        //run krke dekh le .. crash hua to whatsapp pe ping kriyo yaha minimise kr rha hoon main
                                                        
                                                        //                                                    let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                        //
                                                        //                                                    alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                        //
                                                        //                                                        print("Handle accept logic here")
                                                        //
                                                        //                                                        self.acceptInvitationRequest(status: "Approved")
                                                        //
                                                        //
                                                        //
                                                        //                                                    }))
                                                        
                                                        //
                                                        //                                                    alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                        //
                                                        //                                                        print("Handle Reject Logic here")
                                                        //
                                                        //                                                        self.acceptInvitationRequest(status: "Reject")
                                                        //
                                                        //                                                    }))
                                                        
                                                        
                                                        // show alert
                                                        //                                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                        //                                                    alertWindow.rootViewController = UIViewController()
                                                        //                                                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                        //                                                    alertWindow.makeKeyAndVisible()
                                                        //                                                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                        
                                                })
                                            }
                                        }
                                    }
                                    
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                        }//close background
                        else if state == .active {
                            
                            // foreground
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    if let title = alert["body"] as? NSString
                                    {
                                        
                                        //                        if title.contains("Friend request approved")
                                        //                        {
                                        
                                        if let extra = aps["extra_data"]  as? NSDictionary
                                        {
                                            if let user_Id = extra["factual_id"] as? NSString
                                            {
                                                print("User Id is \(user_Id)")
                                                let singelton = SharedManager.sharedInstance
                                                singelton.loginId = user_Id as String
                                                
                                                if let factualId = extra["factual_id"] as? NSString
                                                {
                                                    K_INNERUSER_DATA.FactualId = factualId as String
                                                    
                                                    DispatchQueue.main.async(execute:
                                                        {
                                                            
                                                            let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                            
                                                            
                                                            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
                                                                
                                                                print("Handle accept logic here")
                                                                
                                                                //   self.acceptInvitationRequest(status: "Approved")
                                                                
                                                                
                                                                
                                                            }))
                                                            
                                                            
                                                            //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                            //
                                                            //                                                    print("Handle Reject Logic here")
                                                            //
                                                            //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                                            //
                                                            //                                                }))
                                                            
                                                            
                                                            
                                                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                            alertWindow.rootViewController = UIViewController()
                                                            alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                            alertWindow.makeKeyAndVisible()
                                                            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                            
                                                    })
                                                }
                                            }
                                            
                                        }
                                        //      }
                                        //                        if title.contains("Friend request reject"){
                                        //                            print("yessssssssssss")
                                        //
                                        //                            if let extra = aps["extra_data"]  as? NSDictionary
                                        //                            {
                                        //                                print("extra is \(extra)")
                                        //
                                        //                                if let friendId = extra["user_id"] as? NSString
                                        //                                {
                                        //
                                        //                                    friendRequestID = friendId as String
                                        //
                                        //                                    if let actionUserId = extra["action_user_id"] as? NSString
                                        //                                    {
                                        //                                        userRequestID = actionUserId as String
                                        //
                                        //                                        DispatchQueue.main.async(execute:
                                        //                                            {
                                        //
                                        //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                        //
                                        //
                                        //                                                alert.addAction(UIAlertAction(title: "ok", style:.default, handler: { (action: UIAlertAction!) in
                                        //
                                        //                                                    print("Handle accept logic here")
                                        //
                                        //                                                    //   self.acceptInvitationRequest(status: "Approved")
                                        //
                                        //
                                        //
                                        //                                                }))
                                        //
                                        //
                                        //                                                //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                        //                                                //
                                        //                                                //                                                    print("Handle Reject Logic here")
                                        //                                                //
                                        //                                                //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                        //                                                //
                                        //                                                //                                                }))
                                        //
                                        //
                                        //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                        //                                                alertWindow.rootViewController = UIViewController()
                                        //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                        //                                                alertWindow.makeKeyAndVisible()
                                        //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                        //
                                        //                                        })
                                        //                                    }
                                        //                                }//Friend close
                                        //
                                        //                            }
                                        //                        }
                                        
                                    }
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                        }
                        else if state == .inactive{
                            
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    
                                    if let extra = aps["extra_data"]  as? NSDictionary
                                    {
                                        print("extra is \(extra)")
                                        
                                        let user_Id_dict = extra["user_obj"] as? NSDictionary
                                        if let user_Id = user_Id_dict?["$id"] as? NSString
                                        {
                                            print("User Id is \(user_Id)")
                                            let singelton = SharedManager.sharedInstance
                                            singelton.loginId = user_Id as String
                                            
                                            
                                            if let factualId = extra["factual_id"] as? NSString
                                            {
                                                K_INNERUSER_DATA.FactualId = factualId as String
                                                
                                                DispatchQueue.main.async(execute:
                                                    {
                                                        K_INNERUSER_DATA.requestStatus = ""
                                                        //let controller =  RatingViewController()
                                                        // controller.userObjectId = self.friendRequestID
                                                        // controller.friendId = actionUserId as String
                                                        // controller.NotificationObj = "FromNotification"
                                                        
                                                        //UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(controller, animated: true, completion: nil)
                                                        
                                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                        let apptVC = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
                                                        apptVC.NotificationObj = "FromNotification"
                                                        apptVC.notify_user_id = (extra["notify_id"] as! NSString) as String
                                                        if let userId = extra["notify_user_id"]{
                                                            apptVC.recieveUserId = userId as! String
                                                        }
                                                        if let restoName = extra["restaurentName"]{
                                                            apptVC.resto_Name = restoName as! String
                                                        }else{
                                                            apptVC.resto_Name = ""
                                                        }

                                                        let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                        
                                                        //                                                                self.window?.rootViewController = apptVC
                                                        //                                                                self.window?.makeKeyAndVisible()
                                                        
                                                        UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(aObjNavi, animated: true, completion: nil)
                                                        
                                                        //                                                let vc = NotificationsUserProfileViewController()
                                                        //                                                                               if let window = self.window, let rootViewController = window.rootViewController {
                                                        //                                                        var currentController = rootViewController
                                                        //                                                        while let presentedController = currentController.presentedViewController {
                                                        //                                                            currentController = presentedController
                                                        //                                                        }
                                                        //
                                                        //                                                        currentController.present(vc, animated: true, completion: nil)
                                                        //                                                    }
                                                        //  }
                                                        
                                                        
                                                        //                                                let vc = NotificationsUserProfileViewController()
                                                        //                                                let navVC = UINavigationController(rootViewController: vc)
                                                        //                                                navVC.isNavigationBarHidden = true
                                                        //                                                //                                                    self.window?.present(navVC, animated: true, completion: nil)
                                                        //
                                                        //                                                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                                                        
                                                        
                                                        
                                                        
                                                        //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                        //
                                                        //
                                                        //                                                alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                        //
                                                        //                                                    print("Handle accept logic here")
                                                        //
                                                        //                                                    self.acceptInvitationRequest(status: "Approved")
                                                        //
                                                        //
                                                        //
                                                        //                                                }))
                                                        
                                                        
                                                        //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                        //
                                                        //                                                    print("Handle Reject Logic here")
                                                        //
                                                        //                                                    self.acceptInvitationRequest(status: "Reject")
                                                        //
                                                        //                                                }))
                                                        
                                                        
                                                        // show alert
                                                        //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                        //                                                alertWindow.rootViewController = UIViewController()
                                                        //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                        //                                                alertWindow.makeKeyAndVisible()
                                                        //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                        
                                                })
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                            
                        }
                        
                        completionHandler(.newData)
                        
                    }
                    else if type == "bank_update"{
                        print("Push notification received: \(userInfo)")
                        
                        let state = UIApplication.shared.applicationState
                        
                        if state == .background
                        {
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    
                                    if let extra = aps["extra_data"]  as? NSDictionary
                                    {
                                        print(
                                            
                                            "extra is \(extra)")
                                        if let user_Id = extra["user_obj"] as? NSString
                                        {
                                            print("User Id is \(user_Id)")
                                            
                                            let singelton = SharedManager.sharedInstance
                                            singelton.loginId = user_Id as String
                                            var notify_ID = ""
                                            if   let notifyId = extra["notify_id"] as? NSString{
                                                notify_ID = notifyId as String
                                            }
                                            
                                            //if let factualId = extra["factual_id"] as? NSString
                                            //{
                                            //   K_INNERUSER_DATA.FactualId = factualId as String
                                            
                                            DispatchQueue.main.async(execute:
                                                {
                                                    
                                                    
                                                    K_INNERUSER_DATA.requestStatus = ""
                                                    //let controller =  RatingViewController()
                                                    // controller.userObjectId = self.friendRequestID
                                                    // controller.friendId = actionUserId as String
                                                    // controller.NotificationObj = "FromNotification"
                                                    
                                                    //UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(controller, animated: true, completion: nil)
                                                    //                                                        if let providerId = extra["provider_id"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Provider_ID =  Int(providerId)!
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Provider_ID = 0
                                                    //                                                        }
                                                    //                                                        if let providerAccountId = extra["provider_account_id"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Provider_Account_ID =  Int(providerAccountId)!
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Provider_Account_ID = 0
                                                    //                                                        }
                                                    //                                                        if let bankName = extra["bankName"] as? String{
                                                    //                                                            K_INNERUSER_DATA.BankName =  bankName
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.BankName = ""
                                                    //                                                        }
                                                    //                                                        if let bankLogo = extra["bankIcon"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Banklogo =  bankLogo
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Banklogo = ""
                                                    //                                                        }
                                                    let apptVC =  BankAccountViewController()
                                                    //apptVC.userId = user_Id as String
                                                    apptVC.NotificationObj = "FromNotification"
                                                    // let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                    //aObjNavi.isNavigationBarHidden = true
                                                   apptVC.NotificationID = notify_ID
                                                    UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(apptVC, animated: true, completion: nil)
                                                    
                                                    // let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                    // aObjNavi.isNavigationBarHidden = true
                                                    //                                                        UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(aObjNavi, animated: true, completion: nil)
                                                    
                                                    
                                                    
                                                    //run krke dekh le .. crash hua to whatsapp pe ping kriyo yaha minimise kr rha hoon main
                                                    
                                                    //                                                    let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                    //
                                                    //                                                    alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                    //
                                                    //                                                        print("Handle accept logic here")
                                                    //
                                                    //                                                        self.acceptInvitationRequest(status: "Approved")
                                                    //
                                                    //
                                                    //
                                                    //                                                    }))
                                                    
                                                    //
                                                    //                                                    alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    //
                                                    //                                                        print("Handle Reject Logic here")
                                                    //
                                                    //                                                        self.acceptInvitationRequest(status: "Reject")
                                                    //
                                                    //                                                    }))
                                                    
                                                    
                                                    // show alert
                                                    //                                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                    //                                                    alertWindow.rootViewController = UIViewController()
                                                    //                                                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                    //                                                    alertWindow.makeKeyAndVisible()
                                                    //                                                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                    
                                            })
                                        }
                                        //}
                                    }
                                    
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                        }//close background
                        else if state == .active {
                            
                            // foreground
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    if let title = alert["body"] as? NSString
                                    {
                                        
                                        //                        if title.contains("Friend request approved")
                                        //                        {
                                        
                                        if let extra = aps["extra_data"]  as? NSDictionary
                                        {
                                            // if let user_Id = extra["factual_id"] as? NSString
                                            // {
                                            //  print("User Id is \(user_Id)")
                                            //let singelton = SharedManager.sharedInstance
                                            //singelton.loginId = user_Id as String
                                            
                                            //  if let factualId = extra["factual_id"] as? NSString
                                            //  {
                                            //  K_INNERUSER_DATA.FactualId = factualId as String
                                            
                                            DispatchQueue.main.async(execute:
                                                {
                                                    
                                                    let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                    
                                                    
                                                    alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
                                                        
                                                        print("Handle accept logic here")
                                                        
                                                        //   self.acceptInvitationRequest(status: "Approved")
                                                        
                                                        
                                                        
                                                    }))
                                                    
                                                    
                                                    //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    //
                                                    //                                                    print("Handle Reject Logic here")
                                                    //
                                                    //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                                    //
                                                    //                                                }))
                                                    
                                                    
                                                    
                                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                    alertWindow.rootViewController = UIViewController()
                                                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                    alertWindow.makeKeyAndVisible()
                                                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                    
                                            })
                                            //}
                                            // }
                                            
                                        }
                                        //      }
                                        //                        if title.contains("Friend request reject"){
                                        //                            print("yessssssssssss")
                                        //
                                        //                            if let extra = aps["extra_data"]  as? NSDictionary
                                        //                            {
                                        //                                print("extra is \(extra)")
                                        //
                                        //                                if let friendId = extra["user_id"] as? NSString
                                        //                                {
                                        //
                                        //                                    friendRequestID = friendId as String
                                        //
                                        //                                    if let actionUserId = extra["action_user_id"] as? NSString
                                        //                                    {
                                        //                                        userRequestID = actionUserId as String
                                        //
                                        //                                        DispatchQueue.main.async(execute:
                                        //                                            {
                                        //
                                        //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                        //
                                        //
                                        //                                                alert.addAction(UIAlertAction(title: "ok", style:.default, handler: { (action: UIAlertAction!) in
                                        //
                                        //                                                    print("Handle accept logic here")
                                        //
                                        //                                                    //   self.acceptInvitationRequest(status: "Approved")
                                        //
                                        //
                                        //
                                        //                                                }))
                                        //
                                        //
                                        //                                                //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                        //                                                //
                                        //                                                //                                                    print("Handle Reject Logic here")
                                        //                                                //
                                        //                                                //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                        //                                                //
                                        //                                                //                                                }))
                                        //
                                        //
                                        //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                        //                                                alertWindow.rootViewController = UIViewController()
                                        //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                        //                                                alertWindow.makeKeyAndVisible()
                                        //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                        //
                                        //                                        })
                                        //                                    }
                                        //                                }//Friend close
                                        //
                                        //                            }
                                        //                        }
                                        
                                    }
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                        }
                        else if state == .inactive{
                            
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    
                                    if let extra = aps["extra_data"]  as? NSDictionary
                                    {
                                        print("extra is \(extra)")
                                        
                                        if let user_Id = extra["user_obj"] as? NSString
                                        {
                                            print("User Id is \(user_Id)")
                                            
                                            let singelton = SharedManager.sharedInstance
                                            singelton.loginId = user_Id as String
                                            var notify_ID = ""
                                            if   let notifyId = extra["notify_id"] as? NSString{
                                                notify_ID = notifyId as String
                                            }
                                            
                                            // if let factualId = extra["factual_id"] as? NSString
                                            //{
                                            //  K_INNERUSER_DATA.FactualId = factualId as String
                                            
                                            DispatchQueue.main.async(execute:
                                                {
                                                    K_INNERUSER_DATA.requestStatus = ""
                                                    //let controller =  RatingViewController()
                                                    // controller.userObjectId = self.friendRequestID
                                                    // controller.friendId = actionUserId as String
                                                    // controller.NotificationObj = "FromNotification"
                                                    
                                                    //UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(controller, animated: true, completion: nil)
                                                    //                                                        if let providerId = extra["provider_id"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Provider_ID =  Int(providerId)!
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Provider_ID = 0
                                                    //                                                        }
                                                    //                                                        if let providerAccountId = extra["provider_account_id"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Provider_Account_ID =  Int(providerAccountId)!
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Provider_Account_ID = 0
                                                    //                                                        }
                                                    //                                                        if let bankName = extra["bankName"] as? String{
                                                    //                                                            K_INNERUSER_DATA.BankName =  bankName
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.BankName = ""
                                                    //                                                        }
                                                    //                                                        if let bankLogo = extra["bankIcon"] as? String{
                                                    //                                                            K_INNERUSER_DATA.Banklogo =  bankLogo
                                                    //                                                        }
                                                    //                                                        else{
                                                    //                                                            K_INNERUSER_DATA.Banklogo = ""
                                                    //                                                        }
                                                    
                                                    
                                                    let apptVC =  BankAccountViewController()
                                                    apptVC.NotificationObj = "FromNotification"
                                                    if let str = extra["notify_id"]{
                                                        apptVC.notify_user_id = str as! String
                                                    }
                                                    if let userId = extra["notify_user_id"]{
                                                        apptVC.recieveUserId = userId as! String
                                                    }
                                                    let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                    aObjNavi.isNavigationBarHidden = true
                                                    apptVC.NotificationID = notify_ID
                                                    UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(aObjNavi, animated: true, completion: nil)
                                                    
                                                    
                                                    //                                                        controller.userObjectId = self.friendRequestID
                                                    //                                                        controller.friendId = actionUserId as String
                                                    
                                                    //                                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                    //                                                        let apptVC = storyboard.instantiateViewController(withIdentifier: "BankAccountViewController") as! BankAccountViewController
                                                    //                                                        apptVC.NotificationObj = "FromNotification"
                                                    //                                                        let aObjNavi = UINavigationController(rootViewController: apptVC)
                                                    
                                                    //                                                                self.window?.rootViewController = apptVC
                                                    //                                                                self.window?.makeKeyAndVisible()
                                                    
                                                    
                                                    
                                                    //                                                let vc = NotificationsUserProfileViewController()
                                                    //                                                                               if let window = self.window, let rootViewController = window.rootViewController {
                                                    //                                                        var currentController = rootViewController
                                                    //                                                        while let presentedController = currentController.presentedViewController {
                                                    //                                                            currentController = presentedController
                                                    //                                                        }
                                                    //
                                                    //                                                        currentController.present(vc, animated: true, completion: nil)
                                                    //                                                    }
                                                    //  }
                                                    
                                                    
                                                    //                                                let vc = NotificationsUserProfileViewController()
                                                    //                                                let navVC = UINavigationController(rootViewController: vc)
                                                    //                                                navVC.isNavigationBarHidden = true
                                                    //                                                //                                                    self.window?.present(navVC, animated: true, completion: nil)
                                                    //
                                                    //                                                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                                                    
                                                    
                                                    
                                                    
                                                    //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                    //
                                                    //
                                                    //                                                alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                    //
                                                    //                                                    print("Handle accept logic here")
                                                    //
                                                    //                                                    self.acceptInvitationRequest(status: "Approved")
                                                    //
                                                    //
                                                    //
                                                    //                                                }))
                                                    
                                                    
                                                    //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    //
                                                    //                                                    print("Handle Reject Logic here")
                                                    //
                                                    //                                                    self.acceptInvitationRequest(status: "Reject")
                                                    //
                                                    //                                                }))
                                                    
                                                    
                                                    // show alert
                                                    //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                    //                                                alertWindow.rootViewController = UIViewController()
                                                    //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                    //                                                alertWindow.makeKeyAndVisible()
                                                    //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                    
                                            })
                                            //}
                                        }
                                        
                                    }
                                    
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                            
                        }
                        
                        completionHandler(.newData)
                        
                    }
                    else
                    {
                        print("Push notification received: \(userInfo)")
                        
                        let state = UIApplication.shared.applicationState
                        
                        if state == .background
                        {
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    if let title = alert["title"] as? NSString
                                    {
                                        
                                        if title.contains("new friend")
                                        {
                                            print("yessssssssssss")
                                            
                                            if let extra = aps["extra_data"]  as? NSDictionary
                                            {
                                                print("extra is \(extra)")
                                                
                                                if let friendId = extra["user_id"] as? NSString
                                                {
                                                    
                                                    friendRequestID = friendId as String
                                                    
                                                    if let actionUserId = extra["action_user_id"] as? NSString
                                                    {
                                                        userRequestID = actionUserId as String
                                                        
                                                        DispatchQueue.main.async(execute:
                                                            {
                                                                let controller =  NotificationsUserProfileViewController()
                                                                UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(controller, animated: true, completion: nil)
                                                                
                                                                
                                                                //run krke dekh le .. crash hua to whatsapp pe ping kriyo yaha minimise kr rha hoon main
                                                                
                                                                //                                                    let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                                //
                                                                //                                                    alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                                //
                                                                //                                                        print("Handle accept logic here")
                                                                //
                                                                //                                                        self.acceptInvitationRequest(status: "Approved")
                                                                //
                                                                //
                                                                //
                                                                //                                                    }))
                                                                
                                                                //
                                                                //                                                    alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                //
                                                                //                                                        print("Handle Reject Logic here")
                                                                //
                                                                //                                                        self.acceptInvitationRequest(status: "Reject")
                                                                //
                                                                //                                                    }))
                                                                
                                                                
                                                                // show alert
                                                                //                                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                                //                                                    alertWindow.rootViewController = UIViewController()
                                                                //                                                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                                //                                                    alertWindow.makeKeyAndVisible()
                                                                //                                                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                                
                                                        })
                                                    }
                                                }//Friend close
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                        }//close background
                        else if state == .active {
                            
                            // foreground
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    if let title = alert["body"] as? NSString
                                    {
                                        
                                        //                        if title.contains("Friend request approved")
                                        //                        {
                                        print("yessssssssssss")
                                        
                                        if let extra = aps["extra_data"]  as? NSDictionary
                                        {
                                            //                                print("extra is \(extra)")
                                            
                                            if let friendId = extra["user_id"] as? NSString
                                            {
                                                
                                                friendRequestID = friendId as String
                                                
                                                if let actionUserId = extra["action_user_id"] as? NSString
                                                {
                                                    userRequestID = actionUserId as String
                                                    
                                                    DispatchQueue.main.async(execute:
                                                        {
                                                            
                                                            let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                            
                                                            
                                                            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
                                                                
                                                                print("Handle accept logic here")
                                                                
                                                                //   self.acceptInvitationRequest(status: "Approved")
                                                                
                                                                
                                                                
                                                            }))
                                                            
                                                            
                                                            //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                            //
                                                            //                                                    print("Handle Reject Logic here")
                                                            //
                                                            //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                                            //
                                                            //                                                }))
                                                            
                                                            
                                                            
                                                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                            alertWindow.rootViewController = UIViewController()
                                                            alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                            alertWindow.makeKeyAndVisible()
                                                            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                            
                                                    })
                                                }
                                            }//Friend close
                                            
                                        }
                                        //      }
                                        //                        if title.contains("Friend request reject"){
                                        //                            print("yessssssssssss")
                                        //
                                        //                            if let extra = aps["extra_data"]  as? NSDictionary
                                        //                            {
                                        //                                print("extra is \(extra)")
                                        //
                                        //                                if let friendId = extra["user_id"] as? NSString
                                        //                                {
                                        //
                                        //                                    friendRequestID = friendId as String
                                        //
                                        //                                    if let actionUserId = extra["action_user_id"] as? NSString
                                        //                                    {
                                        //                                        userRequestID = actionUserId as String
                                        //
                                        //                                        DispatchQueue.main.async(execute:
                                        //                                            {
                                        //
                                        //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                        //
                                        //
                                        //                                                alert.addAction(UIAlertAction(title: "ok", style:.default, handler: { (action: UIAlertAction!) in
                                        //
                                        //                                                    print("Handle accept logic here")
                                        //
                                        //                                                    //   self.acceptInvitationRequest(status: "Approved")
                                        //
                                        //
                                        //
                                        //                                                }))
                                        //
                                        //
                                        //                                                //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                        //                                                //
                                        //                                                //                                                    print("Handle Reject Logic here")
                                        //                                                //
                                        //                                                //                                                  //  self.acceptInvitationRequest(status: "Reject")
                                        //                                                //
                                        //                                                //                                                }))
                                        //
                                        //
                                        //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                        //                                                alertWindow.rootViewController = UIViewController()
                                        //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                        //                                                alertWindow.makeKeyAndVisible()
                                        //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                        //
                                        //                                        })
                                        //                                    }
                                        //                                }//Friend close
                                        //
                                        //                            }
                                        //                        }
                                        
                                    }
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                        }
                        else if state == .inactive{
                            
                            
                            // background
                            print("foreground herere is ")
                            
                            if let aps = userInfo["aps"] as? NSDictionary
                            {
                                print("aps is \(aps)")
                                if let alert = aps["alert"] as? NSDictionary
                                {
                                    print("alert is \(alert)")
                                    if let title = alert["title"] as? NSString
                                    {
                                        
                                        if title.contains("new friend")
                                        {
                                            print("yessssssssssss")
                                            
                                            if let extra = aps["extra_data"]  as? NSDictionary
                                            {
                                                print("extra is \(extra)")
                                                
                                                if let friendId = extra["user_id"] as? NSString
                                                {
                                                    
                                                    friendRequestID = friendId as String
                                                    
                                                    if let actionUserId = extra["action_user_id"] as? NSString
                                                    {
                                                        userRequestID = actionUserId as String
                                                        
                                                        DispatchQueue.main.async(execute:
                                                            {
                                                                K_INNERUSER_DATA.requestStatus = ""
                                                                let controller =  NotificationsUserProfileViewController()
                                                                controller.userObjectId = self.friendRequestID
                                                                controller.friendId = actionUserId as String
                                                                controller.NotificationObj = "FromNotification"
                                                                if let str = extra["notify_id"]{
                                                                    controller.notify_user_id = str as! String
                                                                }
                                                                if let userId = extra["notify_user_id"]{
                                                                    controller.recieveUserId = userId as! String
                                                                }

                                                                UIApplication.shared.delegate?.window??.rootViewController?.topMostViewController().present(controller, animated: true, completion: nil)
                                                                
                                                                //                                                let vc = NotificationsUserProfileViewController()
                                                                //                                                                               if let window = self.window, let rootViewController = window.rootViewController {
                                                                //                                                        var currentController = rootViewController
                                                                //                                                        while let presentedController = currentController.presentedViewController {
                                                                //                                                            currentController = presentedController
                                                                //                                                        }
                                                                //
                                                                //                                                        currentController.present(vc, animated: true, completion: nil)
                                                                //                                                    }
                                                                //  }
                                                                
                                                                
                                                                //                                                let vc = NotificationsUserProfileViewController()
                                                                //                                                let navVC = UINavigationController(rootViewController: vc)
                                                                //                                                navVC.isNavigationBarHidden = true
                                                                //                                                //                                                    self.window?.present(navVC, animated: true, completion: nil)
                                                                //
                                                                //                                                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                                                                
                                                                
                                                                
                                                                
                                                                //                                                let alert = UIAlertController(title: "Taste", message:title as String, preferredStyle: UIAlertControllerStyle.alert)
                                                                //
                                                                //
                                                                //                                                alert.addAction(UIAlertAction(title: "Accept", style:.default, handler: { (action: UIAlertAction!) in
                                                                //
                                                                //                                                    print("Handle accept logic here")
                                                                //
                                                                //                                                    self.acceptInvitationRequest(status: "Approved")
                                                                //
                                                                //
                                                                //
                                                                //                                                }))
                                                                
                                                                
                                                                //                                                alert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                //
                                                                //                                                    print("Handle Reject Logic here")
                                                                //
                                                                //                                                    self.acceptInvitationRequest(status: "Reject")
                                                                //
                                                                //                                                }))
                                                                
                                                                
                                                                // show alert
                                                                //                                                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                                                //                                                alertWindow.rootViewController = UIViewController()
                                                                //                                                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                                                //                                                alertWindow.makeKeyAndVisible()
                                                                //                                                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                                                                
                                                        })
                                                    }
                                                }//Friend close
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                else if let alert = userInfo["alert"] as? NSString
                                {
                                    print("he is come here \(alert)")
                                }
                            }
                            
                            
                            
                            
                        }
                        
                        completionHandler(.newData)
                        
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let data = notification.request.content.userInfo
        
        if let aps = data["aps"] as? NSDictionary
        {
            print("aps issssss \(aps)")
            if let alert = aps["alert"] as? NSString
            {
                print("alert is \(alert)")
                
            }
        }
        completionHandler([.alert, .badge, .sound])
    }
    
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
        // UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // self.saveContext()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if (LISDKCallbackHandler.shouldHandle(url)) {
            LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true;
    }
    
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     for notification: UILocalNotification,
                     completionHandler: @escaping () -> Void)
    {
        
        // Handle notification action *****************************************
        if notification.category == categoryID
        {
            
            let action:Actions = AppDelegate.Actions(rawValue: Actions.RawValue(identifier!)!)!
            print(action)
        }
        
        completionHandler()
    }
    
    
    //  func acceptInvitationRequest(status : NSString)
    //    {
    //         let singelton = SharedManager.sharedInstance
    //        //let parameter = ["user_id" :userRequestID,"friend_id":friendRequestID, "status":"Approved"]
    //        let userAction = status as String
    //        print(singelton.loginId, friendRequestID)
    //        let parameter = ["user_id" :singelton.loginId,"friend_id":userRequestID, "status":userAction]
    //       // print(singelton.loginId, userRequestID,userAction)
    //        print(parameter)
    //        DataManager.sharedManager.invitationAcceptApi(params: parameter) { (response) in
    //
    //
    //            if let message = response as? String
    //
    //            {
    //
    //                            print("message for invitation is \(message)")
    //                            let alert = UIAlertController(title: "Taste", message:message as String, preferredStyle: UIAlertControllerStyle.alert)
    //
    //
    //                            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
    //
    //                                print("Handle accept logic here")
    //
    //
    //                            }))
    //                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    //                            alertWindow.rootViewController = UIViewController()
    //                            alertWindow.windowLevel = UIWindowLevelAlert + 1;
    //                            alertWindow.makeKeyAndVisible()
    //                            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)            }//end here
    //           }
    //
    //        }
    
    
    
}

func rejectInvitationRequest()
{
    
    
    
}

// MARK: - Core Data stack

var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "TasteApp")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()



// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}





