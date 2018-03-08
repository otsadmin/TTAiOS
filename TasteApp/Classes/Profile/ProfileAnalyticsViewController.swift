//
//  ProfileAnalyticsViewController.swift
//  TasteApp
//
//  Created by Shubhank on 27/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class ProfileAnalyticsViewController: UIViewController {
    
    var cuisines = [[String:Any]]()
    var cities = [[String:Any]]()
     let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
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
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            
            
            print("Network Status Changed: \(status)")
            print("network reachable \(manager!.isReachable)")
            
            if manager!.isReachable != true
            {
                SVProgressHUD.dismiss()
            }
            else
            {
                //self.setupView()
               
                
            }
        }
         manager?.startListening()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true//code added
        super.viewWillDisappear(animated)
    }
 
    func goBack() {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false//code added
       // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"limit":"5","offset":""]
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":singelton.loginId,"limit":"5","offset":""]
        
        DataManager.sharedManager.getAnalytics(params: parameters) { (responseObj) in
         //  print(responseObj) // code comment
            if let dataDic = responseObj as? [String:Any] {
                if let cuisineArr = dataDic["cuisines"] as? [[String:Any]] {
                    self.cuisines = cuisineArr
                }
                
                else
                {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Taste", message:"",preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                   // NSLog("OK Pressed")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
                
                }
                if let citiesArr = dataDic["cities"] as? [[String:Any]] {
                    self.cities = citiesArr
                }
                
                self.loadData()
            }
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true //code added

        }
    }
    
    func loadData()
    {
        
        let titleLabel = UILabel()
        titleLabel.text = "MY TASTE"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
        }
//        let notifButton = UIButton(type: .custom)
//        notifButton.setImage(UIImage(named:"ic_notification_bell"), for: .normal)
//        self.view.addSubview(notifButton)
//        notifButton.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            // make.top.equalTo(18)  //APARNA CHANGED HERE
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
        
        //notifButton.addTarget(self, action: #selector(self.viewNotifications), for: .touchUpInside)
        
        
        let nameLabel = UILabel()
        nameLabel.text = "Jane Smith"
          nameLabel.numberOfLines = 2
        if (K_CURRENT_USER.name.characters.count > 0) {
            nameLabel.text = K_CURRENT_USER.name
        }
        nameLabel.font = UIFont(name:  K_Font_Color, size: 26.5)
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        nameLabel.textAlignment = .center
        
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
//        let settingsButton = UIButton(type: .custom)
//        settingsButton.setImage(UIImage(named:"ic_setting"), for: .normal)
//        self.view.addSubview(settingsButton)
//        settingsButton.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }
//        settingsButton.addTarget(self, action: #selector(self.settingsTapped), for: .touchUpInside)


        let subLabel = UILabel()
        subLabel.text = "Art Director at Adobe"
         subLabel.numberOfLines = 2
        if (K_CURRENT_USER.designation.characters.count > 0 && K_CURRENT_USER.company.characters.count > 0)
        {
            subLabel.text = K_CURRENT_USER.designation + String(format:" at %@",K_CURRENT_USER.company)
        }
        
        else
        {
            subLabel.text = K_CURRENT_USER.designation
        }
        subLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        self.view.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        subLabel.textAlignment = .center
        
        let slider3 = RPCircularProgress()
        slider3.trackTintColor = UIColor.lightGray
        slider3.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        slider3.thicknessRatio = 0.12
        slider3.enableIndeterminate(false) {
           // print("done")
        }
        let progress3 = Float(50)
        slider3.updateProgress(CGFloat((progress3 * 2)/100))
        self.view.addSubview(slider3)
        slider3.snp.makeConstraints { (make) in
            make.top.equalTo(subLabel.snp.bottom).offset(18)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(180)
            
        }
        let slider2 = RPCircularProgress()
        slider2.trackTintColor = UIColor.lightGray
        slider2.progressTintColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        slider2.thicknessRatio = 0.12
        slider2.enableIndeterminate(false) {
          //  print("done")
        }
        let progress2 = Float(40)
        slider2.updateProgress(CGFloat((progress2 * 2)/100))
        self.view.addSubview(slider2)
        slider2.snp.makeConstraints { (make) in
            make.top.equalTo(subLabel.snp.bottom).offset(18)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(180)
        }
        
        
        let slider = RPCircularProgress()
        slider.trackTintColor = UIColor.clear
        slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        slider.thicknessRatio = 0.12
        slider.enableIndeterminate(false) {
           // print("done")
        }
        let progress1 = Float(13)
        slider.updateProgress(CGFloat((progress1 * 2)/100))
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(subLabel.snp.bottom).offset(18)
            make.centerX.equalTo(self.view)
            make.width.equalTo(180)
            make.height.equalTo(180)
        }
        
        let userImageView = UIImageView()
        userImageView.backgroundColor = UIColor.darkGray
        self.view.addSubview(userImageView)
        userImageView.layer.cornerRadius = 68
        userImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider.snp.centerY)
            make.centerX.equalTo(self.view)
            make.width.equalTo(136)
            make.height.equalTo(136)
        }
        userImageView.clipsToBounds = true
        if K_CURRENT_USER.image_url.characters.count > 0 {
           // userImageView.kf.setImage(with: URL(string:K_CURRENT_USER.image_url))
            userImageView.sd_setImage(with: URL(string: K_CURRENT_USER.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
        }
        //analyticsButton.addTarget(self, action: #selector(self.viewAnalytics), for: .touchUpInside)
        
        
        let topCuisineLabel = UILabel()
        topCuisineLabel.text = "Top Cuisines"
        topCuisineLabel.numberOfLines=2;
        self.view.addSubview(topCuisineLabel)
        topCuisineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(userImageView.snp.bottom).offset(40)
        }
        //topCuisineLabel.textAlignment = .center
        topCuisineLabel.font = UIFont(name:  K_Font_Color, size: 21)
        
        
        if self.cuisines.count == 1
        {
        
        let bulletView = UIView()
        self.view.addSubview(bulletView)
        bulletView.snp.makeConstraints { (make) in
            make.left.equalTo(38)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.top.equalTo(topCuisineLabel.snp.bottom).offset(15)
        }
        bulletView.backgroundColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        bulletView.layer.cornerRadius = 5
        
        let cuisineLabel1 = UILabel()
        cuisineLabel1.text = self.cuisines[0]["_id"] as? String
               cuisineLabel1.numberOfLines=2;
        self.view.addSubview(cuisineLabel1)
        cuisineLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(55)
            make.width.equalTo((self.view.frame.size.width * 0.5)  - 40)
            make.centerY.equalTo(bulletView.snp.centerY)
        }
        cuisineLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
        cuisineLabel1.isUserInteractionEnabled = true
        cuisineLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
        
    }
    
        else if self.cuisines.count == 2
        {
            let bulletView = UIView()
            self.view.addSubview(bulletView)
            bulletView.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(15)
            }
            bulletView.backgroundColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            bulletView.layer.cornerRadius = 5
            
            let cuisineLabel1 = UILabel()
            cuisineLabel1.text = self.cuisines[0]["_id"] as? String
            cuisineLabel1.numberOfLines=2;
            self.view.addSubview(cuisineLabel1)
            cuisineLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5)  - 40)
                make.centerY.equalTo(bulletView.snp.centerY)
            }
            cuisineLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel1.isUserInteractionEnabled = true
            cuisineLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            
            
            
        
        
        let bulletView2 = UIView()
        self.view.addSubview(bulletView2)
        bulletView2.snp.makeConstraints { (make) in
            make.left.equalTo(38)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.top.equalTo(cuisineLabel1.snp.bottom).offset(10)
        }
        bulletView2.backgroundColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        bulletView2.layer.cornerRadius = 5
        
        
        let cuisineLabel2 = UILabel()
        cuisineLabel2.text = self.cuisines[1]["_id"] as? String
        self.view.addSubview(cuisineLabel2)
        cuisineLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(55)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.centerY.equalTo(bulletView2.snp.centerY)
        }
        cuisineLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
        cuisineLabel2.isUserInteractionEnabled = true
        cuisineLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
        
    }
        
        
        else if self.cuisines.count == 3
        
        {
            
            let bulletView = UIView()
            self.view.addSubview(bulletView)
            bulletView.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(15)
            }
            bulletView.backgroundColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            bulletView.layer.cornerRadius = 5
            
            let cuisineLabel1 = UILabel()
            cuisineLabel1.text = self.cuisines[0]["_id"] as? String
            cuisineLabel1.numberOfLines=2;
            self.view.addSubview(cuisineLabel1)
            cuisineLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5)  - 40)
                make.centerY.equalTo(bulletView.snp.centerY)
            }
            cuisineLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel1.isUserInteractionEnabled = true
            cuisineLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            
            
            
            
            
            let bulletView2 = UIView()
            self.view.addSubview(bulletView2)
            bulletView2.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel1.snp.bottom).offset(10)
            }
            bulletView2.backgroundColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            bulletView2.layer.cornerRadius = 5
            
            
            let cuisineLabel2 = UILabel()
            cuisineLabel2.text = self.cuisines[1]["_id"] as? String
            self.view.addSubview(cuisineLabel2)
            cuisineLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView2.snp.centerY)
            }
            cuisineLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel2.isUserInteractionEnabled = true
            cuisineLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            
            
            
        
    
        let bulletView3 = UIView()
        self.view.addSubview(bulletView3)
        bulletView3.snp.makeConstraints { (make) in
            make.left.equalTo(38)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.top.equalTo(cuisineLabel2.snp.bottom).offset(10)
        }
        bulletView3.backgroundColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        bulletView3.layer.cornerRadius = 5
        
        
        let cuisineLabel3 = UILabel()
        cuisineLabel3.text = self.cuisines[2]["_id"] as? String
        self.view.addSubview(cuisineLabel3)
        cuisineLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(55)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.centerY.equalTo(bulletView3.snp.centerY)
        }
        cuisineLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
        cuisineLabel3.isUserInteractionEnabled = true
        cuisineLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
        
    }
    
       
        
        else if self.cuisines.count == 4
        
        {
            
            let bulletView = UIView()
            self.view.addSubview(bulletView)
            bulletView.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(15)
            }
            bulletView.backgroundColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            bulletView.layer.cornerRadius = 5
            
            let cuisineLabel1 = UILabel()
            cuisineLabel1.text = self.cuisines[0]["_id"] as? String
            cuisineLabel1.numberOfLines=2;
            self.view.addSubview(cuisineLabel1)
            cuisineLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5)  - 40)
                make.centerY.equalTo(bulletView.snp.centerY)
            }
            cuisineLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel1.isUserInteractionEnabled = true
            cuisineLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            
            
            
            
            
            let bulletView2 = UIView()
            self.view.addSubview(bulletView2)
            bulletView2.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel1.snp.bottom).offset(10)
            }
            bulletView2.backgroundColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            bulletView2.layer.cornerRadius = 5
            
            
            let cuisineLabel2 = UILabel()
            cuisineLabel2.text = self.cuisines[1]["_id"] as? String
            self.view.addSubview(cuisineLabel2)
            cuisineLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView2.snp.centerY)
            }
            cuisineLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel2.isUserInteractionEnabled = true
            cuisineLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            
            
            
            
            
            let bulletView3 = UIView()
            self.view.addSubview(bulletView3)
            bulletView3.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel2.snp.bottom).offset(10)
            }
            bulletView3.backgroundColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            bulletView3.layer.cornerRadius = 5
            
            
            let cuisineLabel3 = UILabel()
            cuisineLabel3.text = self.cuisines[2]["_id"] as? String
            self.view.addSubview(cuisineLabel3)
            cuisineLabel3.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView3.snp.centerY)
            }
            cuisineLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel3.isUserInteractionEnabled = true
            cuisineLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
         
        let bulletView4 = UIView()
        self.view.addSubview(bulletView4)
        bulletView4.snp.makeConstraints { (make) in
            make.left.equalTo(38)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.top.equalTo(cuisineLabel3.snp.bottom).offset(10)
        }
        bulletView4.backgroundColor = UIColor.clear
        bulletView4.layer.cornerRadius = 5
        
        
        
        let cuisineLabel4 = UILabel()
        cuisineLabel4.text = self.cuisines[3]["_id"] as? String
        self.view.addSubview(cuisineLabel4)
        cuisineLabel4.snp.makeConstraints { (make) in
            make.left.equalTo(55)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.centerY.equalTo(bulletView4.snp.centerY)
        }
        cuisineLabel4.font = UIFont(name: K_Font_Color, size: 15.5)
        cuisineLabel4.isUserInteractionEnabled = true
        cuisineLabel4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine4)))
            
        }
        
        
        
        else
        
        {
            
            let bulletView = UIView()
            self.view.addSubview(bulletView)
            bulletView.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(15)
            }
            bulletView.backgroundColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            bulletView.layer.cornerRadius = 5
            
            let cuisineLabel1 = UILabel()
            cuisineLabel1.text = self.cuisines[0]["_id"] as? String
            cuisineLabel1.numberOfLines=2;
            self.view.addSubview(cuisineLabel1)
            cuisineLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5)  - 40)
                make.centerY.equalTo(bulletView.snp.centerY)
            }
            cuisineLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel1.isUserInteractionEnabled = true
            cuisineLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            
            
            
            
            
            let bulletView2 = UIView()
            self.view.addSubview(bulletView2)
            bulletView2.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel1.snp.bottom).offset(10)
            }
            bulletView2.backgroundColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            bulletView2.layer.cornerRadius = 5
            
            
            let cuisineLabel2 = UILabel()
            cuisineLabel2.text = self.cuisines[1]["_id"] as? String
            self.view.addSubview(cuisineLabel2)
            cuisineLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView2.snp.centerY)
            }
            cuisineLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel2.isUserInteractionEnabled = true
            cuisineLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            
            
            
            
            
            let bulletView3 = UIView()
            self.view.addSubview(bulletView3)
            bulletView3.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel2.snp.bottom).offset(10)
            }
            bulletView3.backgroundColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            bulletView3.layer.cornerRadius = 5
            
            
            let cuisineLabel3 = UILabel()
            cuisineLabel3.text = self.cuisines[2]["_id"] as? String
            self.view.addSubview(cuisineLabel3)
            cuisineLabel3.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView3.snp.centerY)
            }
            cuisineLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel3.isUserInteractionEnabled = true
            cuisineLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
            
            let bulletView4 = UIView()
            self.view.addSubview(bulletView4)
            bulletView4.snp.makeConstraints { (make) in
                make.left.equalTo(38)
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.top.equalTo(cuisineLabel3.snp.bottom).offset(10)
            }
            bulletView4.backgroundColor = UIColor.clear
            bulletView4.layer.cornerRadius = 5
            
            
            
            let cuisineLabel4 = UILabel()
            cuisineLabel4.text = self.cuisines[3]["_id"] as? String
            self.view.addSubview(cuisineLabel4)
            cuisineLabel4.snp.makeConstraints { (make) in
                make.left.equalTo(55)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.centerY.equalTo(bulletView4.snp.centerY)
            }
            cuisineLabel4.font = UIFont(name: K_Font_Color, size: 15.5)
            cuisineLabel4.isUserInteractionEnabled = true
            cuisineLabel4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine4)))
      
        
        let bulletView5 = UIView()
        self.view.addSubview(bulletView5)
        bulletView5.snp.makeConstraints { (make) in
            make.left.equalTo(38)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.top.equalTo(cuisineLabel4.snp.bottom).offset(10)
        }
        bulletView5.backgroundColor = UIColor.clear
        bulletView5.layer.cornerRadius = 5
        
        
        let cuisineLabel5 = UILabel()
        cuisineLabel5.text = self.cuisines[4]["_id"] as? String
          cuisineLabel5.numberOfLines=2;
        self.view.addSubview(cuisineLabel5)
        cuisineLabel5.snp.makeConstraints { (make) in
            make.left.equalTo(55)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.centerY.equalTo(bulletView5.snp.centerY)
        }
        cuisineLabel5.font = UIFont(name:K_Font_Color, size: 15.5)
        cuisineLabel5.isUserInteractionEnabled = true
        cuisineLabel5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine5)))
            
        }
        
        
        
        let topCitiesLabel = UILabel()
        topCitiesLabel.text = "Top Cities"
        self.view.addSubview(topCitiesLabel)
        topCitiesLabel.snp.makeConstraints { (make) in
            make.left.equalTo((self.view.frame.size.width * 0.5) + 15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(userImageView.snp.bottom).offset(40)
        }
        //topCuisineLabel.textAlignment = .center
        topCitiesLabel.font = UIFont(name:  K_Font_Color, size: 21)
        
        
        if self.cities.count == 1
        
        {
        
        let cityLabel1 = UILabel()
        cityLabel1.text = self.cities[0]["_id"] as? String
        self.view.addSubview(cityLabel1)
        cityLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(topCitiesLabel.snp.left).offset(15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(topCitiesLabel.snp.bottom).offset(15)
        }
        cityLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
        cityLabel1.isUserInteractionEnabled = true
        cityLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
        }
        
        else if self.cities.count == 2
        
        {
        
            let cityLabel1 = UILabel()
            cityLabel1.text = self.cities[0]["_id"] as? String
            self.view.addSubview(cityLabel1)
            cityLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(topCitiesLabel.snp.bottom).offset(15)
            }
            cityLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel1.isUserInteractionEnabled = true
            cityLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
        
        
        let cityLabel2 = UILabel()
        cityLabel2.text = self.cities[1]["_id"] as? String
        self.view.addSubview(cityLabel2)
        cityLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(topCitiesLabel.snp.left).offset(15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(cityLabel1.snp.bottom).offset(10)
        }
        cityLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
        cityLabel2.isUserInteractionEnabled = true
        cityLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
            
        }
        
        
        else if self.cities.count == 3
        
        {
        
            
            let cityLabel1 = UILabel()
            cityLabel1.text = self.cities[0]["_id"] as? String
            self.view.addSubview(cityLabel1)
            cityLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(topCitiesLabel.snp.bottom).offset(15)
            }
            cityLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel1.isUserInteractionEnabled = true
            cityLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            
            let cityLabel2 = UILabel()
            cityLabel2.text = self.cities[1]["_id"] as? String
            self.view.addSubview(cityLabel2)
            cityLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel1.snp.bottom).offset(10)
            }
            cityLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel2.isUserInteractionEnabled = true
            cityLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
        
        let cityLabel3 = UILabel()
        cityLabel3.text = self.cities[2]["_id"] as? String
            
            let lblText = self.cities[2]["_id"] as? String
            
            // var fullName = "First Last"
            var fullNameArr =  lblText?.components(separatedBy: " ")
            // print(fullNameArr)
            cityLabel3.text =   fullNameArr?.joined(separator: "\n")
          //  print(cityLabel3.text)

        self.view.addSubview(cityLabel3)
        cityLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(topCitiesLabel.snp.left).offset(15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(cityLabel2.snp.bottom).offset(10)
        }
        cityLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
        cityLabel3.isUserInteractionEnabled = true
        cityLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity3)))
        
    }
    
        
        
         else if self.cities.count == 4
        
        {
        
            
            let cityLabel1 = UILabel()
            cityLabel1.text = self.cities[0]["_id"] as? String
            self.view.addSubview(cityLabel1)
            cityLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(topCitiesLabel.snp.bottom).offset(15)
            }
            cityLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel1.isUserInteractionEnabled = true
            cityLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            
            let cityLabel2 = UILabel()
            cityLabel2.text = self.cities[1]["_id"] as? String
            self.view.addSubview(cityLabel2)
            cityLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel1.snp.bottom).offset(10)
            }
            cityLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel2.isUserInteractionEnabled = true
            cityLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
            
            let cityLabel3 = UILabel()
            cityLabel3.text = self.cities[2]["_id"] as? String
            self.view.addSubview(cityLabel3)
            cityLabel3.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel2.snp.bottom).offset(10)
            }
            cityLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel3.isUserInteractionEnabled = true
            cityLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity3)))
        
        let cityLabel4 = UILabel()
        cityLabel4.text = self.cities[3]["_id"] as? String
        self.view.addSubview(cityLabel4)
        cityLabel4.snp.makeConstraints { (make) in
            make.left.equalTo(topCitiesLabel.snp.left).offset(15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(cityLabel3.snp.bottom).offset(10)
        }
        cityLabel4.font = UIFont(name: K_Font_Color,size: 15.5)
        cityLabel4.isUserInteractionEnabled = true
        cityLabel4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity4)))
            
        }
        
        
        else
        {
            
            let cityLabel1 = UILabel()
            cityLabel1.text = self.cities[0]["_id"] as? String
            self.view.addSubview(cityLabel1)
            cityLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(topCitiesLabel.snp.bottom).offset(15)
            }
            cityLabel1.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel1.isUserInteractionEnabled = true
            cityLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
            
            
            let cityLabel2 = UILabel()
            cityLabel2.text = self.cities[1]["_id"] as? String
            self.view.addSubview(cityLabel2)
            cityLabel2.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel1.snp.bottom).offset(10)
            }
            cityLabel2.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel2.isUserInteractionEnabled = true
            cityLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
            
            let cityLabel3 = UILabel()
            cityLabel3.text = self.cities[2]["_id"] as? String
            self.view.addSubview(cityLabel3)
            cityLabel3.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel2.snp.bottom).offset(10)
            }
            cityLabel3.font = UIFont(name: K_Font_Color, size: 15.5)
            cityLabel3.isUserInteractionEnabled = true
            cityLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity3)))
            
            let cityLabel4 = UILabel()
            cityLabel4.text = self.cities[3]["_id"] as? String
            self.view.addSubview(cityLabel4)
            cityLabel4.snp.makeConstraints { (make) in
                make.left.equalTo(topCitiesLabel.snp.left).offset(15)
                make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
                make.top.equalTo(cityLabel3.snp.bottom).offset(10)
            }
            cityLabel4.font = UIFont(name: K_Font_Color,size: 15.5)
            cityLabel4.isUserInteractionEnabled = true
            cityLabel4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity4)))
  
       
        let cityLabel5 = UILabel()
        cityLabel5.text = self.cities[4]["_id"] as? String
        self.view.addSubview(cityLabel5)
        cityLabel5.snp.makeConstraints { (make) in
            make.left.equalTo(topCitiesLabel.snp.left).offset(15)
            make.width.equalTo((self.view.frame.size.width * 0.5) - 40)
            make.top.equalTo(cityLabel4.snp.bottom).offset(10)
        }
          cityLabel5.numberOfLines=2;
        cityLabel5.font = UIFont(name: K_Font_Color, size: 15.5)
        
        cityLabel5.isUserInteractionEnabled = true
        cityLabel5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity5)))
        
        
    }
    
    }
    func showCuisine1() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cuisines[0]["_id"] as? String)!
        vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func showCuisine2()
    {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cuisines[1]["_id"] as? String)!
         vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)    }
    
    func showCuisine3() {
        
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cuisines[2]["_id"] as? String)!
         vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCuisine4() {
        
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cuisines[3]["_id"] as? String)!
         vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCuisine5() {
        
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cuisines[4]["_id"] as? String)!
         vc.filterName = "cuisines"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCity1() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[0]["_id"] as? String)!
         vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCity2() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[1]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCity3() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[2]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showCity4() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[3]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showCity5() {
        let vc = ProfileCuisineFilterViewController()
        vc.cuisineName = (self.cities[4]["_id"] as? String)!
        vc.filterName = "cities"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func settingsTapped()
    {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
