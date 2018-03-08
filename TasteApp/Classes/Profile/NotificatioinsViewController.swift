//
//  NotificatioinsViewController.swift
//  TasteApp
//
//  Created by Shubhank on 22/02/17.
//  Copyright Â© 2017 Ots. All rights reserved.
//

import UIKit
import SVProgressHUD


class NotificatioinsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var tableView:UITableView!
    var RecvarrPageNotification = [[String:Any]]()
    var RecvarrNotification =  [[String:Any]]()
    var notificationId: String = ""
    var user_Id: String = ""
    var stranger_Id: String = ""
    let titleLabel = UILabel()
    var statusRead: String = ""
    var pageNo = 1
    var  isloading  = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("Data is",self.RecvarrNotification)
        
        self.setupView()
    }
    
    
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        
        self.view.backgroundColor = UIColor.white
        
        
        let titleLabel = UILabel()
        titleLabel.text = "NOTIFICATIONS"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia , size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(38)
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
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            //make.bottom.equalTo(0)
            // make.bottom.equalTo(self.view.snp.bottom).offset(-38)
            make.bottom.equalTo(self.view.snp.bottom).offset(-45)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            
        }
        tableView.tableFooterView = UIView()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        // self.setupView()
        super.viewWillAppear(animated)
        self.loadTableViewData()
        
        
    }
    func loadTableViewData() {
        if Reachability.isConnectedToNetwork() == true
        {
            
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false //code added
            //let parameters = ["user_id":UserDefaults.standard.string(forKey: "user_id")!] as [String : Any]
            let singelton = SharedManager.sharedInstance
            //singelton.loginId = K_CURRENT_USER.login_Id
            let parameters = ["user_id":singelton.loginId, "page":self.pageNo] as [String : Any]
            
            print("Param Is",parameters)
            
            DataManager.sharedManager.getNotification(params: parameters) { (response) in
                
                self.view.isUserInteractionEnabled = true
                
                if let dataDic = response as? [[String:Any]]
                    
                {
                    self.RecvarrPageNotification = dataDic
                    
                    print("Respose is ",dataDic)
                    
                    if self.RecvarrPageNotification.count > 0
                    {
                        self.RecvarrNotification.append(contentsOf: self.RecvarrPageNotification)
                        self.isloading = false
                        self.tableView.reloadData()
                        //            self.collectionView.reloadData()
                    }
                        
                    else
                    {
                        SVProgressHUD.dismiss()
                        /*  let alert = UIAlertController(title: "Taste", message:"Data Not Found",preferredStyle: UIAlertControllerStyle.alert)
                         let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                         UIAlertAction in
                         
                         _ = self.navigationController?.popViewController(animated: true)
                         
                         NSLog("OK Pressed")
                         }
                         alert.addAction(okAction)
                         self.present(alert, animated: true, completion: nil)
                         return*/
                        // self.navigationController?.view.makeToast("You have no contacts that can be added in inner circle.", duration: 1.0, position: .center)
                        if self.RecvarrNotification.count > 0{
                            //self.isloading = false
                            // self.tableView.reloadData()
                        }
                        else{
                            self.showNotificationMessage()
                        }
                        
                    }
                    // print("notification array is (self.RecvarrNotification)")
                    // print("array data is (self.RecvarrNotification)")
                    
                }
                else{
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
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                    if self.RecvarrNotification.count > 0{
                        
                    }
                    else{
                        self.showNotificationMessage()
                    }
                    
                    
                }
                
                
            }
        }
        else{
            let alert = UIAlertController(title: "Taste", message:"No Internet Connectivity.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                // NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }

    func showNotificationMessage()  {
        self.view.isUserInteractionEnabled = true
        self.titleLabel.isHidden = false
        self.titleLabel.text = " There is no new notification."
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 2
        self.titleLabel.font = UIFont(name: K_FONT_COLOR_Alethia, size: 20)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
    }
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.RecvarrNotification.count
        // print("notification count is \(self.RecvarrNotification.count)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // self.RecvarrNotification.remove(at:indexPath.row)
            let id_Param = self.RecvarrNotification[indexPath.row]["_id"] as? String
            // print("IDD IS",id_Param!)
            self.Delte_Notification(id: id_Param!, index:indexPath.row,indexPath:indexPath)
            
            // print("Delete tapped")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
        /* if  let isReaded = self.RecvarrNotification[indexPath.row]["is_readed"] as? String{
         if isReaded == "READED"{
         cell.contentView.backgroundColor = UIColor.gray
         }
         else{
         cell.contentView.backgroundColor = UIColor.clear
         }
         }
         else{
         cell.contentView.backgroundColor = UIColor.clear
         }
         */
        //        if isReaded == "READED" {
        //            cell.contentView.backgroundColor = UIColor.clear
        //            let textLabel = UILabel()
        //            textLabel.textColor = UIColor.black
        //            cell.contentView.addSubview(textLabel)
        //            textLabel.snp.makeConstraints { (make) in
        //                make.left.equalTo(20)
        //                make.right.equalTo(-20)
        //                make.centerY.equalTo(cell.contentView)
        //            }
        //            textLabel.numberOfLines = 1
        //            textLabel.adjustsFontSizeToFitWidth = true
        //            textLabel.minimumScaleFactor = 0.2
        //            textLabel.font = UIFont(name:  K_Font_Color, size: 17)
        //            textLabel.text =  self.RecvarrNotification[indexPath.row]["text"] as? String
        //        }
        //        else{
        //            cell.contentView.backgroundColor = UIColor.lightGray
        //            let textLabel = UILabel()
        //            textLabel.textColor = UIColor.black
        //            cell.contentView.addSubview(textLabel)
        //            //  textLabel.backgroundColor = UIColor .gray
        //            textLabel.snp.makeConstraints { (make) in
        //                make.left.equalTo(20)
        //                make.right.equalTo(-20)
        //                make.centerY.equalTo(cell.contentView)
        //            }
        //            textLabel.numberOfLines = 1
        //            textLabel.adjustsFontSizeToFitWidth = true
        //            textLabel.minimumScaleFactor = 0.2
        //            textLabel.font = UIFont(name:  K_Font_Color, size: 17)
        //            textLabel.text =  self.RecvarrNotification[indexPath.row]["text"] as? String
        //
        //        }
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            //                        make.left.equalTo(20)
            //                        make.right.equalTo(-20)
            //                        make.centerY.equalTo(cell.contentView)
            make.left.equalTo(20)
            make.width.equalTo(260)
            make.height.equalTo(70)
        }
        // textLabel.numberOfLines = 2
        //                    textLabel.adjustsFontSizeToFitWidth = true
        //                    textLabel.minimumScaleFactor = 0.2
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.numberOfLines = 2
        //        textLabel.adjustsFontSizeToFitWidth = true
        //        textLabel.minimumScaleFactor = 0.2
        
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.black
        cell.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(282)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        dateLabel.numberOfLines = 1
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.2
        
        
        if  let isReaded = self.RecvarrNotification[indexPath.row]["is_readed"] as? String{
            if isReaded == "READED"{
                textLabel.font = UIFont(name:  K_Font_Color, size: 17)
                dateLabel.font = UIFont(name:  K_Font_Color, size: 17)
            }
            else{
                textLabel.font = UIFont(name:  K_Font_Color_Bold, size: 17)
                dateLabel.font = UIFont(name:  K_Font_Color_Bold, size: 17)
            }
        }
        else{
            textLabel.font = UIFont(name:  K_Font_Color_Bold, size: 17)
            dateLabel.font = UIFont(name:  K_Font_Color_Bold, size: 17)
        }
        
        textLabel.text =  self.RecvarrNotification[indexPath.row]["text"] as? String
        
        if  let dateText = self.RecvarrNotification[indexPath.row]["date"] as? String{
            dateLabel.text = dateText
        }
        else{
            dateLabel.text = ""
        }
        
        let line = UIView()
        cell.contentView.addSubview(line)
        line.backgroundColor = UIColor.black
        line.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
            make.right.equalTo(0)
        }
        
        /*   if let isInfoReaded = self.RecvarrNotification[indexPath.row]["is_readed"] as? String{
         
         if isInfoReaded .localizedCaseInsensitiveContains("NOT_READED"){
         
         }
         
         }
         */
        //        if isInfoReaded == false
        //        {
        //
        //            cell.backgroundColor = UIColor.darkGray
        //        }
        //        else
        //        {
        //
        //           cell.backgroundColor = UIColor.clear
        //
        //        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        print("Data notification ",self.RecvarrNotification)
        //        print("Type",self.RecvarrNotification[indexPath.row]["type"] as? String)
        //        print("Type",self.RecvarrNotification[indexPath.row]["fnd_obj"] as? String)
        //        print("Type",self.RecvarrNotification[indexPath.row]["user_obj"] as? String)
        //          print("Type",self.RecvarrNotification[indexPath.row]["_id"] as? String)
        //
        //
        //        let notification_type = self.RecvarrNotification[indexPath.row]["type"] as? String
        //
        //
        //        let frnd_id = self.RecvarrNotification[indexPath.row]["fnd_obj"] as? String
        //        let user_id = self.RecvarrNotification[indexPath.row]["user_obj"] as? String
        //        K_INNERUSER_DATA.FriendIdGlobal = frnd_id!
        //        K_INNERUSER_DATA.UserIdGlobal = user_id!
        //        K_INNERUSER_DATA.InviteStatus = notification_type!
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.show()
        if  let notification_type = self.RecvarrNotification[indexPath.row]["type"] as? String{
            K_INNERUSER_DATA.InviteStatus = notification_type
        }
        else{
            K_INNERUSER_DATA.InviteStatus = ""
        }
        
        
        if let frnd_id = self.RecvarrNotification[indexPath.row]["fnd_obj"] as? String{
            K_INNERUSER_DATA.FriendIdGlobal = frnd_id
        }
        else{
            K_INNERUSER_DATA.FriendIdGlobal = ""
        }
        if  let user_id = self.RecvarrNotification[indexPath.row]["user_obj"] as? String{
            K_INNERUSER_DATA.UserIdGlobal = user_id
        }
        else{
            K_INNERUSER_DATA.UserIdGlobal = ""
        }
        
        
        
        if let isInfoReaded = self.RecvarrNotification[indexPath.row]["is_readed"] as? String{
            self.statusRead = isInfoReaded
            self.statusRead = "READED"
        }
        
        if let id = self.RecvarrNotification[indexPath.row]["_id"] as? String
        {
            self.notificationId = id
            
        }
        if let userID = self.RecvarrNotification[indexPath.row]["user_obj"] as? String
        {
            self.user_Id = userID
            
        }
        if let strangerId = self.RecvarrNotification[indexPath.row]["action_user_id"] as? String
        {
            self.stranger_Id = strangerId
            
        }
        if self.RecvarrNotification[indexPath.row].index(forKey: "restaurentName") != nil {
            if let resto_name = self.RecvarrNotification[indexPath.row]["restaurentName"] as? String
            {
                K_INNERUSER_DATA.RestaurantName = resto_name
            }
        }
        else{
            K_INNERUSER_DATA.RestaurantName = ""
        }
        
        //        self.notificationStatusRequest(id: self.notificationId as NSString, status:  self.statusRead as NSString,userId: "")
        
        
        if  let notification_type = self.RecvarrNotification[indexPath.row]["factual_id"] as? String{
            K_INNERUSER_DATA.FactualId = notification_type
        }
        else{
            K_INNERUSER_DATA.FactualId = ""
        }
        var isfromreview = ""
        if K_INNERUSER_DATA.InviteStatus == "rate_last_transaction"{
            // SVProgressHUD.dismiss()
            // isfromreview = "yes"
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            //            vc.isFromReview = isfromreview
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            self.notificationStatusRequest(id: self.notificationId as NSString, status:  self.statusRead as NSString, userId: self.user_Id, stranger_id: self.stranger_Id)
        }
        else if K_INNERUSER_DATA.InviteStatus == "bank_update" {
            isfromreview = "no"
            //            let vc = BankAccountViewController()
            //            self.navigationController?.pushViewController(vc, animated: true)
            self.notificationStatusRequest(id: self.notificationId as NSString, status:  self.statusRead as NSString, userId: self.user_Id, stranger_id: self.stranger_Id)
        }
            
        else{
            isfromreview = "no"
            self.notificationStatusRequest(id: self.notificationId as NSString, status:  self.statusRead as NSString, userId: self.user_Id, stranger_id: self.stranger_Id)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell , forRowAt indexPath: IndexPath)
    {
        
        
        let lastElement = self.RecvarrNotification.count
        if  !(indexPath.row + 1 < lastElement)  && isloading == false
        {
            
            if Reachability.isConnectedToNetwork() == true
            {
                if self.RecvarrNotification.count >= 10{
                    isloading = true
                    pageNo = pageNo + 1
                    self.loadTableViewData()
                }
            }
            else{
                
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
        //  print("indexpath for the last call is \(indexPath.row)")
        
    }
    func Delte_Notification(id:String,index:Int,indexPath:IndexPath)  {
        if Reachability.isConnectedToNetwork() == true
        {
            
            let parameter = ["ID" :id]
            // print(parameter)
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
            DataManager.sharedManager.DeleteNotificationStatus(params: parameter) { (response) in
                
                
                // print("Invite Status Response",response)
                
                // self.tableView.reloadData()
                if let dataDic = response as? [String:Any]
                    
                {
                    
                    //  self.loadTableViewData()
                    self.RecvarrNotification.remove(at: index)
                    if self.RecvarrNotification.count > 0 {
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true //code added
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        
                    }
                    else{
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                        self.showNotificationMessage()
                    }
                    
                    
                    
                }
                else{
                    //                SVProgressHUD.dismiss()
                    //                print(self.RecvarrNotification.count)
                    //                self.RecvarrNotification.remove(at: index)
                    //                if self.RecvarrNotification.count > 0 {
                    //                    self.view.isUserInteractionEnabled = true //code added
                    //                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    //
                    //                }
                    //                else
                    //                {
                    //                    self.tableView.reloadData()
                    //                    self.view.isUserInteractionEnabled = true //code added
                    //                    self.showNotificationMessage()
                    //                }
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
    
    
    func HitNotificationInviteStatus(frindId:String , userID:String)  {
        
        let parameter = ["user_id" :userID, "friend_id":frindId]
        //  print(parameter)
        DataManager.sharedManager.notificationInviteStatus(params: parameter) { (response) in
            
            
            
            // print("Invite Status Response",response)
            if let dataDic = response as? [String:Any]
                
            {
                if let valData  = dataDic["data"] as? String {
                    
                    // print("message---",dataDic)
                    if valData == "SEND_BY_STRANGER"{     //Done
                        K_INNERUSER_DATA.requestStatus = ""
                        let profile = NotificationsUserProfileViewController()
                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        // profile.friendId = id as String
                        
                        
                        
                        
                        profile.screenName = ""
                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "SEND_BY_USER"{
                        let profile = UserProfileViewController()
                        profile.screenName = "Invite"
                        //  profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        self.navigationController?.pushViewController(profile, animated: true)
                        
                        
                        //                        let profile = NotificationsUserProfileViewController()
                        //                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        //                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        //                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        //
                        //                        profile.screenName = ""
                        //                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    if valData == "REQUEST_NOT_SEND"{           //Done
                        
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
                    if valData == "REQUEST_APPROVED"{      // Done
                        
                        // Open The User Profile Screen
                        /* code commented by ashish
                         let profile = UserAddedProfileViewController()
                         profile.screenName = "InviteAdded"
                         */
                        // code added
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let profile = storyboard.instantiateViewController(withIdentifier: "RInnerCircleAddedUserProfileVc") as! RInnerCircleAddedUserProfileVc
                        // end of code added
                        
                        //  print("Data is profile ",profileDict)
                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        profile.userObjId =  K_INNERUSER_DATA.UserIdGlobal
                        //            profile.friendId = self.users[indexPath.row]["fnd_obj"] as! String
                        //            profile.userObjId  = self.users[indexPath.row]["user_obj"] as! String
                        self.navigationController?.pushViewController(profile, animated: true)
                        //                        let profile = NotificationsUserProfileViewController()
                        //                        profile.userObjectId = K_INNERUSER_DATA.UserIdGlobal
                        //                        profile.friendId = K_INNERUSER_DATA.FriendIdGlobal
                        //                        K_INNERUSER_DATA.requestStatus = "REQUEST_APPROVED"
                        //                        // profile.friendId = self.filteredUsers[indexPath.row]["_id"] as! String
                        //                        // profile.friendId = id as String
                        //                        profile.screenName = ""
                        //                        //    self.navigationController?.pushViewController(profile, animated: true)
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
                    self.view.isUserInteractionEnabled = true
                }
            }
            else{
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
                
            }
            
        }
        
        
        
        
    }
    
    
    func notificationStatusRequest(id:NSString, status : NSString,userId:String,stranger_id :String)
    {
        let parameter = ["ID" :id, "status":"READED"]
        print(parameter)
        DataManager.sharedManager.notificationStatusApi(params: parameter) { (response) in
            
            
            if let message = response as? String
                
            {
                if message == ""{
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
                    
                }
                else{
                    
                    // update push notification badge count
                    
                    DispatchQueue.global().async {
                        self.NotificationCountMethod()
                        
                        DispatchQueue.main.async(execute: {
                            
                        })
                    }
                    
                    
                    if K_INNERUSER_DATA.InviteStatus == "inner_circle"{
                        
                        self.HitNotificationInviteStatus(frindId: K_INNERUSER_DATA.FriendIdGlobal, userID: K_INNERUSER_DATA.UserIdGlobal)
                        
                    }
                    else if K_INNERUSER_DATA.InviteStatus == "bank_update" {
                        //code added
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        let vc = BankAccountViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        //code added
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
                        vc.isFromReview = "yes"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
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
                self.view.isUserInteractionEnabled = true
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
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell , forRowAt indexPath: IndexPath)
    //    {
    //
    //        let lastElement = self.RecvarrNotification.count
    //        if  !(indexPath.row + 1 < lastElement)  && isloading == false
    //        {
    //            isloading = true
    //            pageNo = pageNo + 1
    //            if self.RecvarrNotification.count >= 10{
    //                self.loadTableViewData()
    //            }
    //
    //
    //        }
    //        print("indexpath for the last call is \(indexPath.row)")
    //
    //    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        self.titleLabel.isHidden = true
        self.RecvarrNotification.removeAll()
        self.RecvarrPageNotification.removeAll()
        self.tableView.reloadData()
        self.pageNo = 1
        self.view.isUserInteractionEnabled = true
        super.viewWillDisappear(animated)
    }
    
    
}







