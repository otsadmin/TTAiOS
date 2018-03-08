//
//  BankAccountViewController.swift
//  TasteApp
//
//  Created by Lalit Mohan on 3/9/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class BankAccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK: VARIABLE DECLARATION
    // added by ranjit
    let titleRecommendation = UILabel()
    let btnaddAccount = UIButton(type: .custom)
    
    var paramDict = [String : Any]()
    var notify_user_id = ""
    var recieveUserId = ""
    
    var bankList = [[String:Any]]()
    var userData = [[String:Any]]()
    var name : String = ""
    let texts = ["AMERICAN EXPRESS", "AMERICA", "BANK OF AMERICA", "CAPITAL ONE" ,"CHASE BANK" , "CITI BANK" ,"CITIZENS BANK"]
    var tableView:UITableView!
    var removeAccount = false
    var NotificationObj : String = ""
    var NotificationID : String = ""
 //MARK: VIEWLIFE CYCLE METHOD

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView?.isHidden = false
       titleRecommendation.isHidden = true
       setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
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
        //let singelton = SharedManager.sharedInstance
        //singelton.loginId = K_CURRENT_USER.login_Id
        let parameters = ["user_id":self.recieveUserId] as [String : Any]
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

    //MARK: GO TO BACK CONTROLLER
    
    func goBack()
    {
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

    }
    //MARK: ADD ACCOUNT METHOD
    
    
    func addAccount()
    {
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//        
//        for aViewController in viewControllers {
//            if(aViewController is ProfileViewController)
//            {
//                self.navigationController!.popToViewController(aViewController, animated: false);
//            }
//        }
//        
        if Reachability.isConnectedToNetwork() == true
        {
            let vc = BanksListViewController()
            vc.screenName = "bankaccount"
            self.navigationController?.pushViewController(vc, animated: false)

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
    
    //MARK: SETUPVIEW METHOD
    
    func setUpView()
    {
        self.view.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 22)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.right.equalTo(0)
            make.top.equalTo(40)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        let titleSubLabel =  UILabel()
        titleSubLabel.text = "Bank Accounts"
        titleSubLabel.textAlignment = .center
        titleSubLabel.numberOfLines = 2
        titleSubLabel.font = UIFont(name: K_Font_Color_Light, size: 23)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleSubLabel)
        titleSubLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
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
     /*   let personalLabel =  UILabel()
        personalLabel.text = "Personal"
        personalLabel.textAlignment = .center
        personalLabel.numberOfLines = 2
        personalLabel.font = UIFont(name: K_Font_Color, size: 22)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(personalLabel)
        personalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(20)
        }
        */
        
        self.titleRecommendation.isHidden = true
        self.titleRecommendation.text = "We do not have the bank accounts for you. Please try adding more bank accounts in settings section."
        self.titleRecommendation.textAlignment = .center
        self.titleRecommendation.numberOfLines = 4
        self.titleRecommendation.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(self.titleRecommendation)
        self.titleRecommendation.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            // make.top.equalTo(topRecommendationLabel.snp.bottom).offset(140)
            make.bottom.equalTo(self.view.snp.bottom).offset(-250)
            //                make.centerX.equalTo(self.view)
            //                make.centerY.equalTo(self.view)
        }
        
        btnaddAccount.backgroundColor = UIColor.black
        btnaddAccount.addTarget(self, action: #selector(self.addAccount), for: .touchUpInside)
        btnaddAccount.setTitle("ADD ACCOUNT", for: .normal)
        btnaddAccount.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(btnaddAccount)
        btnaddAccount.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-150)
            make.height.equalTo(50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
     /*   let businessLabel =  UILabel()
        businessLabel.text = "Business"
        businessLabel.textAlignment = .center
        businessLabel.numberOfLines = 2
        businessLabel.font = UIFont(name:  K_Font_Color, size: 22)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(businessLabel)
        businessLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.bottom.equalTo(btnaddAccount.snp.top).offset(-20)
        }
        */
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.gray
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(btnaddAccount.snp.top).offset(-20)
            make.top.equalTo(titleSubLabel.snp.bottom).offset(10)
        }
        
       // self.tableView.sectionHeaderHeight = 70
        tableView.tableFooterView = UIView()
        
        
        
        //Border Color of TableView
        
      /*  tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2.0
        
        
        //Corner Radius
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        */
       // delayWithSeconds(1.0)
       // {
         //}
        
        self.getBankList()
        
       }
    
  func getBankList() -> Void {
   
    if Reachability.isConnectedToNetwork() == true
    {
        SVProgressHUD.show()
        
        // let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!]
        let singelton = SharedManager.sharedInstance
        
        let parameters = ["user_id":singelton.loginId]
        print(parameters)
        DataManager.sharedManager.bankList(params: parameters) { (response) in
            
            if let dataDic = response as? [[String:Any]]
            {
                self.bankList = dataDic
                print(dataDic)
                if self.bankList.count > 0
                {
                    self.tableView.isHidden = false
                    self.view.isUserInteractionEnabled = true
                    self.titleRecommendation.isHidden = true
                    self.NotificationID = ""
                    self.tableView.reloadData()
                }
                else
                {
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    self.titleRecommendation.isHidden = false
                    self.tableView.isHidden = true
                    //                        let alert = UIAlertController(title: "Taste", message:"Data Not Found",preferredStyle: UIAlertControllerStyle.alert)
                    //                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    //                            UIAlertAction in
                    //                            NSLog("OK Pressed")
                    //                        }
                    //                        alert.addAction(okAction)
                    //                        self.present(alert, animated: true, completion: nil)
                    //                        return
                }
            }
            else{
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                self.titleRecommendation.isHidden = false
                self.tableView.isHidden = true
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
                
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                
            }
        }
     }
    else
    {   self.view.isUserInteractionEnabled = true
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
    
   // MARK: TABLEVIEW DELEGATE METHOD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.bankList.count)
        return self.bankList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            //            make.left.equalTo(20)
            //            make.right.equalTo(-20)
            //            make.centerY.equalTo(cell.contentView)
            
            make.top.equalTo(25)
            make.left.equalTo(20)
            make.width.equalTo(220)
            make.height.equalTo(15)

        }
        
      //  textLabel.font = UIFont(name:  K_Font_Color, size: 14)
//        if let accpountprovider = self.bankList[indexPath.row]["provider_account_id"] as? Int
//        {
//            let accountNo = String(accpountprovider)
//             if accountNo.characters.count >= 4
//             {
//                let maskNo = String(accountNo.characters.suffix(4))
//                let accountText = "(xxxx" + maskNo + ")"
//                let nameText =  (self.bankList[indexPath.row]["name"] as! String?)!
//                textLabel.text = nameText + " " + accountText
//
//            }
//            else{
//                 textLabel.text = self.bankList[indexPath.row]["name"] as! String
//            }
//        }
//        else{
//            textLabel.text = self.bankList[indexPath.row]["name"] as! String
//        }
      
        if let nameText =  self.bankList[indexPath.row]["name"] as? String
         {
           name = nameText
         }
       
        if let account =  self.bankList[indexPath.row]["account"] as? Array<Dictionary<String,Any>>
        {
            if let isIndexValid = account.indices.contains(0) as? Bool
            {
                if isIndexValid == true
                {
                    if let accountName = account[0]["account_number"] as? String
                    {
                      textLabel.text = name + " " + accountName
                    }
                    else{
                        textLabel.text = name
                    }
                }
                else{
                    textLabel.text = name
                }
               
                
            }
            else{
                textLabel.text = name
            }
        }
        else{
            textLabel.text = name
        }
        
        let checkImage = UIImage(named: "account_delete")
        let checkmark = UIImageView(image: checkImage)
        checkmark.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cell.accessoryView = checkmark
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        checkmark.isUserInteractionEnabled = true
        checkmark.addGestureRecognizer(tapGestureRecognizer)
 
        textLabel.font = UIFont(name:  K_Font_Color, size: 14)
        
        let refreshButton = UIButton(type: .custom)
        cell.contentView.addSubview(refreshButton)
        refreshButton.addTarget(self, action: #selector(self.jumpToBankLogin), for: .touchUpInside)
        refreshButton.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(245)
            make.width.equalTo(30)
            make.height.equalTo(30)
            // make.centerY.equalTo(titleLabel.snp.centerY)
        }
        refreshButton.setImage(UIImage(named:"BankRefreshLogo"), for: .normal)
        refreshButton.isHidden = true
        refreshButton.tag = indexPath.row
        if let isUpdateBank = self.bankList[indexPath.row]["is_update"] as? String{
            
            if isUpdateBank == "no"{
                refreshButton.isHidden = true
            }
            else{
                //                if let providerId = self.bankList[indexPath.row]["provider_id"] as? Int{
                ////                    if K_INNERUSER_DATA.Provider_ID == providerId{
                //                        textLabel.textColor = UIColor.red
                //                        refreshButton.isHidden = false
                //                    }
                //                }
                textLabel.textColor = UIColor.red
                refreshButton.isHidden = false
                
            }
        }
        

        
        
//        let line = UIView()
//        cell.contentView.addSubview(line)
//        line.backgroundColor = UIColor.black
//        line.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.bottom.equalTo(0)
//            make.height.equalTo(1)
//            make.right.equalTo(0)
//        }
        
//        let checkImage = UIImage(named: "account_delete")
//        let checkmark = UIImageView(image: checkImage)
//        checkmark.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        cell.accessoryView = checkmark
        return cell
    }
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let buttonPosition = tappedImage.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
         let cell = self.tableView.cellForRow(at: indexPath!) as UITableViewCell!

        let refreshAlert = UIAlertController(title: "Taste", message: "Are you sure you want to delete Account.", preferredStyle: UIAlertControllerStyle.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in

            print("Handle Ok logic here")
            self.deleteAccount(indexPath: (indexPath?.row)!)

        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in

            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        // Your action
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Bank Name"
//    }
    
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect.zero)
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 150, height: 40))
        label.text = "BANK NAME"
        label.textColor = UIColor.black
        
        var btnUnlink = UIButton(type: .custom)
        btnUnlink = UIButton(frame: CGRect(x: 160, y: 20, width: 150, height: 40))
        btnUnlink.backgroundColor = UIColor.black
       // btnUnlink.addTarget(self, action: #selector(self.unLinkAccount), for: .touchUpInside)
        btnUnlink.setTitle("UNLINK", for: .normal)
        btnUnlink.setTitleColor(UIColor.white, for: .normal)
        
//        var lineView = UIView()
//        lineView.backgroundColor = UIColor.black
//        lineView = UIView(frame: CGRect(x: 10, y: 30, width: 150, height: 1))
//        
//        view.addSubview(lineView)
        
        view.addSubview(btnUnlink)
        
        view.addSubview(label)
        
        return view
 
    }
    */
    
    
    func numberOfSectionsInTableView(_tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        
//         let cell = self.tableView.cellForRow(at: indexPath) as UITableViewCell!
//        
//        let refreshAlert = UIAlertController(title: "Taste", message: "Are you sure you want to delete Account.", preferredStyle: UIAlertControllerStyle.alert)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//            
//            print("Handle Ok logic here")
//            self.deleteAccount(indexPath: indexPath.row)
//            
//        }))
//        
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//            
//            print("Handle Cancel Logic here")
//        }))
//        
//        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func deleteAccount( indexPath: Int)
    {
        if Reachability.isConnectedToNetwork() == true
        {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let providerBank_ID = self.bankList[indexPath]["_id"] as! String?
        let Provider_Account = self.bankList[indexPath]["provider_account_id"] as! Int?
        let proViderID : String = (Provider_Account?.description)!
        print("provider id is \(proViderID) that")
        
        //let parameter = ["bank_id":providerBank_ID!,"provider_account_id": proViderID,"user_id":UserDefaults.standard.string(forKey:"user_id")!]
        let singelton = SharedManager.sharedInstance
        
        let parameter = ["bank_id":providerBank_ID!,"provider_account_id": proViderID,"user_id":singelton.loginId]
        
        Alamofire.request(K_BANK_DELETE_URL, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result)
            {
            case.success(_):
                if let  JSON = response.result.value
                {
                    print(JSON)
                    print(parameter)
                    
                    let responseData = JSON as! NSDictionary
                    
                    if responseData.object(forKey: "status") as! String == "success"
                    {
                        SVProgressHUD.dismiss()
                        
                        
                        self.view.isUserInteractionEnabled = true
                        let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            DispatchQueue.main.async{
                                self.bankList.remove(at: indexPath)
                                if self.bankList.count > 0
                                {
                                    self.tableView.isHidden = false
                                    self.view.isUserInteractionEnabled = true
                                    self.titleRecommendation.isHidden = true
                                    self.tableView.reloadData()
                                }
                                else
                                {
                                    
                                    SVProgressHUD.dismiss()
                                    self.view.isUserInteractionEnabled = true
                                    self.titleRecommendation.isHidden = false
                                    self.tableView.isHidden = true
                                
                                }
                               // self.loginApiHitToCheckBankCount()
                               // self.getBankList()
                            }
                            
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        SVProgressHUD.dismiss()
                         self.view.isUserInteractionEnabled = true
                        let alert = UIAlertController(title: "Taste", message:responseData.object(forKey: "message") as! String? , preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    DispatchQueue.main.async{
                         self.view.isUserInteractionEnabled = true
                        self.tableView.reloadData()
                    }
                    
                    
                }
                else
                {
                    SVProgressHUD.dismiss()
                     self.view.isUserInteractionEnabled = true
                    print("error we facing is \(response)that")
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
    
    
    
    
    
    
    
    
    func loginApiHitToCheckBankCount()
    {
        
        var params = ["is_linkedin_user":"true",
                      "linkedin_key":K_CURRENT_USER.user_id,
                      "firstname": K_CURRENT_USER.name,
                      "lastname":K_CURRENT_USER.lname,
                      "email":K_CURRENT_USER.email,
                      "profile_type" :"public",
                      "has_device_key" : "false"]
        
        
        DataManager.sharedManager.login(params: params , completion: { (response) in
            
            
            if let dataDic = response as? [[String:Any]]
            {
                
                self.userData  = dataDic
            }
            self.loadLoginData()
            
        })
        
        
    }
    
    func loadLoginData()
    {
       /* let loginId = self.userData[0]["_id"] as? String
        print("login id isssss \(loginId!)")
        let bankCount = self.userData[0]["total_bank"] as! Int
        print("bank count issss \(bankCount) that")
        let defaults = UserDefaults.standard
        defaults.set(loginId!, forKey: "user_id")
        defaults.set(bankCount, forKey: "bankcount")
        defaults.synchronize()
        
        */
        if  let loginId = self.userData[0]["_id"] as? String{
             print(loginId)
        }
       
        
        if let bankCount = self.userData[0]["total_bank"] as? Int{
             print(bankCount)
        }
    }
    
    func jumpToBankLogin(sender:UIButton)
    {
        let index = sender.tag
        
        
        if let bankName = self.bankList[index]["name"] as? String{
            K_INNERUSER_DATA.BankName =  bankName
        }
        else{
            K_INNERUSER_DATA.BankName = ""
        }
        if let bankLogo = self.bankList[index]["bank_logo"] as? String{
            K_INNERUSER_DATA.Banklogo =  bankLogo
        }
        else{
            K_INNERUSER_DATA.Banklogo = ""
        }
        
        
        let vc = BankLoginViewController()
        vc.bank = self.bankList[index]
        vc.isUpdateBank = true
        vc.apiHitProcessToUpdate = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
//    {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: K_Font_Color_Bold, size: 14)
//        header.textLabel?.textColor = UIColor.black
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        super.viewWillDisappear(animated)
    }

}
