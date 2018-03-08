//
//  LoginViewController.swift
//  TasteApp
//
//  Created by Shubhank on 01/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
class LoginViewController: UIViewController {
    
    var userData = [[String:Any]]()
    var check = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
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
    }
    
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            //  make.top.equalTo(40)
            make.width.equalTo(570 * 0.5)//490
            make.height.equalTo(660 * 0.5)//580
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-10)
        }
        let titleLabel = UILabel()
        titleLabel.text = "T A S T E"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name:K_FONT_COLOR_Alethia, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(50)
        }
        
        //    let dividedHeight = (self.view.frame.size.height - 250)/3 - 15
        
        
        let firstImageView = UIImageView()
        let dividedHeight = (self.view.frame.size.height - 290)/3-25
        delayWithSeconds(2.0)
        {
            
            
            firstImageView.image = UIImage(named: "ic_idea")
            firstImageView.contentMode = .scaleAspectFit
            self.view.addSubview(firstImageView)
            firstImageView.snp.makeConstraints { (make) in
                make.right.equalTo(0)
                make.top.equalTo(titleLabel.snp.bottom).offset(25)
                make.width.equalTo(dividedHeight)
                make.height.equalTo(dividedHeight)
            }
            
            let firstInfo = UILabel()
            firstInfo.text = "Receive suggestions from your dining history and tendencies."
            firstInfo.numberOfLines = 4
            firstInfo.font = UIFont(name:K_Font_Color_Light, size: 18)
            self.view.addSubview(firstInfo)
            firstInfo.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.centerY.equalTo(firstImageView.snp.centerY)
                make.right.equalTo(firstImageView.snp.left).offset(-10)
                
            }
        }
        let secondImageView = UIImageView()
        delayWithSeconds(4.0)
        {
            secondImageView.image = UIImage(named: "ic_graph")
            secondImageView.contentMode = .scaleAspectFit
            self.view.addSubview(secondImageView)
            secondImageView.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(firstImageView.snp.bottom).offset(58)
                make.width.equalTo(dividedHeight)
                make.height.equalTo(dividedHeight)
            }
            
            let secondInfo = UILabel()
            secondInfo.text = "Connect your bank statement for personal dining analytics and automatic updates"
            secondInfo.numberOfLines = 4
            secondInfo.font = UIFont(name: K_Font_Color_Light, size: 18)
            self.view.addSubview(secondInfo)
            secondInfo.snp.makeConstraints { (make) in
                make.right.equalTo(-2)
                make.width.equalTo(200)
                make.top.equalTo(firstImageView.snp.bottom).offset(58)
                //  make.centerY.equalTo(secondImageView.snp.centerY)
                // make.left.equalTo(secondImageView.snp.right).offset(50)
            }
        }
        delayWithSeconds(6.0)
        {
            let thirdImageView = UIImageView()
            thirdImageView.image = UIImage(named: "In-Black")//ic_linkedin
            thirdImageView.contentMode = .scaleAspectFit
            self.view.addSubview(thirdImageView)
            thirdImageView.snp.makeConstraints { (make) in
                make.right.equalTo(-20)
                make.top.equalTo(secondImageView.snp.bottom).offset(60)
                make.width.equalTo(dividedHeight)
                make.height.equalTo(dividedHeight)
            }
            let thirdInfo = UILabel()
            thirdInfo.text = "Sign up with LinkedIn to add colleagues to your inner circle."
            thirdInfo.numberOfLines = 4
            thirdInfo.font = UIFont(name: K_Font_Color_Light, size: 18)
            self.view.addSubview(thirdInfo)
            thirdInfo.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.centerY.equalTo(thirdImageView.snp.centerY)
                make.right.equalTo(thirdImageView.snp.left).offset(-20)
            }
        }
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named:"linkedin-login-btn"), for: .normal)//btn-signin-blue
        //button.backgroundColor = UIColor.blue
        // button.backgroundColor = UIColor(red: 49.0/255.0, green: 116.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        //        button.setTitle("SIGN IN WITH LinkedIn", for: .normal)
        //        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.height.equalTo(61)
            make.width.equalTo(330)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        button.addTarget(self, action: #selector(self.loginTapped), for: .touchUpInside)
        
        
        let btnTerms = UIButton(type: .custom)
        btnTerms.setImage(UIImage(named:"ic_check"), for: .normal)
        self.view.addSubview(btnTerms)
        btnTerms.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(button.snp.top).offset(-40)
        }
        btnTerms.addTarget(self, action: #selector(self.btnTermsClick), for: .touchUpInside)
        
        let titleTerms = UILabel()
        //titleTerms.text = "I agree to terms and conditions"
        titleTerms.attributedText = NSAttributedString(string:"By signing in, I agree to all terms and conditions", attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        titleTerms.textAlignment = .natural
        titleTerms.numberOfLines = 1
        titleTerms.font = UIFont(name: K_Font_Color, size: 15)
        self.view.addSubview(titleTerms)
        titleTerms.snp.makeConstraints { (make) in
            make.left.equalTo(btnTerms.snp.left).offset(32)
            make.centerY.equalTo(btnTerms.snp.centerY).offset(5)
        }
        
        
        titleTerms.isUserInteractionEnabled = true
        titleTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapFunction)))
    }
    
    
    
    func tapFunction()
    {
        
//        let vc = TermsViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RTermsVc") as! RTermsVc
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func btnTermsClick(sender:UIButton)
    {
        if check
        {
            sender.setImage(UIImage(named:"ic_uncheck"), for: .normal)
            check = false}
        else
        {
            sender.setImage(UIImage(named:"ic_check"), for: .normal)
            check = true
        }
    }
    
    
    func loadData()
    {
        /* let loginId = self.userData[0]["_id"] as? String
         print("login id in login controller \(loginId!)")
         K_CURRENT_USER.login_Id = loginId!
         let bankCount = self.userData[0]["total_bank"] as! Int
         print("bank count is \(bankCount) that")
         let defaults = UserDefaults.standard
         defaults.set(loginId!, forKey: "user_id")
         defaults.set(bankCount, forKey: "bankcount")
         defaults.synchronize()
         */
        
        if let loginId = self.userData[0]["_id"] as? String{
            K_CURRENT_USER.login_Id = loginId
        }
        else{
            K_CURRENT_USER.login_Id = ""
        }
        
        if let profile = self.userData[0]["profile"] as? [String:Any]{
            
            if let fName = profile["firstname"] as? String{
                K_CURRENT_USER.name = fName
            }
            if let lName = profile["lastname"] as? String{
                K_CURRENT_USER.lname = lName
            }
            if let companyName = profile["company_name"] as? String{
                K_CURRENT_USER.company = companyName
            }
            if let desination = profile["designation"] as? String{
                K_CURRENT_USER.designation = desination
            }
            if let email = profile["email"] as? String{
                K_CURRENT_USER.email = email
            }
            if let image = profile["image"] as? String{
               K_CURRENT_USER.image_url = K_IMAGE_BASE_URL + image
            }
            else{
                K_CURRENT_USER.image_url = ""
            }
            if let selectedMiles = profile["user_selected_miles"] as? String{
                K_CURRENT_USER.selected_miles = selectedMiles
            }
            else{
                 K_CURRENT_USER.selected_miles = "0.5"
            }
        }
        
        let singelton = SharedManager.sharedInstance
        singelton.loginId = K_CURRENT_USER.login_Id
        self.saveUserProfileData(firstName:  K_CURRENT_USER.name, lastName: K_CURRENT_USER.lname, companyName:  K_CURRENT_USER.company, designation: K_CURRENT_USER.designation, email:  K_CURRENT_USER.email, userId:  K_CURRENT_USER.login_Id, linkedinId: K_CURRENT_USER.user_id, imageUrl: K_CURRENT_USER.image_url,selected_miles:K_CURRENT_USER.selected_miles)
        
        
        self.getTransactionCount()
        
    }
    func saveUserProfileData(firstName:String, lastName:String,companyName:String, designation: String, email: String, userId: String, linkedinId: String, imageUrl:String, selected_miles:String)  {
        let plistFileName = "data.plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        //saving values
        dict.setObject(firstName, forKey:  "firstName" as NSCopying)
        dict.setObject(lastName, forKey:  "lastName" as NSCopying)
        dict.setObject(companyName, forKey:  "companyName" as NSCopying)
        dict.setObject(designation, forKey:  "designation" as NSCopying)
        dict.setObject(email, forKey:  "email" as NSCopying)
        dict.setObject(userId, forKey:  "userId" as NSCopying)
        dict.setObject(linkedinId, forKey:  "linkedinId" as NSCopying)
        dict.setObject(imageUrl, forKey:  "imageUrl" as NSCopying)
        dict.setObject(selected_miles, forKey: "selected_miles" as NSCopying)
        //dict.removeObject(forKey: "firstName")
        
        //writing to Data.plist
        dict.write(toFile: plistPath, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: plistPath)
        // print("Saved Data.plist file is --> \(resultDictionary?.description)")
        
    }
    
    
    
    //    func getTransactionCount() {
    //      //  print(K_CURRENT_USER.login_Id)
    //        let parameter=["user_id":K_CURRENT_USER.login_Id] as [String : Any]
    //        DataManager.sharedManager.transactionCount(params: parameter) { (response) in
    //            if let count = response as? Int
    //            {  if  count > 0
    //                {
    //                    SVProgressHUD.dismiss()
    //                    let vc = ProfileBeingCreatedViewController()
    //                    let navVC = UINavigationController(rootViewController: vc)
    //                    navVC.isNavigationBarHidden = true
    //                    self.present(navVC, animated: true, completion: nil)
    //                }
    //                else{
    //                 SVProgressHUD.dismiss()
    //                let vc = BanksListViewController()
    //                let navVC = UINavigationController(rootViewController: vc)
    //                navVC.isNavigationBarHidden = true
    //                self.present(navVC, animated: true, completion: nil)
    //
    //                }
    //            }
    //            else{
    //                 SVProgressHUD.dismiss()
    //                let vc = BanksListViewController()
    //                let navVC = UINavigationController(rootViewController: vc)
    //                navVC.isNavigationBarHidden = true
    //                self.present(navVC, animated: true, completion: nil)
    //            }
    //        }
    //
    //    }
    func getTransactionCount() {
        print(K_CURRENT_USER.login_Id)
        let parameter=["user_id":K_CURRENT_USER.login_Id] as [String : Any]
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
                    SVProgressHUD.dismiss()
                    let vc = ProfileBeingCreatedViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isNavigationBarHidden = true
                    self.present(navVC, animated: true, completion: nil)
                }
                else{
                    SVProgressHUD.dismiss()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        super.viewWillDisappear(animated)
    }
    
    func loginTapped()
    {
        if !check
        {
            let alert = UIAlertController(title: "Taste", message:"Please accept the terms and conditions.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if Reachability.isConnectedToNetwork() == true
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
//            print(LISDKSessionManager.sharedInstance().session.isValid())
//            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,  LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: false, successBlock: { (successState) in
//                print(successState)
//
//                SVProgressHUD.show()
//                let session = LISDKSessionManager.sharedInstance().session
//                print(session)
//                LISDKAPIHelper.sharedInstance().apiRequest("https://www.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,positions:(title,company),pictureUrls::(original))", method: "GET", body: Data(), success: { (response) in
//                    print(response?.data)
//                    do {
//                        let data = response?.data.data(using: String.Encoding.utf8)
//                        if let userDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
//                        {
//                             self.view.isUserInteractionEnabled = false
//                            if   let linkedIn_id = userDic["id"] as? String{
//                                K_CURRENT_USER.user_id = linkedIn_id
//                            }
//                            else{
//                                K_CURRENT_USER.user_id = ""
//                            }
//
//
//                            if  let firstName = userDic["firstName"] as? String{
//                                K_CURRENT_USER.name = firstName
//                            }
//                            else{
//                                K_CURRENT_USER.name = ""
//                            }
//                            if  let lastName = userDic["lastName"] as? String{
//                                K_CURRENT_USER.lname = lastName
//
//                            }
//                            else{
//                                K_CURRENT_USER.lname = ""
//                            }
//
//                            if  let email = userDic["emailAddress"] as? String{
//                                K_CURRENT_USER.email = email
//                            }
//                            else{
//                                K_CURRENT_USER.email = ""
//                            }
//
//
//                            if   let Designation = userDic["positions"] as? [String:Any]{
//                                if  let values = Designation["values"] as? [[String:Any]]{
//                                    for item in values
//                                    {
//                                        if let title = item["title"] as? String{
//                                            K_CURRENT_USER.designation = title
//                                        }
//                                    }
//                                }
//                            }
//                            else{
//                                K_CURRENT_USER.designation = ""
//                            }
//
//
//
//
//                            if let positionsDict = userDic["positions"] as? [String:Any] {
//                                if let valuesArr = positionsDict["values"] as? [[String:Any]] {
//                                    if valuesArr.count > 0 {
//                                        let positionOb = valuesArr[0]
//                                        if let companyDict = positionOb["company"] as? [String:Any] {
//                                            if  let nameOfComp = companyDict["name"] as? String{
//                                                K_CURRENT_USER.company = nameOfComp
//                                            }
//
//
//                                        }
//                                    }
//                                }
//                            }
//                            else{
//                                K_CURRENT_USER.company = ""
//
//                            }
//
//
//                            if let response = userDic["pictureUrls"] as? [String:Any]
//                            {
//                                if  let aarti = response["values"] as? NSArray
//
//                                {
//                                    if aarti.count > 0
//                                    {
//                                        let positionOb = aarti[0]
//                                      //  print("picture string is \(positionOb)")
//
//                                        K_CURRENT_USER.image_url = positionOb as! String
//                                        // params["profile_image"] = positionOb as! String
//
//                                    }
//                                }
//                                else{
//                                    K_CURRENT_USER.image_url = ""
//                                }
//                            }
//                            else{
//                                K_CURRENT_USER.image_url = "http://www.iaimhealthcare.com/images/doctor/no-image.jpg"
//                            }
//
//                            let singelton = SharedManager.sharedInstance
//                            let deviceToken = singelton.deviceToken
//                          //  print(UIDevice.current.name)
//
//                            var params = ["is_linkedin_user":"true",
//                                          "linkedin_key": K_CURRENT_USER.user_id,
//                                          "firstname":  K_CURRENT_USER.name,
//                                          "lastname": K_CURRENT_USER.lname,
//                                          "company_name":K_CURRENT_USER.company,
//                                          "designation":K_CURRENT_USER.designation,
//                                          "email": K_CURRENT_USER.email,
//                                          "profile_image":K_CURRENT_USER.image_url,
//                                          "profile_type" :"public",
//                                          "has_device_key" : "true",
//                                          "device_os"  : "ios",
//                                          "deviceuid" : deviceToken,
//                                          "device_name" : UIDevice.current.name] as [String : Any]
//
//
//
//                            DataManager.sharedManager.login(params: params , completion: { (response) in
//
//
//                                if let dataDic = response as? [[String:Any]]
//                                {
//
//                                    self.userData  = dataDic
//                                     self.loadData()
//                                }
//                                else{
//                                    if Reachability.isConnectedToNetwork() != true
//                                    {
//                                        let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
//                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                                            UIAlertAction in
//                                            NSLog("OK Pressed")
//                                        }
//                                        alert.addAction(okAction)
//                                        self.present(alert, animated: true, completion: nil)
//                                        return
//                                    }
//                                    else{
//                                        let alert = UIAlertController(title: "Taste", message:K_Internet_Message, preferredStyle: UIAlertControllerStyle.alert)
//                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                                            UIAlertAction in
//                                            NSLog("OK Pressed")
//                                        }
//                                        alert.addAction(okAction)
//                                        self.present(alert, animated: true, completion: nil)
//                                        return
//
//                                    }
//                                }
//
//
//
//                            })
//
//                        }
//
//                    } catch let error as NSError {
//                        print(error)
//                    }
//                },
//                    error: { (error) in
//                })
//
//            })
//            {
//                (error) in
//
//                if (error != nil)
//
//                {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController")
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
//
//                print("yes we are here")
//
//            }
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
        
    }//login tapped end
    
    
    
}
