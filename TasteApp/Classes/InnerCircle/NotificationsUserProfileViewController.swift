//
//  NotificationsUserProfileViewController.swift
//  Taste
//
//  Created by Asish Pant on 04/08/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
import Alamofire

class NotificationsUserProfileViewController: UIViewController {
    
    // declared by rAnjit for push
    var paramDict = [String : Any]()
    var notify_user_id = ""
    var recieveUserId = ""
    
    var screenName :String?
    var friendId : String = ""
    var userObjectId : String = ""
    var NotificationObj : String = ""
    
    var userProfile = [[String:Any]]()
    var arrcuisineData = [[String:Any]]()
    var arrcityData = [[String:Any]]()
    
    var cuisines = [[String:Any]]()
    var cities = [[String:Any]]()
    // var titleLabel:UILabel!
    var cuisineCount :Float = 0.0
    var cityCount :Float = 0.0
    //var loopNumber:Int = 15
    let citySliderLabel3 = UILabel()
    let citySlider3 = RPCircularProgress()
    var slider = RPCircularProgress()
    let btnaccept = UIButton(type: .custom)
     let btndecline = UIButton(type: .custom)
    //let toprecentHeading = UILabel()
    
    var f = 0.0,f1 = 0.0,f2 = 0.0
    
    var c = 0.0,c1 = 0.0,c2 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.btnaccept.isUserInteractionEnabled = true
      //  print("friend id is \(self.friendId)")
        self.view.backgroundColor = UIColor.white
        
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
        
        
        
        
        // Do any additional setup after loading the view.
        self.setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if self.NotificationObj == "FromNotification"{
            
            DispatchQueue.global().async {
                
                self.paramDict = ["ID":self.notify_user_id,"status":"READED"]
                self.makeReadNOtification(param: self.paramDict)
                
                DispatchQueue.main.async(execute: {
                    
                })
            }
            
            
            
        }
    }
    func makeReadNOtification(param:[String:Any])->Void{
        Alamofire.request(K_MAKE_NOTIFICATION_READ, method: .put, parameters: param, encoding: URLEncoding.default, headers: nil)
            .response
            {(response) in
                print("response which get from server is \(response)that")
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(" parsed data \(parsedData)")
                    print(parsedData)
                    self.NotificationCountMethod()
                    
                } catch let error as NSError {
                    print(error)
                    // completion("")
                }
                
        }
        
    }

    func NotificationCountMethod() {
        
        
        //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":singelton.loginId] as [String : Any]
        print("the parameter is : \(parameters)")
        
        DataManager.sharedManager.getNotificationCount(params: parameters) { (response) in
            
            
            
            if let dataDic = response as?  NSDictionary
                
            {
                let val_count = dataDic["count"] as! NSNumber
                print("BBB",val_count)
                K_INNERUSER_DATA.notificationCount = Int(val_count)
                 //TODO: FOR REMOVING BADGE FOR TEMPORARY  ADDED BY RANJIT 8 FEB
               // UIApplication.shared.applicationIconBadgeNumber = K_INNERUSER_DATA.notificationCount
            }
            DispatchQueue.main.async {
                
            }
            
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        //  _ =  self.navigationController?.popViewController(animated: true)
        super.viewWillDisappear(animated)
    }
    
    
    func goBack() {
        if self.NotificationObj == "FromNotification"{
            //  self.dismiss(animated: true, completion: nil)
            let singelton = SharedManager.sharedInstance
            singelton.refeshRecommendation = "yes"
            let app = AppDelegate()
            app.showHome()
            self.NotificationObj = ""
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
        // self.navigationController?.popViewController(animated: true)
    }
    
    
    func showCuisine1()
    {
    }
    func setupView() {
        
        
        
        self.view.backgroundColor = UIColor.white
        delayWithSeconds(1.0)
        {
            SVProgressHUD.show()
            
            
            let parameter = ["user_id":self.userObjectId,"stranger_id": self.friendId as String ]
          //  print(self.friendId,parameter)
            DataManager.sharedManager.getInnerCircleUserProfile(params: parameter, completion: { (response) in
                
                if let dataDic = response as? [String:Any]
                    
                {
                   // print(dataDic)
                    
                    if let profilearr = dataDic["profile"] as? [[String:Any]]
                    {
                        self.userProfile = profilearr
                      //  print(self.userProfile.count)
                        
                        
                        if self.userProfile.count > 0 {
                            let positionOb = self.userProfile[0]
                           // print(positionOb)
                            if let companyDict = positionOb["profile"] as? [String:Any]
                            {
                                print(companyDict)
                                K_INNERUSER_PROFILE.name = companyDict["firstname"] as! String
                                K_INNERUSER_PROFILE.lastname = companyDict["lastname"] as! String
                                K_INNERUSER_PROFILE.company = companyDict["company_name"] as! String
                                if  let imageUrl = companyDict["image"] as? String{
                                    K_INNERUSER_PROFILE.image_url = K_IMAGE_BASE_URL + imageUrl
                                }
                                //                                K_INNERUSER_PROFILE.image_url = companyDict["image"] as! String
                                
                              //  print("user name is \( K_INNERUSER_PROFILE.name) and company is \(K_INNERUSER_PROFILE.company) and image url is \(K_INNERUSER_PROFILE.image_url)")
                                
                                
                            }
                            
                        }
                        else{
                            K_INNERUSER_PROFILE.name = ""
                            K_INNERUSER_PROFILE.lastname = ""
                            K_INNERUSER_PROFILE.company = ""
                            K_INNERUSER_PROFILE.image_url = ""
                        }
                    }
                    else{
                        K_INNERUSER_PROFILE.name = ""
                        K_INNERUSER_PROFILE.lastname = ""
                        K_INNERUSER_PROFILE.company = ""
                        K_INNERUSER_PROFILE.image_url = ""
                    }
                    if let cuisineArr = dataDic["top_cuisine"] as? [[String:Any]] {
                        self.cuisines = cuisineArr
                        
                    }
                    if let citiesArr = dataDic["top_cities"] as? [[String:Any]] {
                        self.cities = citiesArr
                    }
                    
                }
                
                DispatchQueue.main.async {
                    
                    
                    self.loadDataNew()
                    
                    SVProgressHUD.dismiss()
                }
            })
        }
    }//clase setup
    
    func HitNotificationInviteStatus(frindId:String , userID:String)  {
        
        let parameter = ["user_id" :userID, "friend_id":frindId]
        print(parameter)
        DataManager.sharedManager.notificationInviteStatus(params: parameter) { (response) in
            
            
            
          //  print("Invite Status Response",response)
            if let dataDic = response as? [String:Any]
                
            {
                if let valData  = dataDic["data"] as? String {
                    
                  //  print("message---",dataDic)
                    if valData == "SEND_BY_STRANGER"{
                        // Accept decline screen
                        //this request is send by someone else
                        K_INNERUSER_DATA.requestStatus = ""
                        let profile = NotificationsUserProfileViewController()
                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                            profile.screenName = ""
                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "REQUEST_APPROVED"{
                        
                        // Open The User Profile Screen
                        
                        
//                        let profile = UserAddedProfileViewController()
//                        profile.screenName = "InviteAdded"
//                      //  print("Data is profile ",profileDict)
//                            profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
//                        profile.userObjId =  K_INNERUSER_DATA.UserIdGlobal
//                        //            profile.friendId = self.users[indexPath.row]["fnd_obj"] as! String
//                        //            profile.userObjId  = self.users[indexPath.row]["user_obj"] as! String
//                        self.navigationController?.pushViewController(profile, animated: true)
                        
                        
                        
                        
                        
                        let profile = NotificationsUserProfileViewController()
                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        self.btnaccept.isHidden = true
                        self.btndecline.isHidden = true
                        let titleLabel = UILabel()
                        titleLabel.isHidden = false
                        titleLabel.text = "Your inner circle request is approved."
                        titleLabel.textAlignment = .center
                        titleLabel.numberOfLines = 2
                        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
                        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                        self.view.addSubview(titleLabel)
                        titleLabel.snp.makeConstraints { (make) in
                            make.left.equalTo(0)
                            make.right.equalTo(0)
                            make.bottom.equalTo(self.view.snp.bottom).offset(-165)
                            // make.centerX.equalTo(self.view)
                            // make.centerY.equalTo(self.view)
                        }
                        // code commented
                      //  self.loadDataNew()
                        // end of code commented
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                        profile.screenName = ""
                    //    self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "SEND_BY_USER"{
                         // Go to Screnn Invite To Inner circle
                       
                        let profile = NotificationsUserProfileViewController()
//                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
//                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
//                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
//                        self.loadDataNew()
//                        profile.screenName = ""
                    }
                    
                    
                    if valData == "REQUEST_NOT_SEND"{
                        // Go to Screnn Invite To Inner circle
                        let profile = UserProfileViewController()
                        profile.screenName = "Invite"
                        //  profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        self.navigationController?.pushViewController(profile, animated: true)
                        //
                        // let profile = NotificationsUserProfileViewController()
                        // profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        // profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        // K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                        
                        // profile.screenName = ""
                        // self.navigationController?.pushViewController(profile, animated: true)
                    }
                    
                    
                    
                    //                    let profile = NotificationsUserProfileViewController()
                    //                    profile.userObjectId = userId
                    //                    profile.friendId = self.stranger_Id
                    //                    // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                    //                    // profile.friendId = id as String
                    //
                    //
                    //
                    //
                    //                    profile.screenName = ""
                    //                    self.navigationController?.pushViewController(profile, animated: true)
                }
                else{
                    SVProgressHUD.dismiss()
                }
            }
            else{
                SVProgressHUD.dismiss()
            }
            
        }
        
        
        
        
    }

    
    
    
    func loadDataNew()
    {
        
        
        let titleLabel = UILabel()
        titleLabel.text = "INNER CIRCLE"
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
        
        let upperProfileView = UIView()
        self.view.addSubview(upperProfileView)
        
        upperProfileView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(60)
            make.right.equalTo(-0)
            make.height.equalTo(220)
        }
        
        
        let imageView = UIImageView()
        upperProfileView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(30)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        
        imageView.backgroundColor = UIColor.gray
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        
        //let btn = UIButton()
        if K_INNERUSER_DATA.requestStatus == "REQUEST_APPROVED" {
            
            
            self.btnaccept.isHidden = true
            self.btndecline.isHidden = true
            let titleLabel = UILabel()
            titleLabel.isHidden = false
            titleLabel.text = "Your inner circle request is approved."
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
            //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.view.snp.bottom).offset(-165)
                // make.centerX.equalTo(self.view)
                // make.centerY.equalTo(self.view)
            }
            
            //            let btnStatusText = UIButton(type: .custom)
            //            btnStatusText.backgroundColor = UIColor.black
            //            btnStatusText.setTitle("Your inner circle request is approved.", for: .normal)
            //            btnStatusText.tag = 1
            //            self.view.addSubview(btnStatusText)
            //            btnStatusText.snp.makeConstraints { (make) in
            //                make.bottom.equalTo(-64)
            //
            //                make.left.equalTo(30)
            //                // make.right.equalTo(-10)
            //                make.width.equalTo(310)
            //                make.height.equalTo(52)
            //
            //            }
            
        }
        else{
           // let btnaccept = UIButton(type: .custom)
            self.btnaccept.isHidden = false
            self.btndecline.isHidden = false
            btnaccept.backgroundColor = UIColor.black
            btnaccept.setTitle("Accept", for: .normal)
            btnaccept.tag = 1
            self.view.addSubview(btnaccept)
            btnaccept.snp.makeConstraints { (make) in
                make.bottom.equalTo(-64)
                
                make.left.equalTo(30)
                // make.right.equalTo(-10)
                make.width.equalTo(140)
                make.height.equalTo(52)
                
            }
            btnaccept.addTarget(self, action: #selector(NotificationsUserProfileViewController.acceptAction), for: .touchUpInside)
            
            
          //  let btndecline = UIButton(type: .custom)
            btndecline.backgroundColor = UIColor.black
            btndecline.setTitle("Decline", for: .normal)
            btnaccept.tag = 2
            self.view.addSubview(btndecline)
            btndecline.snp.makeConstraints { (make) in
                make.bottom.equalTo(-64)
                
                make.left.equalTo(190)
                //     make.right.equalTo(-10)
                make.width.equalTo(140)
                make.height.equalTo(52)
                
            }
            btndecline.addTarget(self, action: #selector(NotificationsUserProfileViewController.declineAction), for: .touchUpInside)
        }
        
        
        //  if K_INNERUSER_PROFILE.image_url.characters.count > 0 {
        
        imageView.sd_setImage(with: URL(string: K_INNERUSER_PROFILE.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
        // imageView.kf.setImage(with: URL(string:K_INNERUSER_PROFILE.image_url))
        //  }
        
        //  else
        //  {
        //            let strImage = "https://pbs.twimg.com/profile_images/621727263969558528/lZY2QPTF_200x200.jpg"
        //
        //            imageView.kf.setImage(with: URL(string:strImage))
        
        //      imageView.image = UIImage(named: "profile")
        //  }
        
        
        let nameLabel = UILabel()
        upperProfileView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.centerY.equalTo(imageView.snp.centerY).offset(-15)
        }
        nameLabel.text =  ""
        
        if K_INNERUSER_PROFILE.name.count > 0
        {
            nameLabel.text  = K_INNERUSER_PROFILE.name
            
        }
        
        nameLabel.font = UIFont(name:  K_Font_Color, size: 26)
        
        let subLabel = UILabel()
        upperProfileView.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        subLabel.text = ""
        if K_INNERUSER_PROFILE.company.count > 0
        {
            subLabel.text  = K_INNERUSER_PROFILE.company
            
        }
        
        
        subLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        let otherSubLabel = UILabel()
        upperProfileView.addSubview(otherSubLabel)
        otherSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(subLabel.snp.bottom).offset(5)
        }
        otherSubLabel.text = ""
        otherSubLabel.font = UIFont(name:  K_Font_Color, size: 13)
        if screenName == "Invite"{
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.black
            button.setTitle("INVITE TO INNER CIRCLE", for: .normal)
            self.view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.bottom.equalTo(-64)
                make.height.equalTo(52)
                make.left.equalTo(10)
                make.right.equalTo(-10)
            }
            button.addTarget(self, action: #selector(self.continueTapped), for: .touchUpInside)
        }
        
//        //for slider
//        if self.cuisines.count >= 1 ||  self.cities.count >= 1{
//        }
//        else{
//            return
//        }
//        
//        for number in 0..<(self.cuisines.count-1)
//            
//        {
//            let circle1 = Float(self.cuisines[number]["count"] as! Int)
//            
//            cuisineCount = cuisineCount + circle1
//        }
//        //        for number in 0..<(self.cities.count-1)
//        //
//        //        {
//        //            let circle1 = Float(self.cities[number]["count"] as! Int)
//        //
//        //            cityCount = cityCount + circle1
//        //        }
//        let sliderWidth = (self.view.frame.size.width - 50)/3
//        
//        let topCuisineLabel = UILabel()
//        self.view.addSubview(topCuisineLabel)
//        topCuisineLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(imageView.snp.bottom).offset(20)
//        }
//        topCuisineLabel.textAlignment = .center
//        topCuisineLabel.text = "Top Cuisines"
//        topCuisineLabel.font = UIFont(name:  K_Font_Color, size: 23)
//        if self.cuisines.count == 1
//        {
//            
//            
//            slider = RPCircularProgress()
//            slider.trackTintColor = UIColor.lightGray
//            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
//            slider.thicknessRatio = 0.22
//            slider.enableIndeterminate(false) {
//                print("done")
//            }
//            
//            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
//            let progress1 = Float(self.cuisines[0]["count"] as! Int)
//            
//            
//            let variable = CGFloat(progress1/cuisineCount)
//            
//            let twoDecimalPlaces = String(format: "%.3f",variable)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
//                f = Double(CGFloat(n))
//            }
//            
//            slider.updateProgress(CGFloat(f))
//            // slider.updateProgress(CGFloat((progress1/100))
//            //slider.updateProgress(0.6,animated:true)
//            self.view.addSubview(slider)
//            slider.snp.makeConstraints { (make) in
//                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
//                make.left.equalTo(15)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel = UILabel()
//            // sliderLabel.text = self.cuisines[0]["_id"] as? String
//            if   let lblslider = self.cuisines[0]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            
//            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel.textAlignment = .center
//            sliderLabel.numberOfLines = 3
//            self.view.addSubview(sliderLabel)
//            sliderLabel.snp.makeConstraints { (make) in
//                make.center.equalTo(slider)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//        }//count city 1
//            
//            
//        else if self.cuisines.count == 2
//        {
//            
//            slider = RPCircularProgress()
//            slider.trackTintColor = UIColor.lightGray
//            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
//            slider.thicknessRatio = 0.22
//            slider.enableIndeterminate(false) {
//                print("done")
//            }
//            
//            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
//            let progress1 = Float(self.cuisines[0]["count"] as! Int)
//            
//            
//            let variable = CGFloat(progress1/cuisineCount)
//            
//            let twoDecimalPlaces = String(format: "%.3f",variable)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
//                f = Double(CGFloat(n))
//            }
//            
//            slider.updateProgress(CGFloat(f))
//            // slider.updateProgress(CGFloat((progress1/100))
//            //slider.updateProgress(0.6,animated:true)
//            self.view.addSubview(slider)
//            slider.snp.makeConstraints { (make) in
//                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
//                make.left.equalTo(15)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel = UILabel()
//            //sliderLabel.text = self.cuisines[0]["_id"] as? String
//            if   let lblslider = self.cuisines[0]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            
//            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel.textAlignment = .center
//            sliderLabel.numberOfLines = 3
//            self.view.addSubview(sliderLabel)
//            sliderLabel.snp.makeConstraints { (make) in
//                make.center.equalTo(slider)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            
//            
//            let slider2 = RPCircularProgress()
//            slider2.trackTintColor = UIColor.lightGray
//            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
//            slider2.thicknessRatio = 0.22
//            slider2.enableIndeterminate(false) {
//                print("done")
//            }
//            //slider2.updateProgress(0.5)
//            // slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
//            let progress2 = Float(self.cuisines[1]["count"] as! Int)
//            
//            let variable1 = CGFloat(progress2/cuisineCount)
//            
//            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
//                f1 = Double(CGFloat(n))
//            }
//            
//            
//            //slider2.updateProgress(0.8,animated:true)
//            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
//            slider2.updateProgress(CGFloat(f1))
//            
//            
//            self.view.addSubview(slider2)
//            slider2.snp.makeConstraints { (make) in
//                make.top.equalTo(slider.snp.top)
//                make.left.equalTo(slider.snp.right).offset(13)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel2 = UILabel()
//            // sliderLabel2.text = self.cuisines[1]["_id"] as? String
//            if   let lblslider = self.cuisines[1]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            
//            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel2.textAlignment = .center
//            sliderLabel2.numberOfLines = 2
//            self.view.addSubview(sliderLabel2)
//            sliderLabel2.snp.makeConstraints { (make) in
//                make.center.equalTo(slider2)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//        }
//            
//        else
//            
//        {
//            
//            //count 3 hain
//            
//            slider = RPCircularProgress()
//            slider.trackTintColor = UIColor.lightGray
//            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
//            slider.thicknessRatio = 0.22
//            slider.enableIndeterminate(false) {
//                print("done")
//            }
//            
//            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
//            let progress1 = Float(self.cuisines[0]["count"] as! Int)
//            
//            
//            let variable = CGFloat(progress1/cuisineCount)
//            
//            let twoDecimalPlaces = String(format: "%.3f",variable)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
//                f = Double(CGFloat(n))
//            }
//            
//            slider.updateProgress(CGFloat(f))
//            // slider.updateProgress(CGFloat((progress1/100))
//            //slider.updateProgress(0.6,animated:true)
//            self.view.addSubview(slider)
//            slider.snp.makeConstraints { (make) in
//                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
//                make.left.equalTo(15)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel = UILabel()
//            
//            // sliderLabel.text = self.cuisines[0]["_id"] as? String
//            if   let lblslider = self.cuisines[0]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel.textAlignment = .center
//            sliderLabel.numberOfLines = 3
//            self.view.addSubview(sliderLabel)
//            sliderLabel.snp.makeConstraints { (make) in
//                make.center.equalTo(slider)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            
//            
//            let slider2 = RPCircularProgress()
//            slider2.trackTintColor = UIColor.lightGray
//            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
//            slider2.thicknessRatio = 0.22
//            slider2.enableIndeterminate(false) {
//                print("done")
//            }
//            //slider2.updateProgress(0.5)
//            //  slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
//            let progress2 = Float(self.cuisines[1]["count"] as! Int)
//            
//            let variable1 = CGFloat(progress2/cuisineCount)
//            
//            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
//                f1 = Double(CGFloat(n))
//            }
//            
//            
//            //slider2.updateProgress(0.8,animated:true)
//            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
//            slider2.updateProgress(CGFloat(f1))
//            
//            
//            self.view.addSubview(slider2)
//            slider2.snp.makeConstraints { (make) in
//                make.top.equalTo(slider.snp.top)
//                make.left.equalTo(slider.snp.right).offset(13)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel2 = UILabel()
//            
//            //  sliderLabel2.text = self.cuisines[1]["_id"] as? String
//            
//            if   let lblslider = self.cuisines[1]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel2.textAlignment = .center
//            sliderLabel2.numberOfLines = 2
//            self.view.addSubview(sliderLabel2)
//            sliderLabel2.snp.makeConstraints { (make) in
//                make.center.equalTo(slider2)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let slider3 = RPCircularProgress()
//            slider3.trackTintColor = UIColor.lightGray
//            slider3.progressTintColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
//            slider3.thicknessRatio = 0.22
//            slider3.enableIndeterminate(false) {
//                print("done")
//            }
//            //slider3.updateProgress(0.5)
//            let progress3 = Float(self.cuisines[2]["count"] as! Int)
//            
//            
//            
//            let variable3 = CGFloat(progress3/cuisineCount)
//            
//            let twoDecimalPlaces3 = String(format: "%.3f",variable3)
//            
//            
//            
//            if let n = NumberFormatter().number(from: twoDecimalPlaces3)
//            {
//                f2 = Double(CGFloat(n))
//            }
//            
//            
//            slider3.updateProgress(CGFloat(f2))
//            // slider3.updateProgress(CGFloat((progress3 * 2)/100))
//            //slider3.updateProgress(0.2,animated:true)
//            //  slider3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
//            self.view.addSubview(slider3)
//            slider3.snp.makeConstraints { (make) in
//                make.top.equalTo(slider.snp.top)
//                make.left.equalTo(slider2.snp.right).offset(13)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//            let sliderLabel3 = UILabel()
//            // sliderLabel3.text = self.cuisines[2]["_id"] as? String
//            
//            if   let lblslider = self.cuisines[2]["_id"] as? String{
//                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
//                sliderLabel3.text =   lblsliderSeperate.joined(separator: "\n")
//            }
//            
//            
//            sliderLabel3.font = UIFont(name:K_Font_Color,size:12)
//            sliderLabel3.textAlignment = .center
//            sliderLabel3.numberOfLines = 2
//            self.view.addSubview(sliderLabel3)
//            sliderLabel3.snp.makeConstraints { (make) in
//                make.center.equalTo(slider3)
//                make.width.equalTo(sliderWidth)
//                make.height.equalTo(sliderWidth)
//            }
//            
//        }
        
        
        
       
        
        
        //for city
        /*  let topCityLabel = UILabel()
         topCityLabel.text = "Top Cities"
         self.view.addSubview(topCityLabel)
         topCityLabel.snp.makeConstraints { (make) in
         make.left.equalTo(10)
         make.right.equalTo(-10)
         make.top.equalTo(slider.snp.bottom).offset(20)
         }
         topCityLabel.textAlignment = .center
         //topCityLabel.font = UIFont(name:  K_Font_Color, size: 23)
         topCityLabel.font = UIFont(name:  K_Font_Color, size: 23)
         
         
         if self.cities.count == 1
         {
         
         
         let citySlider = RPCircularProgress()
         citySlider.trackTintColor = UIColor.lightGray
         citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider.thicknessRatio = 0.22
         citySlider.enableIndeterminate(false) {
         print("done")
         }
         
         citySlider.isUserInteractionEnabled = true
         // citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
         
         //citySlider.updateProgress(0.5)
         let progress4 = Float(self.cities[0]["count"] as! Int)
         
         let variable4 = CGFloat(progress4/cityCount)
         
         let twoDecimalPlaces4 = String(format: "%.3f",variable4)
         
         
         
         if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
         c = Double(CGFloat(n))
         }
         
         
         citySlider.updateProgress(CGFloat(c))
         //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
         self.view.addSubview(citySlider)
         citySlider.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(15)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel = UILabel()
         // citySliderLabel.text = self.cities[0]["_id"] as? String
         if   let lblslider = self.cities[0]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel.textAlignment = .center
         citySliderLabel.numberOfLines = 3
         citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
         self.view.addSubview(citySliderLabel)
         citySliderLabel.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         
         //            let toprecentHeading = UILabel()
         //            toprecentHeading.text = "Recent Tastes"
         //            self.view.addSubview(toprecentHeading)
         //            toprecentHeading.snp.makeConstraints { (make) in
         //                make.left.equalTo(0)
         //                make.right.equalTo(0)
         //                make.top.equalTo(citySlider.snp.bottom).offset(10)
         //            }
         //            toprecentHeading.textAlignment = .center
         //            //   toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
         //            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
         
         } //Count 1 hain to
         
         
         
         else if self.cities.count == 2
         {
         
         let citySlider = RPCircularProgress()
         citySlider.trackTintColor = UIColor.lightGray
         citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider.thicknessRatio = 0.22
         citySlider.enableIndeterminate(false) {
         print("done")
         }
         
         citySlider.isUserInteractionEnabled = true
         // citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
         
         //citySlider.updateProgress(0.5)
         let progress4 = Float(self.cities[0]["count"] as! Int)
         
         let variable4 = CGFloat(progress4/cityCount)
         
         let twoDecimalPlaces4 = String(format: "%.3f",variable4)
         
         
         
         if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
         c = Double(CGFloat(n))
         }
         
         
         citySlider.updateProgress(CGFloat(c))
         //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
         self.view.addSubview(citySlider)
         citySlider.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(15)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel = UILabel()
         // citySliderLabel.text = self.cities[0]["_id"] as? String
         if   let lblslider = self.cities[0]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel.textAlignment = .center
         citySliderLabel.numberOfLines = 3
         citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
         self.view.addSubview(citySliderLabel)
         citySliderLabel.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         
         
         let citySlider2 = RPCircularProgress()
         citySlider2.trackTintColor = UIColor.lightGray
         citySlider2.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider2.thicknessRatio = 0.22
         citySlider2.enableIndeterminate(false) {
         print("done")
         }
         citySlider2.isUserInteractionEnabled = true
         //  citySlider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
         
         
         //citySlider.updateProgress(0.5)
         let progress5 = Float(self.cities[1]["count"] as! Int)
         
         
         let variable5 = CGFloat(progress5/cityCount)
         
         let twoDecimalPlaces5 = String(format: "%.3f",variable5)
         
         
         
         if let n = NumberFormatter().number(from: twoDecimalPlaces5) {
         c1 = Double(CGFloat(n))
         }
         citySlider2.updateProgress(CGFloat(c1))
         //citySlider2.updateProgress(CGFloat((progress5 * 5)/100))
         self.view.addSubview(citySlider2)
         citySlider2.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(citySlider.snp.right).offset(13)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel2 = UILabel()
         // citySliderLabel2.text = self.cities[1]["_id"] as? String
         if   let lblslider = self.cities[1]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel2.font = UIFont(name:K_Font_Color,size:12)
         citySliderLabel2.textAlignment = .center
         citySliderLabel2.numberOfLines = 3
         self.view.addSubview(citySliderLabel2)
         citySliderLabel2.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider2)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         
         //            let toprecentHeading = UILabel()
         //            toprecentHeading.text = "Recent Tastes"
         //            self.view.addSubview(toprecentHeading)
         //            toprecentHeading.snp.makeConstraints { (make) in
         //                make.left.equalTo(0)
         //                make.right.equalTo(0)
         //                make.top.equalTo(citySlider2.snp.bottom).offset(10)
         //            }
         //            toprecentHeading.textAlignment = .center
         //            // toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
         //            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
         
         
         
         } //count 2 hain to
         
         else
         {
         
         
         let citySlider = RPCircularProgress()
         citySlider.trackTintColor = UIColor.lightGray
         citySlider.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider.thicknessRatio = 0.22
         citySlider.enableIndeterminate(false) {
         print("done")
         }
         
         citySlider.isUserInteractionEnabled = true
         //  citySlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity1)))
         
         //citySlider.updateProgress(0.5)
         let progress4 = Float(self.cities[0]["count"] as! Int)
         
         let variable4 = CGFloat(progress4/cityCount)
         
         let twoDecimalPlaces4 = String(format: "%.3f",variable4)
         
         
         
         if let n = NumberFormatter().number(from: twoDecimalPlaces4) {
         c = Double(CGFloat(n))
         }
         
         
         citySlider.updateProgress(CGFloat(c))
         //citySlider.updateProgress(CGFloat((progress4 * 5 )/100))
         self.view.addSubview(citySlider)
         citySlider.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(15)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel = UILabel()
         // citySliderLabel.text = self.cities[0]["_id"] as? String
         if   let lblslider = self.cities[0]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel.textAlignment = .center
         citySliderLabel.numberOfLines = 3
         citySliderLabel.font = UIFont(name:K_Font_Color,size:12)
         self.view.addSubview(citySliderLabel)
         citySliderLabel.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         let citySlider2 = RPCircularProgress()
         citySlider2.trackTintColor = UIColor.lightGray
         citySlider2.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider2.thicknessRatio = 0.22
         citySlider2.enableIndeterminate(false) {
         print("done")
         }
         citySlider2.isUserInteractionEnabled = true
         // citySlider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity2)))
         
         
         //citySlider.updateProgress(0.5)
         let progress5 = Float(self.cities[1]["count"] as! Int)
         
         
         let variable5 = CGFloat(progress5/cityCount)
         
         let twoDecimalPlaces5 = String(format: "%.3f",variable5)
         
         
         
         if let n = NumberFormatter().number(from: twoDecimalPlaces5) {
         c1 = Double(CGFloat(n))
         }
         citySlider2.updateProgress(CGFloat(c1))
         //citySlider2.updateProgress(CGFloat((progress5 * 5)/100))
         self.view.addSubview(citySlider2)
         citySlider2.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(citySlider.snp.right).offset(13)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel2 = UILabel()
         citySliderLabel2.text = self.cities[1]["_id"] as? String
         if   let lblslider = self.cities[1]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel2.font = UIFont(name:K_Font_Color,size:12)
         citySliderLabel2.textAlignment = .center
         citySliderLabel2.numberOfLines = 3
         self.view.addSubview(citySliderLabel2)
         citySliderLabel2.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider2)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         
         
         //let citySlider3 = RPCircularProgress()
         citySlider3.trackTintColor = UIColor.lightGray
         citySlider3.progressTintColor = UIColor(red: 125.0/255.0, green: 126.0/255.0, blue: 122.0/255.0, alpha: 1.0)
         citySlider3.thicknessRatio = 0.22
         citySlider3.enableIndeterminate(false) {
         print("done")
         }
         
         citySlider3.isUserInteractionEnabled = true
         // citySlider3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCity3)))
         
         //citySlider.updateProgress(0.5)
         let progress6 = Float(self.cities[2]["count"] as! Int)
         let variable6 = CGFloat(progress6/cityCount)
         let twoDecimalPlaces6 = String(format: "%.3f",variable6)
         if let n = NumberFormatter().number(from: twoDecimalPlaces6) {
         c2 = Double(CGFloat(n))
         }
         citySlider3.updateProgress(CGFloat(c2))
         
         
         //citySlider3.updateProgress(CGFloat((progress6 * 2)/100))
         self.view.addSubview(citySlider3)
         citySlider3.snp.makeConstraints { (make) in
         make.top.equalTo(topCityLabel.snp.bottom).offset(10)
         make.left.equalTo(citySlider2.snp.right).offset(13)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         let citySliderLabel3 = UILabel()
         //citySliderLabel3.text = self.cities[2]["_id"] as? String
         if   let lblslider = self.cities[2]["_id"] as? String{
         let lblsliderSeperate =  lblslider.components(separatedBy: " ")
         citySliderLabel3.text =   lblsliderSeperate.joined(separator: "\n")
         }
         citySliderLabel3.font = UIFont(name:K_Font_Color,size:12)
         citySliderLabel3.textAlignment = .center
         citySliderLabel3.numberOfLines = 3
         self.view.addSubview(citySliderLabel3)
         citySliderLabel3.snp.makeConstraints { (make) in
         make.center.equalTo(citySlider3)
         make.width.equalTo(sliderWidth)
         make.height.equalTo(sliderWidth)
         }
         
         
         
         //            let toprecentHeading = UILabel()
         //            toprecentHeading.text = "Recent Tastes"
         //            self.view.addSubview(toprecentHeading)
         //            toprecentHeading.snp.makeConstraints { (make) in
         //                make.left.equalTo(0)
         //                make.right.equalTo(0)
         //                make.top.equalTo(citySlider3.snp.bottom).offset(10)
         //            }
         //            toprecentHeading.textAlignment = .center
         //            // toprecentHeading.font = UIFont(name: K_Font_Color, size: 23)
         //            toprecentHeading.font = UIFont(name: K_Font_Color_Light, size: 23)
         
         
         
         }
         */
        
        //        let slider = RPCircularProgress()
        //        slider.trackTintColor = UIColor.lightGray
        //        slider.progressTintColor = UIColor.orange
        //        slider.thicknessRatio = 0.22
        //        slider.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
        //        let progress1 = 50
        //        slider.updateProgress(CGFloat((progress1 * 2)/100))
        //        self.view.addSubview(slider)
        //        slider.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCuisineLabel.snp.bottom).offset(20)
        //            make.left.equalTo(15)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let sliderLabel = UILabel()
        //        sliderLabel.text = "Chinese"
        //        sliderLabel.font = UIFont(name:K_Font_Color,size:14)
        //        sliderLabel.textAlignment = .center
        //        self.view.addSubview(sliderLabel)
        //        sliderLabel.snp.makeConstraints { (make) in
        //            make.center.equalTo(slider)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //
        //
        //        let slider2 = RPCircularProgress()
        //        slider2.trackTintColor = UIColor.lightGray
        //        slider2.progressTintColor = UIColor.gray
        //        slider2.thicknessRatio = 0.22
        //        slider2.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //slider2.updateProgress(0.5)
        //
        //        let progress2 = 1
        //        slider2.updateProgress(CGFloat((progress2 * 2)/100))
        //
        //        self.view.addSubview(slider2)
        //        slider2.snp.makeConstraints { (make) in
        //            make.top.equalTo(slider.snp.top)
        //            make.left.equalTo(slider.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let sliderLabel2 = UILabel()
        //        sliderLabel2.text = "Italian"
        //        sliderLabel2.textAlignment = .center
        //        sliderLabel2.font = UIFont(name:K_Font_Color,size:14)
        //        self.view.addSubview(sliderLabel2)
        //        sliderLabel2.snp.makeConstraints { (make) in
        //            make.center.equalTo(slider2)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //
        //        let slider3 = RPCircularProgress()
        //        slider3.trackTintColor = UIColor.lightGray
        //        slider3.progressTintColor = UIColor.brown
        //        slider3.thicknessRatio = 0.22
        //        slider3.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //slider3.updateProgress(0.5)
        //        let progress3 = 5
        //        slider3.updateProgress(CGFloat((progress3 * 5)/100))
        //        self.view.addSubview(slider3)
        //        slider3.snp.makeConstraints { (make) in
        //            make.top.equalTo(slider.snp.top)
        //            make.left.equalTo(slider2.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let sliderLabel3 = UILabel()
        //        sliderLabel3.text = "Steak House"
        //        sliderLabel3.font = UIFont(name:K_Font_Color,size:14)
        //        sliderLabel3.textAlignment = .center
        //        self.view.addSubview(sliderLabel3)
        //        sliderLabel3.snp.makeConstraints { (make) in
        //            make.center.equalTo(slider3)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        
        //        let topCityLabel = UILabel()
        //        topCityLabel.text = "Top Cities"
        //        self.view.addSubview(topCityLabel)
        //        topCityLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(0)
        //            make.right.equalTo(0)
        //            make.top.equalTo(slider.snp.bottom).offset(24)
        //        }
        //        topCityLabel.textAlignment = .center
        //        topCityLabel.font = UIFont(name:  K_Font_Color, size: 23)
        //
        //
        //        let citySlider = RPCircularProgress()
        //        citySlider.trackTintColor = UIColor.lightGray
        //        citySlider.progressTintColor = UIColor.blue
        //        citySlider.thicknessRatio = 0.22
        //        citySlider.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress4 = 2
        //        citySlider.updateProgress(CGFloat((progress4 * 2)/100))
        //        self.view.addSubview(citySlider)
        //        citySlider.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(15)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel = UILabel()
        //        citySliderLabel.text = "New York"
        //        citySliderLabel.textAlignment = .center
        //        self.view.addSubview(citySliderLabel)
        //        citySliderLabel.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySlider2 = RPCircularProgress()
        //        citySlider2.trackTintColor = UIColor.lightGray
        //        citySlider2.progressTintColor = UIColor.black
        //        citySlider2.thicknessRatio = 0.22
        //        citySlider2.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress5 = 2//Float(self.cities[1]["count"] as! Int)
        //        citySlider2.updateProgress(CGFloat((progress5 * 3)/100))
        //        self.view.addSubview(citySlider2)
        //        citySlider2.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(citySlider.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel2 = UILabel()
        //        citySliderLabel2.text = "Miami"//self.cities[1]["_id"] as? String
        //        citySliderLabel2.textAlignment = .center
        //        self.view.addSubview(citySliderLabel2)
        //        citySliderLabel2.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider2)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //
        //        let citySlider3 = RPCircularProgress()
        //        citySlider3.trackTintColor = UIColor.lightGray
        //        citySlider3.progressTintColor = UIColor.black
        //        citySlider3.thicknessRatio = 0.22
        //        citySlider3.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress6 = 2
        //        citySlider3.updateProgress(CGFloat((progress6 * 3)/100))
        //        self.view.addSubview(citySlider3)
        //        citySlider3.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(citySlider2.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel3 = UILabel()
        //        citySliderLabel3.text = "Miami"//self.cities[1]["_id"] as? String
        //        citySliderLabel3.textAlignment = .center
        //        self.view.addSubview(citySliderLabel3)
        //        citySliderLabel3.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider3)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        
    }
    
    func loadData()
    {
        
        let sliderWidth = (self.view.frame.size.width - 50)/3
        let titleLabel = UILabel()
        titleLabel.text = "INNER CIRCLE"
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
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        let upperProfileView = UIView()
        self.view.addSubview(upperProfileView)
        
        upperProfileView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(60)
            make.right.equalTo(-0)
            make.height.equalTo(220)
        }
        
        
        let imageView = UIImageView()
        upperProfileView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(30)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        
        
        if K_INNERUSER_PROFILE.image_url.characters.count > 0 {
            imageView.kf.setImage(with: URL(string:K_INNERUSER_PROFILE.image_url))
        }
            
        else
        {
            //            let strImage = "https://pbs.twimg.com/profile_images/621727263969558528/lZY2QPTF_200x200.jpg"
            //
            //            imageView.kf.setImage(with: URL(string:strImage))
            
            imageView.image = UIImage(named: "profile")
        }
        
        
        let nameLabel = UILabel()
        upperProfileView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.centerY.equalTo(imageView.snp.centerY).offset(-15)
        }
        nameLabel.text =  ""
        
        if K_INNERUSER_PROFILE.name.count > 0
        {
            nameLabel.text  = K_INNERUSER_PROFILE.name
            
        }
        
        nameLabel.font = UIFont(name:  K_Font_Color, size: 26)
        
        let subLabel = UILabel()
        upperProfileView.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        subLabel.text = ""
        if K_INNERUSER_PROFILE.company.count > 0
        {
            subLabel.text  = K_INNERUSER_PROFILE.company
            
        }
        
        
        subLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        let otherSubLabel = UILabel()
        upperProfileView.addSubview(otherSubLabel)
        otherSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(subLabel.snp.bottom).offset(5)
        }
        otherSubLabel.text = ""
        otherSubLabel.font = UIFont(name:  K_Font_Color, size: 13)
        
        let topCuisineLabel = UILabel()
        self.view.addSubview(topCuisineLabel)
        topCuisineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        topCuisineLabel.textAlignment = .center
        topCuisineLabel.text = "Top Cuisines"
        topCuisineLabel.font = UIFont(name:  K_Font_Color, size: 23)
        
        
        let slider = RPCircularProgress()
        slider.trackTintColor = UIColor.lightGray
        slider.progressTintColor = UIColor.orange
        slider.thicknessRatio = 0.22
        slider.enableIndeterminate(false) {
            print("done")
        }
        slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
        let progress1 = 50
        slider.updateProgress(CGFloat((progress1 * 2)/100))
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(topCuisineLabel.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        let sliderLabel = UILabel()
        sliderLabel.text = "Chinese"
        sliderLabel.font = UIFont(name:K_Font_Color,size:14)
        sliderLabel.textAlignment = .center
        self.view.addSubview(sliderLabel)
        sliderLabel.snp.makeConstraints { (make) in
            make.center.equalTo(slider)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        
        
        let slider2 = RPCircularProgress()
        slider2.trackTintColor = UIColor.lightGray
        slider2.progressTintColor = UIColor.gray
        slider2.thicknessRatio = 0.22
        slider2.enableIndeterminate(false) {
            print("done")
        }
        //slider2.updateProgress(0.5)
        
        let progress2 = 1
        slider2.updateProgress(CGFloat((progress2 * 2)/100))
        
        self.view.addSubview(slider2)
        slider2.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.top)
            make.left.equalTo(slider.snp.right).offset(13)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        let sliderLabel2 = UILabel()
        sliderLabel2.text = "Italian"
        sliderLabel2.textAlignment = .center
        sliderLabel2.font = UIFont(name:K_Font_Color,size:14)
        self.view.addSubview(sliderLabel2)
        sliderLabel2.snp.makeConstraints { (make) in
            make.center.equalTo(slider2)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        
        let slider3 = RPCircularProgress()
        slider3.trackTintColor = UIColor.lightGray
        slider3.progressTintColor = UIColor.brown
        slider3.thicknessRatio = 0.22
        slider3.enableIndeterminate(false) {
            print("done")
        }
        //slider3.updateProgress(0.5)
        let progress3 = 5
        slider3.updateProgress(CGFloat((progress3 * 5)/100))
        self.view.addSubview(slider3)
        slider3.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.top)
            make.left.equalTo(slider2.snp.right).offset(13)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        let sliderLabel3 = UILabel()
        sliderLabel3.text = "Steak House"
        sliderLabel3.font = UIFont(name:K_Font_Color,size:14)
        sliderLabel3.textAlignment = .center
        self.view.addSubview(sliderLabel3)
        sliderLabel3.snp.makeConstraints { (make) in
            make.center.equalTo(slider3)
            make.width.equalTo(sliderWidth)
            make.height.equalTo(sliderWidth)
        }
        
        //        let topCityLabel = UILabel()
        //        topCityLabel.text = "Top Cities"
        //        self.view.addSubview(topCityLabel)
        //        topCityLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(0)
        //            make.right.equalTo(0)
        //            make.top.equalTo(slider.snp.bottom).offset(24)
        //        }
        //        topCityLabel.textAlignment = .center
        //        topCityLabel.font = UIFont(name:  K_Font_Color, size: 23)
        //
        //
        //        let citySlider = RPCircularProgress()
        //        citySlider.trackTintColor = UIColor.lightGray
        //        citySlider.progressTintColor = UIColor.blue
        //        citySlider.thicknessRatio = 0.22
        //        citySlider.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress4 = 2
        //        citySlider.updateProgress(CGFloat((progress4 * 2)/100))
        //        self.view.addSubview(citySlider)
        //        citySlider.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(15)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel = UILabel()
        //        citySliderLabel.text = "New York"
        //        citySliderLabel.textAlignment = .center
        //        self.view.addSubview(citySliderLabel)
        //        citySliderLabel.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySlider2 = RPCircularProgress()
        //        citySlider2.trackTintColor = UIColor.lightGray
        //        citySlider2.progressTintColor = UIColor.black
        //        citySlider2.thicknessRatio = 0.22
        //        citySlider2.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress5 = 2//Float(self.cities[1]["count"] as! Int)
        //        citySlider2.updateProgress(CGFloat((progress5 * 3)/100))
        //        self.view.addSubview(citySlider2)
        //        citySlider2.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(citySlider.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel2 = UILabel()
        //        citySliderLabel2.text = "Miami"//self.cities[1]["_id"] as? String
        //        citySliderLabel2.textAlignment = .center
        //        self.view.addSubview(citySliderLabel2)
        //        citySliderLabel2.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider2)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //
        //        let citySlider3 = RPCircularProgress()
        //        citySlider3.trackTintColor = UIColor.lightGray
        //        citySlider3.progressTintColor = UIColor.black
        //        citySlider3.thicknessRatio = 0.22
        //        citySlider3.enableIndeterminate(false) {
        //            print("done")
        //        }
        //        //citySlider.updateProgress(0.5)
        //        let progress6 = 2
        //        citySlider3.updateProgress(CGFloat((progress6 * 3)/100))
        //        self.view.addSubview(citySlider3)
        //        citySlider3.snp.makeConstraints { (make) in
        //            make.top.equalTo(topCityLabel.snp.bottom).offset(20)
        //            make.left.equalTo(citySlider2.snp.right).offset(13)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        //        let citySliderLabel3 = UILabel()
        //        citySliderLabel3.text = "Miami"//self.cities[1]["_id"] as? String
        //        citySliderLabel3.textAlignment = .center
        //        self.view.addSubview(citySliderLabel3)
        //        citySliderLabel3.snp.makeConstraints { (make) in
        //            make.center.equalTo(citySlider3)
        //            make.width.equalTo(sliderWidth)
        //            make.height.equalTo(sliderWidth)
        //        }
        //
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black
        button.setTitle("INVITE TO INNER CIRCLE", for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(-64)
            make.height.equalTo(52)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        button.addTarget(self, action: #selector(self.continueTapped), for: .touchUpInside)
    }
    
    
    func declineAction(sender: UIButton!) {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //let parameter = ["user_id" :userRequestID,"friend_id":friendRequestID, "status":"Approved"]
        self.btndecline.isUserInteractionEnabled = false
        self.btnaccept.isUserInteractionEnabled = false
       // print(singelton.loginId, self.friendId)
        let parameter = ["user_id" :singelton.loginId,"friend_id":self.friendId, "status":"Reject"]
        // print(singelton.loginId, userRequestID,userAction)
      //  print(parameter)
        DataManager.sharedManager.invitationAcceptApi(params: parameter) { (response) in
            
            
            if let message = response as? String
                
            {
                  SVProgressHUD.dismiss()
                  self.view.isUserInteractionEnabled = true
               // print("message for invitation is \(message)")
                let alert = UIAlertController(title: "Taste", message:message as String, preferredStyle: UIAlertControllerStyle.alert)
                
                
                alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
                    self.btnaccept.isHidden = true
                    self.btndecline.isHidden = true
                
                  //  print("Handle accept logic here")
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//                    
//                    for aViewController:UIViewController in viewControllers {
//                        if aViewController.isKind(of: ProfileViewController.self) {
//                            self.btnaccept.isHidden = true
//                            self.btndecline.isHidden = true
//                            //   self.dismiss(animated: true, completion: nil)
//                            //                            _ = self.navigationController?.popToViewController(aViewController, animated: true)
//                        }
//                    }
                    
                }))
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)            }//end here
        }
        
        
        
    }
    
    func acceptAction(sender: UIButton!) {
        SVProgressHUD.show()
         self.view.isUserInteractionEnabled = false
        self.btndecline.isUserInteractionEnabled = false
        self.btnaccept.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //code addded as getting nil value when app in background
        K_INNERUSER_DATA.FriendIdGlobal = self.friendId
        //code addded as getting nil value when app in background
        K_INNERUSER_DATA.UserIdGlobal = singelton.loginId

        //let parameter = ["user_id" :userRequestID,"friend_id":friendRequestID, "status":"Approved"]
        
      //  print(singelton.loginId, self.friendId)
        let parameter = ["user_id" :singelton.loginId,"friend_id":self.friendId, "status":"Approved"]
        // print(singelton.loginId, userRequestID,userAction)
       // print(parameter)
        DataManager.sharedManager.invitationAcceptApi(params: parameter) { (response) in
            
            
            if let message = response as? String
                
            {
                
              //  print("message for invitation is \(message)")
                let alert = UIAlertController(title: "Taste", message:message as String, preferredStyle: UIAlertControllerStyle.alert)
                
                
                alert.addAction(UIAlertAction(title: "OK", style:.default, handler: { (action: UIAlertAction!) in
                    self.btnaccept.isHidden = true
                    self.btndecline.isHidden = true
                  

                    //self.btnaccept.isUserInteractionEnabled = true
                    self.HitNotificationInviteStatus(frindId: K_INNERUSER_DATA.FriendIdGlobal, userID: K_INNERUSER_DATA.UserIdGlobal)
                    
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//                    
//                    for aViewController:UIViewController in viewControllers {
//                        if aViewController.isKind(of: ProfileViewController.self) {
//                            self.btnaccept.isHidden = true
//                            self.btndecline.isHidden = true
//                            //self.btnaccept.isUserInteractionEnabled = true
//                             self.HitNotificationInviteStatus(frindId: K_INNERUSER_DATA.FriendIdGlobal, userID: K_INNERUSER_DATA.UserIdGlobal)
//                            //              self.dismiss(animated: true, completion: nil)
//                            //                                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
//                        }
//                    }
                    
                    
                   // print("Handle accept logic here")
                    SVProgressHUD.dismiss()
                      self.view.isUserInteractionEnabled = true
                    
                }))
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)            }//end here
        }
        
    }
    
    func continueTapped()
    {
       // delayWithSeconds(1.0)
       // {
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
            let singelton = SharedManager.sharedInstance
            //singelton.loginId = K_CURRENT_USER.login_Id
            // DataManager.sharedManager.inviteFriendApi(params: ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"friend_id":self.friendId]) { (response) in
           // print(singelton.loginId,self.friendId)
            DataManager.sharedManager.inviteFriendApi(params: ["user_id":singelton.loginId,"friend_id":self.friendId]) { (response) in
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true

                if let msg = response as? String
                {
                    let alert = UIAlertController(title: "Taste", message:msg, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
       // }
    }

}

