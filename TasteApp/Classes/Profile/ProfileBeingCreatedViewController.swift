//
//  ProfileBeingCreatedViewController.swift
//  TasteApp
//
//  Created by Shubhank on 21/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftGifOrigin


class ProfileBeingCreatedViewController: UIViewController,CLLocationManagerDelegate {
    
    var userData = [[String:Any]]()
    
    var splashScreen : String = ""
    var timer: Timer?
    var cuisines = [[String:Any]]()
    var latValue : Double = 0.0
    var longValue : Double = 0.0
    var locationManager:CLLocationManager?
    var isRecommendation = true
    var n = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mparameters = ["keyword":"Ranjit"] as [String : Any]
        DataManager.sharedManager.checkDummy(params: mparameters) { (responseObj) in
            
            if let dataDic = responseObj as? NSDictionary{
                var resltArr = NSDictionary()
                resltArr = dataDic
                print(resltArr)
            }
        }
        
        
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
            
            
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
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true
        {
            self.setupView()
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
        //manager?.startListening()
        
        DispatchQueue.global().async {
            self.NotificationCountMethod()
            
            DispatchQueue.main.async(execute: {
                
            })
        }
    }
    func NotificationCountMethod() {
        
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
        //let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":K_CURRENT_USER.login_Id] as [String : Any]
        print("the parameter is : \(parameters)")
        
        DataManager.sharedManager.getNotificationCount(params: parameters) { (response) in
            
            
            
            if let dataDic = response as?  NSDictionary
                
            {
                let val_count = dataDic["count"] as! NSNumber
                print("BBB",val_count)
                K_INNERUSER_DATA.notificationCount = Int(val_count)
                 //MARK: FOR REMOVING BADGE FOR TEMPORARY  ADDED BY RANJIT 8 FEB
               // UIApplication.shared.applicationIconBadgeNumber = K_INNERUSER_DATA.notificationCount
            }
            DispatchQueue.main.async {
                
            }
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stop()
    }
    
    func setupView() {
        
        print("currrent bank id is that \(K_CURRENT_USER.bank_id)")
        
        self.view.backgroundColor = UIColor.white
        let logoImageView = UIImageView()
        logoImageView.image = UIImage.gif(name: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(120)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(590 * 0.5)//490
            make.height.equalTo(680 * 0.5)//580
            
            //            make.centerX.equalTo(self.view)
            //            make.centerY.equalTo(self.view)
        }
        
        
        
        
        
        
        let label = UILabel()
        label.text = "Updating \( K_CURRENT_USER.name.capitalized)'s Dining Profile"
        label.numberOfLines = 3
        label.font = UIFont(name:K_Font_Color, size: 30)
        label.textAlignment = .center
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.centerY.equalTo(self.view).offset(-20)
        }
        // label.font = UIFont(name:  K_Font_Color, size: 23)
        
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named:"ic-refresh")
        self.view.addSubview(loadingImageView)
        loadingImageView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(label.snp.bottom).offset(30)
        }
        
        
        
        
        
        
        // label.font = UIFont(name:  K_Font_Color, size: 23)
        
        
        
        // delayWithSeconds(1.5) {
        //            UIView.animate(withDuration: 2.4)
        //            {
        //                loadingImageView.transform = CGAffineTransform.init(rotationAngle:CGFloat(M_PI))
        //            }
        
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .curveEaseOut], animations: {
            loadingImageView.transform = CGAffineTransform.init(rotationAngle:CGFloat(M_PI))
        }, completion: nil)
        
        //self.loginApiHitToCheckCount()
        
        // self.loadData() //comment
        self.scheduledTimerWithTimeInterval()//add
        
        
        //}
    }
    
    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleMyFunction), userInfo: nil, repeats: true)
    }
    
    func stop() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    
    func handleMyFunction() {
        n += 1
        if n >= 3{
            self.stop()
            //self.loadExploreData() added by ranjit 17
            
            self.loadData()
        }
        else{
            self.getTransactionCount()
        }
        
        
    }
    //    func checkNetworkConnection{
    //
    //    }
    func scheduledTimerWithTimeInterval(){
        n += 1
        self.getTransactionCount()
        
        self.start()
    }
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
        
        // print(K_CURRENT_USER.login_Id)
        let parameter=["user_id":K_CURRENT_USER.login_Id] as [String : Any]
        print(parameter)
        DataManager.sharedManager.bankTransactionCount(params: parameter) { (response) in
            if let dataDic = response as? [String: Any]  {
                var transactionCount = 0
                var bankCount = 0
                if let count = dataDic["transaction_count"] as? Int{
                    transactionCount = count
                }
                if let count = dataDic["bank_count"] as? Int{
                    bankCount = count
                }
                if transactionCount > 0 {
                    self.stop()
                    self.locationManager?.startUpdatingLocation()
                    
                    
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
            }
        }
        
        
        
    }
    
    // MARK: GET THE LIST RECOMMENDATION FROM ADMIN PANEL
    func getAdminRecommendation(){
        
        let singelton = SharedManager.sharedInstance
        let latitude = singelton.latValueInitial
        let longitude = singelton.longValueInitial
        let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"refresh":singelton.refeshRecommendation,"miles":K_CURRENT_USER.selected_miles] as [String : Any]
        print(parameters)
        if Reachability.isConnectedToNetwork() == true
        {
            DataManager.sharedManager.getAdminRecommendation(params: parameters) { (responseObj) in
                print(responseObj)
                if let dataDic = responseObj as? [String:Any]{
                    print(dataDic)
                    self.cuisines = dataDic["data"] as! [[String : Any]]
                    
                    //                    let str = String.localizedStringWithFormat("%@", dataDic["user_selected_miles"] as! CVarArg)
                    //                    print(str)
                    //                    K_CURRENT_USER.selected_miles = str
                    print(self.cuisines)
                    
                    self.getRecommendation()
                    
                    //                    if singelton.refeshRecommendation == "no"{
                    //                        let nc = NotificationCenter.default
                    //                        let myNotification = Notification.Name(rawValue:"NotificationRecommendation")
                    //                        nc.post(name:myNotification,
                    //                                object: nil,
                    //                                userInfo:["message":self.cuisines])
                    //                    }
                    //                    else{
                    //                        self.loadData()
                    //                    }
                }
                else{
                    self.getRecommendation()
                }
            }
            
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
        
        
    }
    
    // MARK: GET THE R RECOMMENDATION
    func getRecommendation() {
        
        let singelton = SharedManager.sharedInstance
        let latitude = singelton.latValueInitial
        let longitude = singelton.longValueInitial
      
        let parameters = ["user_id":singelton.loginId,"lat":latitude,"long":longitude,"refresh":singelton.refeshRecommendation,"miles":K_CURRENT_USER.selected_miles] as [String : Any]
        // let parameters = ["user_id":singelton.loginId,"lat":"40.7127","long":"-74.005941"] as [String : Any]
        // print(parameters)
        if Reachability.isConnectedToNetwork() == true
        {
            DataManager.sharedManager.getRecommendation(params: parameters) { (responseObj) in
                print(responseObj)
                if let dataDic = responseObj as? [String:Any]{
                    print(dataDic)
                    // self.cuisines = dataDic["data"] as! [[String : Any]]
                    
                    let recData = dataDic["data"] as! [[String : Any]]
                    for recDict in recData{
                        self.cuisines.append(recDict)
                    }
                    let str = String.localizedStringWithFormat("%@", dataDic["user_selected_miles"] as! CVarArg)
                    print(str)
                    K_CURRENT_USER.selected_miles = str
                    print(self.cuisines)
                    
                    if singelton.refeshRecommendation == "no"{
                        let nc = NotificationCenter.default
                        let myNotification = Notification.Name(rawValue:"NotificationRecommendation")
                        nc.post(name:myNotification,
                                object: nil,
                                userInfo:["message":self.cuisines])
                    }
                    else{
                        self.loadData()
                    }
                    
                    
                    
                }
                else{
                    if Reachability.isConnectedToNetwork() != true
                    {
                        let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            self.loadData()
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
                            self.loadData()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                    }
                }
                
                
            }
            
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
    }
    
    //MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placeMarks, error) in
            if error == nil {
                if (placeMarks?.count)! > 0 {
                    let pm = placeMarks![0] as! CLPlacemark
                    print(pm.locality)
                    self.latValue = (self.locationManager?.location?.coordinate.latitude)!
                    self.longValue = (self.locationManager?.location?.coordinate.longitude)!
                    
                    
                    let singelton = SharedManager.sharedInstance
                    print(singelton.latValueInitial,singelton.longValueInitial)
                    let coordinate1 = CLLocation(latitude: self.latValue, longitude: self.longValue)
                    let coordinate2 = CLLocation(latitude: singelton.latValueInitial, longitude: singelton.longValueInitial)
                    
                    let distanceInMeters = coordinate1.distance(from: coordinate2)
                    let finaldist =  distanceInMeters / 1609.344
                    if(distanceInMeters <= 1609)
                    {
                        // under 1 mile
                        if self.isRecommendation{
                            self.isRecommendation = false
                            singelton.latValueInitial = self.latValue
                            singelton.longValueInitial = self.longValue
                            print(singelton.latValueInitial,singelton.longValueInitial)
                            // self.getRecommendation()
                            self.getAdminRecommendation()
                        }
                        
                    }
                    else
                    {
                        // out of 1 mile
                        singelton.latValueInitial = self.latValue
                        singelton.longValueInitial = self.longValue
                        print(singelton.latValueInitial,singelton.longValueInitial)
                        // print(singelton.latValueInitial,singelton.longValueInitial)
                        // self.locationManager?.stopUpdatingLocation()
                        
                        //self.getRecommendation()
                        self.getAdminRecommendation()
                        self.isRecommendation = false
                        
                        
                    }
                    
                    
                    
                }
            }
        }
        
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    // MARK: GET THE NOTIFICATION COUNT TO SHOW AS BADGES
    
    func loginApiHitToCheckCount()
    {
        
        
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
        
        // DataManager.sharedManager.bankCount(params: ["user_id" :UserDefaults.standard.string(forKey:"user_id")! ]) { (response) in
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        DataManager.sharedManager.bankCount(params: ["user_id" : singelton.loginId]) { (response) in
            
            
            if let dataDic = response as? [String:Any]
            {
                self.loginApiHitToCheckDeviceToken()
                let bankCount = dataDic["count"] as! Int
                print("bank Count is \(bankCount)")
                /*let defaults = UserDefaults.standard
                 defaults.set(bankCount, forKey: "bankcount")
                 defaults.synchronize()*/
                
            }
            else
            {
                let alert = UIAlertController(title: "Taste", message:"Server Error.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func loginApiHitToCheckDeviceToken()
    {
        let singelton = SharedManager.sharedInstance
        let deviceToken = singelton.deviceToken
        var params = ["is_linkedin_user":"true",
                      "linkedin_key":K_CURRENT_USER.user_id,
                      "firstname": K_CURRENT_USER.name,
                      "lastname":K_CURRENT_USER.lname,
                      "email":K_CURRENT_USER.email,
                      "profile_type" :"public",
                      "has_device_key" : "true",
                      "device_os"  : "ios",
                      "deviceuid" : deviceToken,
                      "device_name" : UIDevice.current.name] as [String : Any]
        DataManager.sharedManager.login(params: params , completion: { (response) in
            
            
            if let dataDic = response as? [[String:Any]]
            {
                print(dataDic)
                self.loadData()
                
            }
        })
    }
    
    func loadExploreData()
    {
        delayWithSeconds(2.0) {
            //            let tabController = UITabBarController()
            //            // let vc = ExploreRecommendationController()
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "ExploreTabViewController")
            //            let navVC = UINavigationController(rootViewController: vc)
            //            navVC.isNavigationBarHidden = true
            //            let vc2 = ProfileViewController()
            //            let navVC2 = UINavigationController(rootViewController: vc2)
            //            navVC2.isNavigationBarHidden = true
            //            vc2.cuisines = self.cuisines
            //            let vc3 = InnerCircleAddedViewController()
            //            let navVC3 = UINavigationController(rootViewController: vc3)
            //            navVC3.isNavigationBarHidden = true
            //            tabController.viewControllers = [navVC,navVC2, navVC3]
            //            tabController.tabBar.barStyle = .black
            //            //tabController.tabBar.items?[0].selectedImage = UIImage(named: "tab_profile")
            //            let image = UIImage(named: "tab_search")?.withRenderingMode(.alwaysOriginal)
            //            let image2 = UIImage(named: "homeTaste")?.withRenderingMode(.alwaysOriginal)
            //            let image3 = UIImage(named: "tab_user_group")?.withRenderingMode(.alwaysOriginal)
            //
            //            tabController.tabBar.items?[0].image = image
            //            tabController.tabBar.items?[1].image = image2
            //            tabController.tabBar.items?[2].image = image3
            //
            //            tabController.tabBar.items?[0].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            //            tabController.tabBar.items?[1].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            //            tabController.tabBar.items?[2].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            //
            //            tabController.selectedIndex = 0
            //            // tabController.tabBar.items![0].isEnabled = false
            //
            //            self.present(tabController, animated: true, completion: nil)
        }}
    
    // MARK: LOAD THE TAB BAR VIEW CONTROLLER
    func loadData()
    {
        delayWithSeconds(2.0) {
            let tabController = UITabBarController()
            //            let vc = ExploreRecommendationController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExploreTabViewController")
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            let vc2 = ProfileViewController()
            let navVC2 = UINavigationController(rootViewController: vc2)
            navVC2.isNavigationBarHidden = true
            vc2.cuisines = self.cuisines
            let vc3 = InnerCircleAddedViewController()
            let navVC3 = UINavigationController(rootViewController: vc3)
            navVC3.isNavigationBarHidden = true
            tabController.viewControllers = [navVC2]
            tabController.tabBar.barStyle = .black
            
            // MARK: -  TERPORARILY WE HAVE STOPPED INNER CIRCLE AND EXPLORE SCREEN
            
            //tabController.tabBar.items?[0].selectedImage = UIImage(named: "tab_profile")
            // let image = UIImage(named: "tab_search")?.withRenderingMode(.alwaysOriginal)
            let image2 = UIImage(named: "homeTaste")?.withRenderingMode(.alwaysOriginal)
            // let image3 = UIImage(named: "tab_user_group")?.withRenderingMode(.alwaysOriginal)
            
            //  tabController.tabBar.items?[0].image = image
            tabController.tabBar.items?[0].image = image2
            // tabController.tabBar.items?[2].image = image3
            
            // tabController.tabBar.items?[0].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            tabController.tabBar.items?[0].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            // tabController.tabBar.items?[2].imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            
            tabController.selectedIndex = 1
            // tabController.tabBar.items![0].isEnabled = false
            
            self.present(tabController, animated: true, completion: nil)
        }}}





