//
//  BankLoginViewController.swift
//  TasteApp
//
//  Created by Shubhank on 08/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift
import Contacts
import Alamofire

class BankLoginViewController: UIViewController,UITextFieldDelegate
{
    //MARK:VARIABLE DECLARATION
    
    var bank:[String:Any]?
    var userIDField:UITextField!
    var passtextField:UITextField!
    var arrData = [[String:Any]]()
    var imageLogo :String = ""
    var replaced:String = ""
    var providerAccountID : String = ""
    var apiHitProcessToUpdate : Bool = false
     var provider_ID : Int = 0
     var bankAdded:Bool = false
     var isUpdateBank:Bool = false
    
    //MARK:VIEWDIDLOAD METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDField = UITextField()
        userIDField.delegate = self
        userIDField.text = nil
        passtextField = UITextField()
        passtextField.delegate = self
        passtextField.text = nil
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    //MARK:VIEWWILLAPPEAR METHOD
    
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
               // self.setupView()
                //self.loginTapped()
            }
        }
        manager?.startListening()}
    
    //MARK:GOBACK METHOD
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:SETUP METHOD
    
    func setupView()
    {
        if  !isUpdateBank{
            self.tabBarController?.tabBar.isHidden = true
            self.view.backgroundColor = UIColor.white
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "logo-transprent")
            self.view.addSubview(logoImageView)
            logoImageView.snp.makeConstraints { (make) in
                //  make.top.equalTo(40)
                make.width.equalTo(590 * 0.5)//490
                make.height.equalTo(680 * 0.5)//580
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view).offset(-20)
            }
            
            let titleLabel = UILabel()
            titleLabel.text = "L O G   I N   W I T H\nY O U R   B A N K\nC R E D E N T I A L S"
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 3
            titleLabel.font = UIFont(name:K_FONT_COLOR_Alethia, size: 24)
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
            
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.black
            button.setTitle("LOG IN", for: .normal)
            self.view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.height.equalTo(64)
                make.left.equalTo(0)
                make.right.equalTo(0)
            }
            
            button.addTarget(self, action: #selector(self.loginTapped), for: .touchUpInside)
            
            
            
            let bankImageView = UIImageView()
            // print(self.bank!["name"] as! String)
            //print(self.bank!["favicon"] as! String)
            
            if let  imageLogo = self.bank!["favicon"] as? String{
                if imageLogo != nil
                {
                    // replaced = (imageLogo as String).replacingOccurrences(of:"FAVICON", with: "LOGO")
                    bankImageView.kf.setImage(with: URL(string:imageLogo))
                }
            }
            
            
            bankImageView.clipsToBounds = true
            
            self.view.addSubview(bankImageView)
            bankImageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(titleLabel.snp.bottom).offset(75)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            
            let bankLabel = UILabel()
            bankLabel.textColor = UIColor.black
            self.view.addSubview(bankLabel)
            bankLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(bankImageView.snp.bottom).offset(10)
                //make.left.equalTo(bankImageView.snp.right).offset(10)
                //make.right.equalTo(-20)
                //make.centerY.equalTo(bankImageView)
            }
            //bankLabel.font = UIFont.boldSystemFont(ofSize: 18)
            bankLabel.font = UIFont(name:K_Font_Color_Bold,size:22)
            //bankLabel.text = "CITI BANK"
            bankLabel.text = bank?["name"] as? String
            
            
            
            let  attributedPlaceholder1 = NSAttributedString(string: "User ID", attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont(name: K_Font_Color, size: 18)])
            userIDField.attributedPlaceholder = attributedPlaceholder1
            //userIDField.placeholder = "UserLogin"
            
            userIDField.borderStyle = .none
            self.view.addSubview(userIDField)
            userIDField.snp.makeConstraints { (make) in
                make.left.equalTo(40)
                make.right.equalTo(-15)
                make.top.equalTo(bankLabel.snp.bottom).offset(50)
                make.height.equalTo(50)
            }
            userIDField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            userIDField.leftViewMode = .always
            
            
            
            
            let imageView = UIImageView()
            self.view.addSubview(imageView)
            imageView.image =  UIImage(named:"ic_user_login")
            imageView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(userIDField)
            }
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.black
            self.view.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(userIDField.snp.bottom)
                make.height.equalTo(1)
            }
            
            
            passtextField.borderStyle = .none
            passtextField.isSecureTextEntry = true
            let attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont(name: K_Font_Color ,size: 18)])
            passtextField.attributedPlaceholder = attributedPlaceholder
            // passtextField.placeholder = "Password"
            self.view.addSubview(passtextField)
            passtextField.snp.makeConstraints { (make) in
                make.left.equalTo(40)
                make.right.equalTo(-15)
                make.top.equalTo(userIDField.snp.bottom).offset(50)
                make.height.equalTo(50)
            }
            passtextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            passtextField.leftViewMode = .always
            
            
            let imageView1 = UIImageView()
            self.view.addSubview(imageView1)
            imageView1.image =  UIImage(named:"ic_password_login")
            imageView1.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(passtextField)
            }
            
            
            let lineView2 = UIView()
            lineView2.backgroundColor = UIColor.black
            self.view.addSubview(lineView2)
            lineView2.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(passtextField.snp.bottom)
                make.height.equalTo(1)
            }
            
            let infoLabel = UILabel()
            infoLabel.text = "This information is secured with\n bank-level encryption."
            infoLabel.textAlignment = .center
            infoLabel.numberOfLines = 3
            //infoLabel.font = UIFont.boldSystemFont(ofSize: 15)
            infoLabel.font = UIFont(name:K_Font_Color_Bold,size:15)
            self.view.addSubview(infoLabel)
            infoLabel.snp.makeConstraints { (make) in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.top.equalTo(button.snp.top).offset(-80)
            }
        }
        else{
            self.tabBarController?.tabBar.isHidden = true
            self.view.backgroundColor = UIColor.white
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "logo-transprent")
            self.view.addSubview(logoImageView)
            logoImageView.snp.makeConstraints { (make) in
                //  make.top.equalTo(40)
                make.width.equalTo(590 * 0.5)//490
                make.height.equalTo(680 * 0.5)//580
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view).offset(-20)
            }
            
            let titleLabel = UILabel()
            titleLabel.text = "L O G   I N   W I T H\nY O U R   B A N K\nC R E D E N T I A L S"
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 3
            titleLabel.font = UIFont(name:K_FONT_COLOR_Alethia, size: 24)
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
            
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.black
            button.setTitle("LOG IN", for: .normal)
            self.view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.height.equalTo(64)
                make.left.equalTo(0)
                make.right.equalTo(0)
            }
            
            button.addTarget(self, action: #selector(self.loginTapped), for: .touchUpInside)
            
            
            
            let bankImageView = UIImageView()
            // print(self.bank!["name"] as! String)
            //print(self.bank!["favicon"] as! String)
            
            /* if let  imageLogo = self.bank!["favicon"] as? String{
             if imageLogo != nil
             {
             // replaced = (imageLogo as String).replacingOccurrences(of:"FAVICON", with: "LOGO")
             bankImageView.kf.setImage(with: URL(string:imageLogo))
             }
             }
             */
            if K_INNERUSER_DATA.Banklogo.characters.count > 0{
                bankImageView.kf.setImage(with: URL(string:K_INNERUSER_DATA.Banklogo))
            }
            
            
            bankImageView.clipsToBounds = true
            
            self.view.addSubview(bankImageView)
            bankImageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(titleLabel.snp.bottom).offset(75)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            
            let bankLabel = UILabel()
            bankLabel.textColor = UIColor.black
            self.view.addSubview(bankLabel)
            bankLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(bankImageView.snp.bottom).offset(10)
                //make.left.equalTo(bankImageView.snp.right).offset(10)
                //make.right.equalTo(-20)
                //make.centerY.equalTo(bankImageView)
            }
            //bankLabel.font = UIFont.boldSystemFont(ofSize: 18)
            bankLabel.font = UIFont(name:K_Font_Color_Bold,size:22)
            //bankLabel.text = "CITI BANK"
            // bankLabel.text = bank?["name"] as? String
            
            bankLabel.text =  K_INNERUSER_DATA.BankName
            
            let  attributedPlaceholder1 = NSAttributedString(string: "User ID", attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont(name: K_Font_Color, size: 18)])
            userIDField.attributedPlaceholder = attributedPlaceholder1
            //userIDField.placeholder = "UserLogin"
            
            userIDField.borderStyle = .none
            self.view.addSubview(userIDField)
            userIDField.snp.makeConstraints { (make) in
                make.left.equalTo(40)
                make.right.equalTo(-15)
                make.top.equalTo(bankLabel.snp.bottom).offset(50)
                make.height.equalTo(50)
            }
            userIDField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            userIDField.leftViewMode = .always
            
            
            
            
            let imageView = UIImageView()
            self.view.addSubview(imageView)
            imageView.image =  UIImage(named:"ic_user_login")
            imageView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(userIDField)
            }
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.black
            self.view.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(userIDField.snp.bottom)
                make.height.equalTo(1)
            }
            
            
            passtextField.borderStyle = .none
            passtextField.isSecureTextEntry = true
            let attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont(name: K_Font_Color ,size: 18)])
            passtextField.attributedPlaceholder = attributedPlaceholder
            // passtextField.placeholder = "Password"
            self.view.addSubview(passtextField)
            passtextField.snp.makeConstraints { (make) in
                make.left.equalTo(40)
                make.right.equalTo(-15)
                make.top.equalTo(userIDField.snp.bottom).offset(50)
                make.height.equalTo(50)
            }
            passtextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            passtextField.leftViewMode = .always
            
            
            let imageView1 = UIImageView()
            self.view.addSubview(imageView1)
            imageView1.image =  UIImage(named:"ic_password_login")
            imageView1.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalTo(passtextField)
            }
            
            
            let lineView2 = UIView()
            lineView2.backgroundColor = UIColor.black
            self.view.addSubview(lineView2)
            lineView2.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(passtextField.snp.bottom)
                make.height.equalTo(1)
            }
            
            let infoLabel = UILabel()
            infoLabel.text = "This information is secured with\n bank-level encryption."
            infoLabel.textAlignment = .center
            infoLabel.numberOfLines = 3
            //infoLabel.font = UIFont.boldSystemFont(ofSize: 15)
            infoLabel.font = UIFont(name:K_Font_Color_Bold,size:15)
            self.view.addSubview(infoLabel)
            infoLabel.snp.makeConstraints { (make) in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.top.equalTo(button.snp.top).offset(-80)
            }
        }
    
    }
    
    //MARK:LOGINTAPPED METHOD
    
    func loginTapped()//comment credential
    {
        
        
        if apiHitProcessToUpdate
        {
           updateApiHitWithCorrectCredentials()
            return
        }
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            userIDField.resignFirstResponder()
            passtextField.resignFirstResponder()
            print("user textfield is \(userIDField.text) and passtextfiled is \(passtextField.text)")
            if  let userId = userIDField.text
            {
                userIDField.text =  userId.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            if  let passtext = passtextField.text
            {
                passtextField.text =  passtext.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            if (userIDField.text?.characters.count == 0)
            {
                self.view.makeToast("Please enter User ID")
                return;
            }
            
            if (passtextField.text?.characters.count == 0) {
                self.view.makeToast("Please enter Password")
                return;
            }
           SVProgressHUD.show()
           self.view.isUserInteractionEnabled = false
           // print(UserDefaults.standard.string(forKey:"user_id")!)
            
            print(self.bank!["name"] as! String)
           
            provider_ID = self.bank!["id"] as! Int
            print("provide id is \(provider_ID) that")
             K_USER_DATA.bankUpdate = "no"
           // DataManager.sharedManager.bankLogin(params: ["user_id":UserDefaults.standard.string(forKey:"user_id")!, "username": userIDField.text!,"password":passtextField.text! ,"provider_id":provider_ID]) { (response) in
            let singelton = SharedManager.sharedInstance
           
            DataManager.sharedManager.bankLogin(params: ["user_id": singelton.loginId, "username": userIDField.text!,"password":passtextField.text! ,"provider_id":provider_ID]) { (response) in
                self.view.isUserInteractionEnabled = true
                if let dataDic = response as? [[String:Any]]
                {
                    
                    
                    self.arrData = dataDic
                    if self.arrData.count == 0
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Taste", message:"Bank added successfully", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.moveToNextController()
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return}
                    else
                    {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Taste", message:"Network Error", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                else if let dataResponse = response as? String
                {
                    
                    let str = K_USER_DATA.loginTry
                    
                    
                    if str == "yes"
                    {
                        SVProgressHUD.dismiss()
                        K_USER_DATA.loginTry = "no"
                        
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
                            let alert = UIAlertController(title: "Taste", message:"Try again", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return

                            
                        }

                    }
                        
                    else
                    {
                        let strString = dataResponse
                        print("string in banklogin when bank added \(strString)")
                        
                        if strString.contains("listing")
                        {
                            self.bankAdded = true
                            
                        }
                        
                        
                        print("response is \(dataResponse)")
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Taste", message:dataResponse, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            if self.bankAdded
                            {
                                self.moveToNextController()
                                
                            }
                            else
                            {
                                self.apiHitProcessToUpdate = false
                                print("api value \(  self.apiHitProcessToUpdate)")
                                NSLog("OK Pressed")
                                
                            }
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                    
                else if let dataDic = response as? [String:Any]
                {
                    let provideAcc = dataDic["providerAccount"] as? [String:Any]
                    if ((provideAcc) != nil)
                        
                    {
                        if let provideAccID = provideAcc?["provider_account_id"] as? IntegerLiteralType
                        {
                            print("proviuder account is \(provideAccID)")
                            self.providerAccountID = "\(provideAccID)"
                            // self.providerAccountID = provideAccID
                        }
                        
                    }
                    
                    if let loginform = provideAcc?["login_form"] as? [String:Any]
                    {
                        let mfaTimeout = loginform["mfaTimeout"] as! Int
                        K_BANKCREDENTIAL_DATA.mfaTimeout = String(mfaTimeout)
                        let formType = loginform["formType"] as! String
                        K_BANKCREDENTIAL_DATA.formType = formType
                        print("mfa time out is \( K_BANKCREDENTIAL_DATA.mfaTimeout) and form type is \( K_BANKCREDENTIAL_DATA.formType)")
                        
                        
                        if let dietArr = loginform["row"] as? [[String:Any]]
                        {
                            SVProgressHUD.dismiss()
                            self.arrData = dietArr
                            self.moveToQuestionController()
                            //                            print("array count in case of question accout is \( self.arrData.count)")
                            //
                            //                            let alert = UIAlertController(title: "Taste", message:"Additional information is needed in order to add the bank successfully", preferredStyle: UIAlertControllerStyle.alert)
                            //                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            //                                UIAlertAction in
                            //                                self.moveToQuestionController()
                            //                                NSLog("OK Pressed")
                            //                            }
                            //                            alert.addAction(okAction)
                            //                            self.present(alert, animated: true, completion: nil)
                            //                            return
                        }
                        
                        
                    }
                }
                
                DispatchQueue.main.async
                    {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        
                }}
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isLogin")
            defaults.synchronize()
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
    //MARK:MOVETONEXTCONTROLLER
    
    func moveToNextController()
    {
        let vc = ProfileBeingCreatedViewController()
        let singelton = SharedManager.sharedInstance
        singelton.refeshRecommendation = "yes"
        self.present(vc, animated: true, completion: nil)
        
//        if self.isUpdateBank{
//            let tabController = UITabBarController()
//            //            let vc = ExploreRecommendationController()
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "ExploreTabViewController")
//            let navVC = UINavigationController(rootViewController: vc)
//            navVC.isNavigationBarHidden = true
//            let vc2 = ProfileViewController()
//            let navVC2 = UINavigationController(rootViewController: vc2)
//            navVC2.isNavigationBarHidden = true
//            // vc2.cuisines = self.cuisines
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
//            tabController.selectedIndex = 1
//            // tabController.tabBar.items![0].isEnabled = false
//            
//            self.present(tabController, animated: true, completion: nil)
//        }
//        else{
//            let vc = ProfileBeingCreatedViewController()
//            let singelton = SharedManager.sharedInstance
//            singelton.refeshRecommendation = "yes"
//            self.present(vc, animated: true, completion: nil)
//
//        }
        
    }
    
    
    //MARK:UPDATE API HIT
    func updateApiHitWithCorrectCredentials()
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            userIDField.resignFirstResponder()
            passtextField.resignFirstResponder()
            print("user textfield is \(userIDField.text) and passtextfiled is \(passtextField.text)")
            if  let userId = userIDField.text
            {
                userIDField.text =  userId.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            if  let passtext = passtextField.text
            {
                passtextField.text =  passtext.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            if (userIDField.text?.characters.count == 0)
            {
                self.view.makeToast("Please enter User ID")
                return;
            }
            
            if (passtextField.text?.characters.count == 0) {
                self.view.makeToast("Please enter Password")
                return;
            }
           SVProgressHUD.show()
           self.view.isUserInteractionEnabled = false
           // print(UserDefaults.standard.string(forKey:"user_id")!)
            
//            print(self.bank!["name"] as! String)
//            let provider_ID : Int
//            provider_ID = self.bank!["id"] as! Int
//            print("provide id is \(provider_ID) that")
            
            var provider_ID:Int = 0
            var provider_AccountID:Int = 0
            
            if let providerId = self.bank?["provider_id"] as? Int{
                provider_ID = providerId
            }
            
            if let providerAccountId = self.bank?["provider_account_id"] as? Int{
                provider_AccountID =  providerAccountId
            }
            
           K_USER_DATA.bankUpdate = "yes"
            let serverUIrl = K_BANK_URL
            
           // let parameter = ["provider_account_id":K_USER_DATA.provideAccountID,"provider_id": provider_ID,"username": userIDField.text!,"password":passtextField.text!,"user_id":UserDefaults.standard.string(forKey:"user_id")!] as [String : Any]
            let singelton = SharedManager.sharedInstance
            
             //let parameter = ["provider_account_id":K_USER_DATA.provideAccountID,"provider_id": provider_ID,"username": userIDField.text!,"password":passtextField.text!,"user_id":singelton.loginId] as [String : Any]
            let parameter = ["provider_account_id":provider_AccountID,"provider_id": provider_ID,"username": userIDField.text!,"password":passtextField.text!,"user_id":singelton.loginId] as [String : Any]
            print("paramter is \(parameter)")
          //  print("paramter is \(parameter)")
            Alamofire.request(serverUIrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                switch(response.result)
                {
                case.success(_):
                    if let  JSON = response.result.value
                    {
                        print(JSON)
                         self.view.isUserInteractionEnabled = true
                        let responseData = JSON as! NSDictionary
                        
                        if responseData.object(forKey: "status") as! String == "success"
                        {
                            
                             if let result = responseData["data"] as? [String:Any]
                             {
                                let provideAcc = result["providerAccount"] as? [String:Any]
                                if ((provideAcc) != nil)
                                    
                                {
                                    if let provideAccID = provideAcc?["provider_account_id"] as? IntegerLiteralType
                                    {
                                        print("proviuder account is \(provideAccID)")
                                        self.providerAccountID = "\(provideAccID)"
                                        // self.providerAccountID = provideAccID
                                    }
                                    
                                }
                                
                                if let loginform = provideAcc?["login_form"] as? [String:Any]
                                {
                                    let mfaTimeout = loginform["mfaTimeout"] as! Int
                                    K_BANKCREDENTIAL_DATA.mfaTimeout = String(mfaTimeout)
                                    let formType = loginform["formType"] as! String
                                    K_BANKCREDENTIAL_DATA.formType = formType
                                    print("mfa time out is \( K_BANKCREDENTIAL_DATA.mfaTimeout) and form type is \( K_BANKCREDENTIAL_DATA.formType)")
                                    
                                    0
                                    if let dietArr = loginform["row"] as? [[String:Any]]
                                    {
                                        SVProgressHUD.dismiss()
                                        self.arrData = dietArr
                                        self.moveToQuestionController()
                                       // print("array count in case of question accout is \( self.arrData.count)")
                                        
//                                        let alert = UIAlertController(title: "Taste", message:"Additional information is needed in order to update the bank successfully", preferredStyle: UIAlertControllerStyle.alert)
//                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                                            UIAlertAction in
//                                            self.moveToQuestionController()
//                                            NSLog("OK Pressed")
//                                        }
//                                        alert.addAction(okAction)
//                                        self.present(alert, animated: true, completion: nil)
//                                        return
                                    }
                                    }
                            }
            		                
                            else
                            
                             {
                                if let result = responseData["data"] as? [[String:Any]]
                                
                                {
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        self.moveToNextController()
                                        NSLog("OK Pressed")
                                    }
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    return
                                    
                                }
                                
                                
                            }
                            
                        }
                            
                        else
                        {
                           SVProgressHUD.dismiss()
                             self.view.isUserInteractionEnabled = true
                            let alert = UIAlertController(title: "My Title", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                    }
                        
                    else
                    {
                         SVProgressHUD.dismiss()
                         self.view.isUserInteractionEnabled = true
                        print(response)
                    }
                    break
                case.failure(_):
                    SVProgressHUD.dismiss()
                     self.view.isUserInteractionEnabled = true
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
                    print(response.result.error)
                    break
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
    
    
    
    
    func moveToQuestionController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"QuestionViewController") as! QuestionViewController
        vc.question = self.arrData
        vc.ProviderAccID = self.providerAccountID
        vc.isUpdate =  self.isUpdateBank
       // print(self.isUpdateBank)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: TEXTFILED DELEGATE METHOD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField!)
    {
        if userIDField.isFirstResponder == true {
            userIDField.placeholder = nil
        }
        else
        {
            userIDField.placeholder = "User ID"
        }
        if passtextField.isFirstResponder == true {
            passtextField.placeholder = nil
        }
        else
        {
            passtextField.placeholder = "Password"
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
    }
    
}
