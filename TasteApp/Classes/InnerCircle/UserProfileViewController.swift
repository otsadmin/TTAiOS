//
//  UserProfileViewController.swift
//  TasteApp
//
//  Created by Shubhank on 06/03/17.
//  Copyright Â© 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class UserProfileViewController: UIViewController {
    
    // for phone book user
    var thumbImage:UIImage? = UIImage()
    var phoneBookUser:String = ""
    var firstName: String = ""
    var userEmail:String = ""
    
    var btnForTTAUser = UIButton()
    var btnForNonTTAUser = UIButton()
    
    var screenName :String?
    var friendId : String = ""
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
    //let toprecentHeading = UILabel()
    
    var f = 0.0,f1 = 0.0,f2 = 0.0
    
    var c = 0.0,c1 = 0.0,c2 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("friend id is \(self.friendId)")
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
        
        if phoneBookUser == "phonebookUser"{
            
            self.loadStrangerData()
        }
        else {
            self.setupView()
        }
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        //  _ =  self.navigationController?.popViewController(animated: true)
        super.viewWillDisappear(animated)
    }
    
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showCuisine1()
    {
    }
    func setupView() {
        
        
        
        self.view.backgroundColor = UIColor.white
        delayWithSeconds(1.0)
        {
            SVProgressHUD.show()
            
            // let parameter = ["userid":UserDefaults.standard.string(forKey: "user_id")!,"stranger_id": self.friendId as String ]
            let singelton = SharedManager.sharedInstance
            // singelton.loginId = K_CURRENT_USER.login_Id
            let parameter = ["userid":singelton.loginId,"stranger_id": self.friendId as String ]
            print(self.friendId,parameter)
            DataManager.sharedManager.getInnerCircleUserProfile(params: parameter, completion: { (response) in
                
                if let dataDic = response as? [String:Any]
                    
                {
                    print(dataDic)
                    
                    if let profilearr = dataDic["profile"] as? [[String:Any]]
                    {
                        self.userProfile = profilearr
                        print(self.userProfile.count)
                        
                        
                        if self.userProfile.count > 0 {
                            let positionOb = self.userProfile[0]
                            print(positionOb)
                            if let companyDict = positionOb["profile"] as? [String:Any]
                            {
                                print(companyDict)
                                K_INNERUSER_PROFILE.name = companyDict["firstname"] as! String
                                K_INNERUSER_PROFILE.lastname = companyDict["lastname"] as! String
                                K_INNERUSER_PROFILE.company = companyDict["company_name"] as! String
                                K_INNERUSER_PROFILE.email = companyDict["email"] as! String
                                
                                if self.phoneBookUser == "phonebookUser"{
                                    
                                }
                                //                                else if self.phoneBookUser == "friend"{
                                //
                                //                                    self.checkStatusForTTAUserInvite(friendId: K_INNERUSER_PROFILE.email, btn: self.btnForTTAUser)
                                //                                }
                                
                                
                                
                                if  let imageUrl = companyDict["image"] as? String{
                                    print("---",imageUrl.characters.count)
                                    if imageUrl.characters.count > 0{
                                        K_INNERUSER_PROFILE.image_url = K_IMAGE_BASE_URL + imageUrl
                                    }
                                    else{
                                        K_INNERUSER_PROFILE.image_url = ""
                                    }
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
                            K_INNERUSER_PROFILE.email = ""
                        }
                    }
                    else{
                        K_INNERUSER_PROFILE.name = ""
                        K_INNERUSER_PROFILE.lastname = ""
                        K_INNERUSER_PROFILE.company = ""
                        K_INNERUSER_PROFILE.image_url = ""
                        K_INNERUSER_PROFILE.email = ""
                    }
                    if let cuisineArr = dataDic["top_cuisine"] as? [[String:Any]] {
                        self.cuisines = cuisineArr
                        
                    }
                    if let citiesArr = dataDic["top_cities"] as? [[String:Any]] {
                        self.cities = citiesArr
                    }
                    
                }
                else{
                    SVProgressHUD.dismiss()
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

                DispatchQueue.main.async {
                    
                    
                    self.loadDataNew()
                    
                    SVProgressHUD.dismiss()
                }
            })
        }
    }//clase setup
    
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
        
        imageView.sd_setImage(with: URL(string: K_INNERUSER_PROFILE.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
        
        //        if K_INNERUSER_PROFILE.image_url.characters.count > 0 {
        //           // imageView.kf.setImage(with: URL(string:K_INNERUSER_PROFILE.image_url))
        //        }
        //
        //        else
        //        {
        //            //            let strImage = "https://pbs.twimg.com/profile_images/621727263969558528/lZY2QPTF_200x200.jpg"
        //            //
        //            //            imageView.kf.setImage(with: URL(string:strImage))
        //
        //            imageView.image = UIImage(named: "profile")
        //        }
        
        
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
            //print(K_INNERUSER_PROFILE.user_id)
            
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
            btnForTTAUser = UIButton(type: .custom)
            btnForTTAUser.backgroundColor = UIColor.black
            btnForTTAUser.titleLabel?.adjustsFontSizeToFitWidth = true
            //            btnForTTAUser.titleLabel?.minimumScaleFactor = 0.2
            btnForTTAUser.setTitle("INVITE TO INNER CIRCLE", for: .normal)
            self.view.addSubview(btnForTTAUser)
            btnForTTAUser.snp.makeConstraints { (make) in
                make.bottom.equalTo(-64)
                make.height.equalTo(52)
                make.left.equalTo(10)
                make.right.equalTo(-10)
            }
            self.checkStatusForTTAUserInvite(friendId: self.friendId)
            btnForTTAUser.addTarget(self, action: #selector(self.continueTapped), for: .touchUpInside)
            self.btnForTTAUser.isHidden = true
        }
        /*
        //for slider
        if self.cuisines.count >= 1 ||  self.cities.count >= 1{
        }
        else{
            return
        }
        
        for number in 0..<(self.cuisines.count-1)
            
        {
            let circle1 = Float(self.cuisines[number]["count"] as! Int)
            
            cuisineCount = cuisineCount + circle1
        }
        //        for number in 0..<(self.cities.count-1)
        //
        //        {
        //            let circle1 = Float(self.cities[number]["count"] as! Int)
        //
        //            cityCount = cityCount + circle1
        //        }
        let sliderWidth = (self.view.frame.size.width - 50)/3
        
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
        if self.cuisines.count == 1
        {
            
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
                print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            // sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
        }//count city 1
            
            
        else if self.cuisines.count == 2
        {
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
                print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            //sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let slider2 = RPCircularProgress()
            slider2.trackTintColor = UIColor.lightGray
            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            slider2.thicknessRatio = 0.22
            slider2.enableIndeterminate(false) {
                print("done")
            }
            //slider2.updateProgress(0.5)
            // slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            let progress2 = Float(self.cuisines[1]["count"] as! Int)
            
            let variable1 = CGFloat(progress2/cuisineCount)
            
            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
                f1 = Double(CGFloat(n))
            }
            
            
            //slider2.updateProgress(0.8,animated:true)
            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
            slider2.updateProgress(CGFloat(f1))
            
            
            self.view.addSubview(slider2)
            slider2.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel2 = UILabel()
            // sliderLabel2.text = self.cuisines[1]["_id"] as? String
            if   let lblslider = self.cuisines[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel2.textAlignment = .center
            sliderLabel2.numberOfLines = 2
            self.view.addSubview(sliderLabel2)
            sliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(slider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
        }
            
        else
            
        {
            
            //count 3 hain
            
            slider = RPCircularProgress()
            slider.trackTintColor = UIColor.lightGray
            slider.progressTintColor = UIColor(red: 135.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            slider.thicknessRatio = 0.22
            slider.enableIndeterminate(false) {
                print("done")
            }
            
            slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine1)))
            let progress1 = Float(self.cuisines[0]["count"] as! Int)
            
            
            let variable = CGFloat(progress1/cuisineCount)
            
            let twoDecimalPlaces = String(format: "%.3f",variable)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces) {
                f = Double(CGFloat(n))
            }
            
            slider.updateProgress(CGFloat(f))
            // slider.updateProgress(CGFloat((progress1/100))
            //slider.updateProgress(0.6,animated:true)
            self.view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.top.equalTo(topCuisineLabel.snp.bottom).offset(10)
                make.left.equalTo(15)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel = UILabel()
            
            // sliderLabel.text = self.cuisines[0]["_id"] as? String
            if   let lblslider = self.cuisines[0]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel.text =   lblsliderSeperate.joined(separator: "\n")
            }
            sliderLabel.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel.textAlignment = .center
            sliderLabel.numberOfLines = 3
            self.view.addSubview(sliderLabel)
            sliderLabel.snp.makeConstraints { (make) in
                make.center.equalTo(slider)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            
            
            let slider2 = RPCircularProgress()
            slider2.trackTintColor = UIColor.lightGray
            slider2.progressTintColor = UIColor(red: 139.0/255.0, green: 125.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            slider2.thicknessRatio = 0.22
            slider2.enableIndeterminate(false) {
                print("done")
            }
            //slider2.updateProgress(0.5)
            //  slider2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine2)))
            let progress2 = Float(self.cuisines[1]["count"] as! Int)
            
            let variable1 = CGFloat(progress2/cuisineCount)
            
            let twoDecimalPlaces1 = String(format: "%.3f",variable1)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces1) {
                f1 = Double(CGFloat(n))
            }
            
            
            //slider2.updateProgress(0.8,animated:true)
            //slider2.updateProgress(CGFloat((progress2 * 3)/100))
            slider2.updateProgress(CGFloat(f1))
            
            
            self.view.addSubview(slider2)
            slider2.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel2 = UILabel()
            
            //  sliderLabel2.text = self.cuisines[1]["_id"] as? String
            
            if   let lblslider = self.cuisines[1]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel2.text =   lblsliderSeperate.joined(separator: "\n")
            }
            sliderLabel2.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel2.textAlignment = .center
            sliderLabel2.numberOfLines = 2
            self.view.addSubview(sliderLabel2)
            sliderLabel2.snp.makeConstraints { (make) in
                make.center.equalTo(slider2)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let slider3 = RPCircularProgress()
            slider3.trackTintColor = UIColor.lightGray
            slider3.progressTintColor = UIColor(red: 77.0/255.0, green: 124.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            slider3.thicknessRatio = 0.22
            slider3.enableIndeterminate(false) {
                print("done")
            }
            //slider3.updateProgress(0.5)
            let progress3 = Float(self.cuisines[2]["count"] as! Int)
            
            
            
            let variable3 = CGFloat(progress3/cuisineCount)
            
            let twoDecimalPlaces3 = String(format: "%.3f",variable3)
            
            
            
            if let n = NumberFormatter().number(from: twoDecimalPlaces3)
            {
                f2 = Double(CGFloat(n))
            }
            
            
            slider3.updateProgress(CGFloat(f2))
            // slider3.updateProgress(CGFloat((progress3 * 2)/100))
            //slider3.updateProgress(0.2,animated:true)
            //  slider3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showCuisine3)))
            self.view.addSubview(slider3)
            slider3.snp.makeConstraints { (make) in
                make.top.equalTo(slider.snp.top)
                make.left.equalTo(slider2.snp.right).offset(13)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
            let sliderLabel3 = UILabel()
            // sliderLabel3.text = self.cuisines[2]["_id"] as? String
            
            if   let lblslider = self.cuisines[2]["_id"] as? String{
                let lblsliderSeperate =  lblslider.components(separatedBy: " ")
                sliderLabel3.text =   lblsliderSeperate.joined(separator: "\n")
            }
            
            
            sliderLabel3.font = UIFont(name:K_Font_Color,size:12)
            sliderLabel3.textAlignment = .center
            sliderLabel3.numberOfLines = 2
            self.view.addSubview(sliderLabel3)
            sliderLabel3.snp.makeConstraints { (make) in
                make.center.equalTo(slider3)
                make.width.equalTo(sliderWidth)
                make.height.equalTo(sliderWidth)
            }
            
        }
        */
        
    }
    
    func loadStrangerData()->Void{
        
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
        
        if (thumbImage != nil) {
            imageView.image = thumbImage
        }else{
            
            imageView.image = UIImage(named:"TasteInnerCircleIcon")
        }
        
        // imageView.sd_setImage(with: URL(string: K_INNERUSER_PROFILE.image_url), placeholderImage: UIImage(named: "TasteInnerCircleIcon"))
        
        let nameLabel = UILabel()
        upperProfileView.addSubview(nameLabel)
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            // make.centerY.equalTo(userImageView).offset(-30)//change here
            make.top.equalTo(imageView.snp.top)
            make.right.equalTo(-10)
        }
        nameLabel.text = firstName
        nameLabel.font = UIFont(name: K_Font_Color, size: 26)
        
        let subLabel = UILabel()
        upperProfileView.addSubview(subLabel)
        subLabel.numberOfLines = 1
        subLabel.adjustsFontSizeToFitWidth = true
        subLabel.minimumScaleFactor = 0.2
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.right.equalTo(-10)
        }
        subLabel.text = userEmail
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
            btnForNonTTAUser = UIButton(type: .custom)
            btnForNonTTAUser.backgroundColor = UIColor.black
            //btnForNonTTAUser.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
            btnForNonTTAUser.setNeedsLayout()
            btnForNonTTAUser.titleLabel?.adjustsFontSizeToFitWidth = true
            //            btnForNonTTAUser.titleLabel?.minimumScaleFactor = 0.2
            btnForNonTTAUser.setTitle("INVITE TO TASTE APP", for: .normal)
            self.view.addSubview(btnForNonTTAUser)
            btnForNonTTAUser.snp.makeConstraints { (make) in
                make.bottom.equalTo(-64)
                make.height.equalTo(52)
                make.left.equalTo(10)
                make.right.equalTo(-10)
            }
            self.checkStatusForInvite(friendEmail:userEmail)
            btnForNonTTAUser.addTarget(self, action: #selector(self.inviteForNonTTAUser), for: .touchUpInside)
            btnForNonTTAUser.isHidden = true
        }
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        if phoneBookUser == "phonebookUser"{
    //
    //            self.checkStatusForInvite(friendEmail:userEmail)
    //        }
    //        else if phoneBookUser == "friend"{
    //
    //            self.checkStatusForTTAUserInvite(friendId:friendId)
    //        }
    //    }
    
    func continueTapped()
    {
        // delayWithSeconds(1.0)
        //{
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        // DataManager.sharedManager.inviteFriendApi(params: ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"friend_id":self.friendId]) { (response) in
        print(singelton.loginId,self.friendId)
        DataManager.sharedManager.inviteFriendApi(params: ["user_id":singelton.loginId,"friend_id":self.friendId]) { (response) in
            
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if let responseGet = response as? String{
                if responseGet == "" {
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
            
            var resultDict = [String: Any]()
            resultDict = response as! [String : Any]
            let status = resultDict["status"] as? String
            
            if status == "success"
            {
                let alert = UIAlertController(title: "Taste", message:resultDict["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                self.btnForTTAUser.titleLabel?.text = "INVITE ALREADY SENT"
                self.btnForTTAUser.isUserInteractionEnabled = false
                self.btnForTTAUser.isUserInteractionEnabled = false
                return
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
        //}
    }
    func inviteForNonTTAUser(){
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        // DataManager.sharedManager.inviteFriendApi(params: ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"friend_id":self.friendId]) { (response) in
        print(singelton.loginId,self.friendId)
        DataManager.sharedManager.inviteNonTTAUser(params: ["user_id":singelton.loginId,"sender_name":"\(K_CURRENT_USER.name) \(K_CURRENT_USER.lname)","fnd_name":self.firstName,"fnd_email":self.userEmail]) { (response) in
            
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if let responseGet = response as? String{
                if responseGet == "" {
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
            
            var resultDict = [String: Any]()
            resultDict = response as! [String : Any]
            let status = resultDict["status"] as? String
            if status == "success"
            {
                let alert = UIAlertController(title: "Taste", message:resultDict["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                self.btnForNonTTAUser.titleLabel?.text = "INVITE ALREADY SENT"
                self.btnForNonTTAUser.isUserInteractionEnabled = false
                self.btnForNonTTAUser.isUserInteractionEnabled = false
                return
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
    
    
    
    
    func checkStatusForInvite(friendEmail:String){
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        // DataManager.sharedManager.inviteFriendApi(params: ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"friend_id":self.friendId]) { (response) in
        print(singelton.loginId,self.friendId)
        DataManager.sharedManager.checkFriendInviteStatus(params: ["user_id":singelton.loginId,"friend_email":friendEmail,"invite_type":"company_invite","friend_id":""]) { (response) in
            
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if let responseGet = response as? String{
                if responseGet == "" {
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
            
            self.btnForNonTTAUser.isHidden = false
            self.view.isUserInteractionEnabled = true
            var resultDict = [String: Any]()
            resultDict = response as! [String : Any]
            
            if let msg = resultDict["data"] as? String
            {
                if msg == "SEND_BY_USER"{
                    
                    self.btnForNonTTAUser.titleLabel?.text = "INVITE ALREADY SENT"
                    self.btnForNonTTAUser.isUserInteractionEnabled = false
                    
                }
                else if msg == "REQUEST_NOT_SEND"{
                    
                    self.btnForNonTTAUser.titleLabel?.text = "INVITE TO TASTE APP"
                    self.btnForNonTTAUser.isUserInteractionEnabled = true
                }
                
                //                let alert = UIAlertController(title: "Taste", message:msg, preferredStyle: UIAlertControllerStyle.alert)
                //                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                //                {
                //                    UIAlertAction in
                //                    NSLog("OK Pressed")
                //                }
                //                alert.addAction(okAction)
                //                self.present(alert, animated: true, completion: nil)
                //                return
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
    
    func checkStatusForTTAUserInvite(friendId:String){
        
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        // DataManager.sharedManager.inviteFriendApi(params: ["user_id":UserDefaults.standard.string(forKey: "user_id")!,"friend_id":self.friendId]) { (response) in
        print(singelton.loginId,self.friendId)
        DataManager.sharedManager.checkFriendInviteStatus(params: ["user_id":singelton.loginId,"friend_email":"","invite_type":"inner_circle_invite","friend_id":self.friendId]) { (response) in
            
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if let responseGet = response as? String{
                if responseGet == "" {
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
            
            self.btnForTTAUser.isHidden = false
            var resultDict = [String: Any]()
            resultDict = response as! [String : Any]
            
            if let msg = resultDict["data"] as? String
            {
                if msg == "SEND_BY_USER"{
                    
                    self.btnForTTAUser.titleLabel?.text = "INVITE IS ALREADY SENT"
                    //self.btnForTTAUser.backgroundColor = UIColor.lightGray
                    self.btnForTTAUser.isUserInteractionEnabled = false
                    
                }
                else if msg == "REQUEST_NOT_SEND"{
                    
                    self.btnForTTAUser.titleLabel?.text = "INVITE TO INNER CIRCLE"
                    //self.btnForTTAUser.backgroundColor = UIColor.black
                    self.btnForTTAUser.isUserInteractionEnabled = true
                }
                               //                let alert = UIAlertController(title: "Taste", message:msg, preferredStyle: UIAlertControllerStyle.alert)
                //                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                //                {
                //                    UIAlertAction in
                //                    NSLog("OK Pressed")
                //                }
                //                alert.addAction(okAction)
                //                self.present(alert, animated: true, completion: nil)
                //                return
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
    
}

