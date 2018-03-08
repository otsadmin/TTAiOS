//
//  ViewController.swift
//  TasteApp
//
//  Created by Shubhank on 31/01/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    var isUserLoggedIn = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupView()
    }
    
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(330 * 0.5)
            make.height.equalTo(400 * 0.5)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-40)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "T  A  S  T  E"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 38)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
        }
        
        
        delayWithSeconds(1) {
            self.showNormalLogin()
            
            //self.showProfileTabDirect()
        }
    }
    
    func getUserProfileData() {
        // getting path to Data.plist
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("data.plist")
        
        let fileManager = FileManager.default
        
        //check if file exists
        if(!fileManager.fileExists(atPath: path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            
            if let bundlePath = Bundle.main.path(forResource: "data", ofType:"plist" )
                
            {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                // print("Bundle data.plist file is --> \(resultDictionary?.description)")
                
                do
                {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                    // print("copy")
                }
                catch _
                {
                    // print("error failed loading data")
                }
            }
            else
            {
                // print(" data.plis not found. Please, make sure it is part of the bundle.")
            }
        }
        else
        {
            print(" data.plis already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        //  print("Loaded data.plist file is --> \(resultDictionary?.description)")
        let myDict = NSDictionary(contentsOfFile: path)
        
        if let dict = myDict {
            //  print(dict)
            if let email = dict.object(forKey: "email") as? String{
                
                K_CURRENT_USER.name = dict.object(forKey: "firstName")! as! String
                K_CURRENT_USER.lname = dict.object(forKey: "lastName")! as! String
                K_CURRENT_USER.company = dict.object(forKey: "companyName")! as! String
                K_CURRENT_USER.designation = dict.object(forKey: "designation")! as! String
                K_CURRENT_USER.email = dict.object(forKey: "email")! as! String
                K_CURRENT_USER.user_id =  dict.object(forKey: "linkedinId")! as! String
                K_CURRENT_USER.login_Id = dict.object(forKey: "userId")! as! String
                K_CURRENT_USER.image_url = dict.object(forKey: "imageUrl")! as! String
                K_CURRENT_USER.selected_miles = dict.object(forKey: "selected_miles")! as! String
                
                let singelton = SharedManager.sharedInstance
                singelton.loginId = K_CURRENT_USER.login_Id
                isUserLoggedIn = true
                
            }
            else{
                isUserLoggedIn = false
            }
            //loading values
            
            
        }
        else
        {  isUserLoggedIn = false
            print("WARNING: Couldn't create dictionary from data.plist! Default values will be used!")
        }
        if isUserLoggedIn{
            self.getTransactionCount()
        }
        else{
            let vc = LoginViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            self.present(navVC, animated: true, completion: nil)
            
        }
    }
    
    
    func showNormalLogin()
    {
        //code commented
        /*  if(UserDefaults.standard .bool(forKey: "isLinkedin"))
         {
         
         print("current user issss  \(UserDefaults.standard.string(forKey: "name")!)")
         //  print("current user id is  \(UserDefaults.standard.string(forKey: "user_id")!)")
         //  print(UserDefaults.standard.string(forKey:"user_id")!)
         print("current user name  \(UserDefaults.standard.string(forKey: "name")!)")
         print("current user lname  \(UserDefaults.standard.string(forKey: "lastname")!)")
         print("current user email  \(UserDefaults.standard.string(forKey: "email")!)")
         print("current user linkedin  \(UserDefaults.standard.string(forKey: "linkedin_id")!)")
         print("current user company  \(UserDefaults.standard.string(forKey: "company")!)")
         
         K_CURRENT_USER.name = UserDefaults.standard.string(forKey: "name")!
         K_CURRENT_USER.designation = UserDefaults.standard.string(forKey: "title")!
         
         if ((UserDefaults.standard.string(forKey: "company")) == nil)
         {
         K_CURRENT_USER.company = "Art Director at Appetizer Mobile"
         }
         else
         {
         K_CURRENT_USER.company = UserDefaults.standard.string(forKey: "company")!
         }
         
         
         print("current user title is  \(UserDefaults.standard.string(forKey: "title")!)")
         K_CURRENT_USER.lname = UserDefaults.standard.string(forKey: "lastname")!
         K_CURRENT_USER.email = UserDefaults.standard.string(forKey: "email")!
         K_CURRENT_USER.user_id = UserDefaults.standard.string(forKey: "linkedin_id")!
         K_CURRENT_USER.login_Id = UserDefaults.standard.string(forKey: "user_id")!
         
         
         
         if ((UserDefaults.standard.string(forKey: "imageUrl")) == nil)
         {
         
         K_CURRENT_USER.image_url = "http://www.iaimhealthcare.com/images/doctor/no-image.jpg"
         }
         
         else
         {
         K_CURRENT_USER.image_url = UserDefaults.standard.string(forKey: "imageUrl")!
         }
         
         if ((UserDefaults.standard.string(forKey: "bankcount")) != nil)
         
         {
         
         K_USER_DATA.bankCount = UserDefaults.standard.string(forKey: "bankcount")!
         print("bank count in splash screen is \(K_USER_DATA.bankCount)")
         
         let count:Int =  Int(K_USER_DATA.bankCount)!
         
         if (count > 0)
         {
         let vc = ProfileBeingCreatedViewController()
         vc.splashScreen = "yes"
         let navVC = UINavigationController(rootViewController: vc)
         navVC.isNavigationBarHidden = true
         self.present(navVC, animated: true, completion: nil)
         }
         else
         {
         let vc = BanksListViewController()
         let navVC = UINavigationController(rootViewController: vc)
         navVC.isNavigationBarHidden = true
         self.present(navVC, animated: true, completion: nil)
         
         }
         
         }
         
         else
         {
         let vc = BanksListViewController()
         let navVC = UINavigationController(rootViewController: vc)
         navVC.isNavigationBarHidden = true
         self.present(navVC, animated: true, completion: nil)
         }
         
         
         }
         else
         
         {
         let vc = LoginViewController()
         let navVC = UINavigationController(rootViewController: vc)
         navVC.isNavigationBarHidden = true
         self.present(navVC, animated: true, completion: nil)
         }
         */
        //let singelton = SharedManager.sharedInstance
        
        // if LISDKSessionManager.hasValidSession()
        // {
        
        self.getUserProfileData()
        //            if isUserLoggedIn{
        //                self.getTransactionCount()
        //            }
        //            else{
        //                let vc = LoginViewController()
        //                let navVC = UINavigationController(rootViewController: vc)
        //                navVC.isNavigationBarHidden = true
        //                self.present(navVC, animated: true, completion: nil)
        //
        //            }
        
        // }
        //        else
        //
        //        {
        //            let vc = LoginViewController()
        //            let navVC = UINavigationController(rootViewController: vc)
        //            navVC.isNavigationBarHidden = true
        //            self.present(navVC, animated: true, completion: nil)
        //        }
        
        
        
        
    }
    //    func getTransactionCount() {
    //       // print(K_CURRENT_USER.user_id)
    //        let singelton = SharedManager.sharedInstance
    //        //singelton.loginId = K_CURRENT_USER.login_Id
    //        let parameter=["user_id":singelton.loginId] as [String : Any]
    //        DataManager.sharedManager.bankTransactionCount(params: parameter) { (response) in
    //            if let count = response as? Int
    //            {  if  count > 0
    //             {
    //
    //                let vc = ProfileBeingCreatedViewController()
    //                vc.splashScreen = "yes"
    //                let navVC = UINavigationController(rootViewController: vc)
    //                navVC.isNavigationBarHidden = true
    //                self.present(navVC, animated: true, completion: nil)
    //
    //            }
    //            else{
    //                let vc = ProfileBeingCreatedViewController()
    //                vc.splashScreen = "yes"
    //                let navVC = UINavigationController(rootViewController: vc)
    //                navVC.isNavigationBarHidden = true
    //                self.present(navVC, animated: true, completion: nil)
    //                }
    //            }
    //
    //        }
    //
    //    }
    func getTransactionCount() {
        
        if Reachability.isConnectedToNetwork() == true
        {
            // print("Internet Connection Available!")
        }
        else
        {
            
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        print(K_CURRENT_USER.login_Id)
        let parameter=["user_id":K_CURRENT_USER.login_Id] as [String : Any]
         print("first",parameter)
        DataManager.sharedManager.bankTransactionCount(params: parameter) { (response) in
            if let dataDic = response as? [String: Any]    {
                var transactionCount = 0
                var bankCount = 0
                if let count = dataDic["transaction_count"] as? Int{
                    transactionCount = count
                }
                if let count = dataDic["bank_count"] as? Int{
                    bankCount = count
                }
                
                if transactionCount > 0 || bankCount > 0 {
                    let vc = ProfileBeingCreatedViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isNavigationBarHidden = true
                    self.present(navVC, animated: true, completion: nil)
                }
                else{
                    let vc = BanksListViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isNavigationBarHidden = true
                    self.present(navVC, animated: true, completion: nil)
                }
                
            }
            else{
                if Reachability.isConnectedToNetwork() != true
                {
                    let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else{
                    let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return

                }
            }
        }
    }
    func showProfileTabDirect() {
        
        //close it for setting changes
        let vc = ProfileViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        self.present(navVC, animated: true, completion: nil)
        
        //close it for setting changes
        
        //        let vc = SettingViewController()
        //        let navVC = UINavigationController(rootViewController: vc)
        //        navVC.isNavigationBarHidden = true
        //        self.present(navVC, animated: true, completion: nil)
        
        //        let vc = ProfileBeingCreatedViewController()
        //        let tabController = UITabBarController()
        //
        //        let navVC = UINavigationController(rootViewController: vc)
        //        navVC.isNavigationBarHidden = true
        //
        //
        //
        //        let vc2 = InnerCircleViewController()
        //        let navVC2 = UINavigationController(rootViewController: vc2)
        //        navVC2.isNavigationBarHidden = true
        //        tabController.viewControllers = [navVC,navVC2]
        //
        //
        //        tabController.tabBar.barStyle = .black
        //        //tabController.tabBar.items?[0].selectedImage = UIImage(named: "tab_profile")
        //        let image = UIImage(named: "tab_profile")?.withRenderingMode(.alwaysOriginal)
        //        let image2 = UIImage(named: "tab_download")?.withRenderingMode(.alwaysOriginal)
        //
        //        tabController.tabBar.items?[0].image = image
        //        tabController.tabBar.items?[1].image = image2
        //
        //        self.present(tabController, animated: true, completion: nil)
    }
}

